import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// Asegúrate de que todas estas rutas de import sean correctas para tu proyecto
import '../models/calendar_event.dart';
import '../services/calendar_service.dart';
import '../services/auth_service.dart';
import '../services/reminder_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarPage> {
  // Servicios
  final CalendarService _calendarService = CalendarService();
  final ReminderService _reminderService = ReminderService();

  // Estado de la UI
  bool _isLoading = true;
  String? _errorMessage;

  // Datos del calendario
  late Map<DateTime, List<CalendarEvent>> _events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {};
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final studentId = AuthService.currentUser?.id;
    if (studentId == null) {
      if (mounted) setState(() { _errorMessage = "Usuario no autenticado."; _isLoading = false; });
      return;
    }

    if (!mounted) return;
    if (!_isLoading) setState(() => _isLoading = true);

    final events = await _calendarService.getEventsForStudent(studentId);
    if (mounted) {
      setState(() {
        _events = events;
        _isLoading = false;
      });
    }
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _getEventsForDay(_selectedDay!);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : RefreshIndicator(
                  onRefresh: _loadEvents,
                  child: CustomScrollView(
                    slivers: [
                      _buildSliverCalendar(),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                          child: Text(
                            'Eventos del ${DateFormat('dd MMMM').format(_selectedDay!)}',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF334155)),
                          ),
                        ),
                      ),
                      _buildSliverDayInfoSection(selectedEvents),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildLegendCard(),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(_selectedDay ?? DateTime.now()),
        backgroundColor: const Color(0xFF213354),
        tooltip: 'Añadir Recordatorio',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSliverCalendar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF4F5F7),
      pinned: true,
      expandedHeight: 400.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Card(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: TableCalendar<CalendarEvent>(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2026, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: const Color(0xFF213354), shape: BoxShape.circle),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;
                return Positioned(
                  right: 1, bottom: 1,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(events.length.toString(), style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverDayInfoSection(List<CalendarEvent> events) {
    if (events.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
          child: Row(children: const [ Icon(Icons.check_circle_outline, color: Colors.green), SizedBox(width: 12), Expanded(child: Text("¡Todo en orden! No hay eventos para este día."))]),
        )
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildImprovedEventCard(events[index]),
        childCount: events.length,
      ),
    );
  }

  Widget _buildImprovedEventCard(CalendarEvent event) {
    return Card(
      color: event.color.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showEventDetailsDialog(event),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(radius: 22, backgroundColor: event.color, child: Icon(event.icon, color: Colors.white, size: 20)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(event.type.name.capitalize(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: event.color.withBlue(100))),
                  Text(event.title, style: const TextStyle(color: Colors.black54), maxLines: 2, overflow: TextOverflow.ellipsis),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddReminderDialog(DateTime selectedDate) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Añadir recordatorio para\n${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleController, decoration: const InputDecoration(labelText: "Título", border: OutlineInputBorder()), textCapitalization: TextCapitalization.sentences),
          const SizedBox(height: 16),
          TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Descripción (Opcional)", border: OutlineInputBorder()), textCapitalization: TextCapitalization.sentences),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF213354), foregroundColor: Colors.white),
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();

                final newEvent = CalendarEvent(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
                  type: CalendarEventType.recordatorio,
                  date: selectedDate,
                );
                
                final day = DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day);
                setState(() => (_events[day] ??= []).add(newEvent));
                
                final error = await _reminderService.createReminder(
                  titulo: newEvent.title,
                  descripcion: newEvent.description,
                  fecha: newEvent.date,
                  estudianteId: AuthService.currentUser!.id,
                );
                
                if (mounted && error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                  setState(() => _events[day]?.remove(newEvent));
                } else if(mounted) {
                  _loadEvents();
                }
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditReminderDialog(CalendarEvent eventToEdit) async {
    final titleController = TextEditingController(text: eventToEdit.title);
    final descriptionController = TextEditingController(text: eventToEdit.description);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Recordatorio"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleController, decoration: const InputDecoration(labelText: "Título", border: OutlineInputBorder()), textCapitalization: TextCapitalization.sentences),
          const SizedBox(height: 16),
          TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Descripción (Opcional)", border: OutlineInputBorder()), textCapitalization: TextCapitalization.sentences),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF213354), foregroundColor: Colors.white),
            onPressed: () async {
              final newTitle = titleController.text.trim();
              if (newTitle.isNotEmpty) {
                Navigator.of(context).pop();
                
                final newDesc = descriptionController.text.trim();
                final day = DateTime.utc(eventToEdit.date.year, eventToEdit.date.month, eventToEdit.date.day);
                setState(() {
                  final eventIndex = _events[day]!.indexWhere((e) => e.documentId == eventToEdit.documentId);
                  if (eventIndex != -1) {
                    _events[day]![eventIndex] = CalendarEvent(
                      documentId: eventToEdit.documentId,
                      title: newTitle,
                      description: newDesc.isNotEmpty ? newDesc : null,
                      type: eventToEdit.type,
                      date: eventToEdit.date,
                    );
                  }
                });

                await _reminderService.updateReminder(
                  reminderId: eventToEdit.documentId!,
                  newTitle: newTitle,
                  newDescription: newDesc.isNotEmpty ? newDesc : null,
                );
              }
            },
            child: const Text("Actualizar"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteReminder(CalendarEvent eventToDelete) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Eliminación"),
        content: const Text("¿Estás seguro de que deseas eliminar este recordatorio?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Eliminar", style: TextStyle(color: Colors.red))),
        ],
      )
    );

    if (confirmed == true) {
      final day = DateTime.utc(eventToDelete.date.year, eventToDelete.date.month, eventToDelete.date.day);
      setState(() {
        _events[day]?.removeWhere((e) => e.documentId == eventToDelete.documentId);
        if (_events[day]?.isEmpty ?? false) {
          _events.remove(day);
        }
      });

      await _reminderService.deleteReminder(eventToDelete.documentId!);
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Recordatorio eliminado.")));
    }
  }

  Future<void> _showEventDetailsDialog(CalendarEvent event) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: event.color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Row(children: [
            Icon(event.icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(event.type.name.capitalize(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          Text(event.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          
          if (event.description != null && event.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(event.description!, style: const TextStyle(color: Colors.black54)),
          ],

          const Divider(height: 24),
          _buildDetailRow(Icons.calendar_today_outlined, DateFormat('EEEE, dd MMMM yyyy').format(event.date)),
        ]),
        actions: [
          if (event.type == CalendarEventType.recordatorio) ...[
            IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blue), onPressed: () { Navigator.of(context).pop(); _showEditReminderDialog(event); }, tooltip: 'Editar'),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () { Navigator.of(context).pop(); _deleteReminder(event); }, tooltip: 'Eliminar'),
            const Spacer(),
          ],
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
      ]),
    );
  }
  
  Widget _buildLegendCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Leyenda de Eventos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
            const Divider(height: 20, thickness: 1),
            _buildLegendItem(Colors.purple, "Fecha de Entrega"),
            _buildLegendItem(Colors.redAccent, "Faltas"),
            _buildLegendItem(Colors.indigo, "Asistencia"),
            _buildLegendItem(Colors.green, "Recordatorio Personal"),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12), Text(text),
      ]),
    );
  }
}

extension StringExtension on String {
    String capitalize() {
      if (isEmpty) return this;
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}