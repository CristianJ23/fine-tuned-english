import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Asegúrate de que todas estas rutas de import sean correctas para tu proyecto
import '../models/calendar_event.dart';
import '../models/enrolled_course.dart';
import '../services/calendar_service.dart';
import '../services/auth_service.dart';
import '../services/inscription_service.dart';
import '../services/reminder_service.dart';
import '../services/attendance_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarPage> {
  // --- Estado y Servicios ---
  final CalendarService _calendarService = CalendarService();
  final InscriptionService _inscriptionService = InscriptionService();
  final ReminderService _reminderService = ReminderService();
  final AttendanceService _attendanceService = AttendanceService();
  
  bool _isLoading = true;
  String? _errorMessage;

  late Map<DateTime, List<CalendarEvent>> _events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<EnrolledCourse> _enrolledCourses = [];

  // --- Ciclo de Vida e Inicialización ---
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {};
    initializeDateFormatting('es_ES', null).then((_) => _loadData());
  }

  // --- Lógica de Datos ---
  Future<void> _loadData() async {
    final studentId = AuthService.currentUser?.id;
    if (studentId == null) {
      if (mounted) setState(() { _errorMessage = "Usuario no autenticado."; _isLoading = false; });
      return;
    }
    
    if(!_isLoading && mounted) setState(() => _isLoading = true);
    
    final results = await Future.wait([
        _calendarService.getEventsForStudent(studentId),
        _inscriptionService.getEnrolledCoursesForStudent(studentId)
    ]);
    
    if(mounted) {
      setState(() {
        _events = results[0] as Map<DateTime, List<CalendarEvent>>;
        _enrolledCourses = results[1] as List<EnrolledCourse>;
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

  // --- Build Principal ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : RefreshIndicator(
            onRefresh: _loadData,
            child: CustomScrollView(
              slivers: [
                _buildSliverCalendar(),
                _CalendarHeader(selectedDay: _selectedDay!),
                _buildSliverEventList(),
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
        onPressed: _showCreationOptions,
        backgroundColor: const Color(0xFF213354),
        tooltip: 'Añadir Evento',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- Widgets de la UI ---

  Widget _buildSliverCalendar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF8F9FA),
      pinned: true,
      expandedHeight: 400.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Card(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          elevation: 6.0,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: TableCalendar<CalendarEvent>(
            locale: 'es_ES',
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2026, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true, titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: BoxDecoration(color: const Color(0xFF213354), shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final events = _getEventsForDay(day);
                if (events.isNotEmpty) {
                  Color dayColor = Colors.transparent;
                  if (events.any((e) => e.type == CalendarEventType.falta)) dayColor = Colors.redAccent.withOpacity(0.8);
                  else if (events.any((e) => e.type == CalendarEventType.tarea)) dayColor = Colors.purple.withOpacity(0.8);
                  else if (events.any((e) => e.type == CalendarEventType.asistencia)) dayColor = Colors.indigo.withOpacity(0.8);
                  else if (events.any((e) => e.type == CalendarEventType.recordatorio)) dayColor = Colors.green.withOpacity(0.8);
                  return Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: dayColor, shape: BoxShape.circle),
                    child: Text('${day.day}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  );
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverEventList() {
    final selectedEvents = _getEventsForDay(_selectedDay!);
    if (selectedEvents.isEmpty) {
      return const SliverToBoxAdapter(child: _EmptyStateCard());
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _EventCard(
          event: selectedEvents[index],
          onTap: () => _showEventDetailsDialog(selectedEvents[index]),
        ),
        childCount: selectedEvents.length,
      ),
    );
  }
  
  void _showCreationOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.add_task, color: Colors.indigo),
            title: const Text('Registrar Asistencia o Falta'),
            onTap: () {
              Navigator.pop(context);
              _showAddAttendanceDialog(_selectedDay ?? DateTime.now());
            },
          ),
          ListTile(
            leading: const Icon(Icons.alarm_add, color: Colors.green),
            title: const Text('Añadir Recordatorio Personal'),
            onTap: () {
              Navigator.pop(context);
              _showAddReminderDialog(_selectedDay ?? DateTime.now());
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showAddReminderDialog(DateTime selectedDate) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Añadir recordatorio para\n${DateFormat('dd/MM/yyyy', 'es_ES').format(selectedDate)}"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleController, decoration: const InputDecoration(labelText: "Título", border: OutlineInputBorder()), textCapitalization: TextCapitalization.sentences),
          const SizedBox(height: 16),
          TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Descripción (Opcional)", border: OutlineInputBorder()), textCapitalization: TextCapitalization.sentences, maxLines: 3),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF213354), foregroundColor: Colors.white),
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();
                await _reminderService.createReminder(
                  titulo: titleController.text.trim(),
                  descripcion: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
                  fecha: selectedDate,
                  estudianteId: AuthService.currentUser!.id,
                );
                await _loadData();
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
  
  Future<void> _showAddAttendanceDialog(DateTime selectedDate) async {
    if (_enrolledCourses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Debes estar inscrito en un curso.")));
      return;
    }
    final EnrolledCourse? selectedCourse = await _selectCourseForAttendance();
    if (selectedCourse == null || !mounted) return;
    final String? status = await _selectAttendanceStatus(selectedCourse);
    if (status == null || !mounted) return;
    String? reason;
    if (status == 'falta') {
      reason = await _showJustificationInputDialog();
      if (reason == null) return;
    }
    await _createAttendanceRecord(selectedCourse, status, reason, selectedDate);
  }
  
  Future<EnrolledCourse?> _selectCourseForAttendance() async {
    return showDialog<EnrolledCourse>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Selecciona el curso"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _enrolledCourses.length,
            itemBuilder: (context, index) {
              final course = _enrolledCourses[index];
              return ListTile(title: Text(course.subLevel.name), onTap: () => Navigator.of(context).pop(course));
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar"))],
      ),
    );
  }

  Future<String?> _selectAttendanceStatus(EnrolledCourse course) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Registrar para ${course.subLevel.name}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text("¿Cuál es tu estado para el día seleccionado?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () => Navigator.of(context).pop('asistencia'), child: const Text("Asistencia", style: TextStyle(color: Colors.white))),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), onPressed: () => Navigator.of(context).pop('falta'), child: const Text("Falta", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
  
  Future<String?> _showJustificationInputDialog() async {
    final reasonController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Motivo de la Falta"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: TextField(controller: reasonController, decoration: const InputDecoration(hintText: "Ej: Cita médica", border: OutlineInputBorder()), maxLines: 2, autofocus: true, textCapitalization: TextCapitalization.sentences),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) Navigator.of(context).pop(reasonController.text.trim());
            },
            child: const Text("Confirmar")
          ),
        ],
      ),
    );
  }
  
  Future<void> _createAttendanceRecord(EnrolledCourse course, String status, String? reason, DateTime date) async {
    final error = await _attendanceService.createAttendance(studentId: AuthService.currentUser!.id, inscriptionId: course.inscription.id, date: date, status: status, reason: reason);
    if (mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registro guardado exitosamente"), backgroundColor: Colors.green));
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _showEventDetailsDialog(CalendarEvent event) async {
    final canJustify = event.type == CalendarEventType.falta && (event.description == null || event.description!.isEmpty);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: event.color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Row(children: [Icon(event.icon, color: Colors.white, size: 28), const SizedBox(width: 12), Text(event.type.name.capitalize(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          Text(event.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (event.description != null && event.description!.isNotEmpty) ...[const SizedBox(height: 8), Text((event.type == CalendarEventType.falta ? "Motivo: " : "") + event.description!, style: const TextStyle(color: Colors.black54))],
          const Divider(height: 24),
          _buildDetailRow(Icons.calendar_today_outlined, DateFormat('EEEE, dd MMMM yyyy', 'es_ES').format(event.date)),
        ]),
        actions: [
          if (event.type == CalendarEventType.recordatorio) ...[
            IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent), onPressed: () { Navigator.of(context).pop(); _showEditReminderDialog(event); }, tooltip: 'Editar'),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () { Navigator.of(context).pop(); _deleteReminder(event); }, tooltip: 'Eliminar'),
            const Spacer(),
          ],
          if (canJustify) TextButton(onPressed: () { Navigator.of(context).pop(); _showJustifyAbsenceDialog(event); }, child: const Text("Justificar Falta", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar')),
        ],
      ),
    );
  }
  
  Future<void> _showJustifyAbsenceDialog(CalendarEvent event) async {
    final reasonController = TextEditingController();
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text("Justificar Falta"),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: TextField(controller: reasonController, decoration: const InputDecoration(labelText: "Motivo de la inasistencia", border: OutlineInputBorder()), maxLines: 3, textCapitalization: TextCapitalization.sentences),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
              ElevatedButton(
                onPressed: () async {
                  if (reasonController.text.trim().isNotEmpty) {
                    Navigator.of(context).pop();
                    final error = await _attendanceService.justifyAbsence(attendanceId: event.documentId!, reason: reasonController.text.trim());
                    if (mounted) {
                      if (error == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Falta justificada."), backgroundColor: Colors.green));
                        _loadData();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                      }
                    }
                  }
                },
                child: const Text("Enviar"),
              ),
            ]));
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
          TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Descripción (Opcional)", border: OutlineInputBorder()), textCapitalization: TextCapitalization.sentences, maxLines: 3),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF213354), foregroundColor: Colors.white),
            onPressed: () async {
              final newTitle = titleController.text.trim();
              if (newTitle.isNotEmpty) {
                Navigator.of(context).pop();
                await _reminderService.updateReminder(reminderId: eventToEdit.documentId!, newTitle: newTitle, newDescription: descriptionController.text.trim());
                _loadData();
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text("¿Estás seguro de que deseas eliminar este recordatorio?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text("Eliminar", style: TextStyle(color: Colors.white))),
        ],
      )
    );
    if (confirmed == true) {
      await _reminderService.deleteReminder(eventToDelete.documentId!);
      _loadData();
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Recordatorio eliminado.")));
    }
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: [Icon(icon, color: Colors.grey.shade600, size: 20), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(fontSize: 14)))]),
    );
  }
  
  Widget _buildLegendCard() {
    return Card(
      elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Leyenda", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
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
      child: Row(children: [Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 12), Text(text)]),
    );
  }
}

// --- WIDGETS Y CLASES EXTERNAS ---

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({required this.selectedDay});
  final DateTime selectedDay;
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverHeaderDelegate(
        minHeight: 50, maxHeight: 50,
        child: Container(
          color: const Color(0xFFF8F9FA).withOpacity(0.95),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Text(
            'Eventos del ${DateFormat('dd MMMM yyyy', 'es_ES').format(selectedDay)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF495057)),
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onTap});
  final CalendarEvent event;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    bool isAbsence = event.type == CalendarEventType.falta;
    bool isJustified = isAbsence && (event.description?.isNotEmpty ?? false);

    return Card(
      elevation: 0,
      color: event.color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(children: [
            CircleAvatar(radius: 22, backgroundColor: event.color, child: Icon(event.icon, color: Colors.white, size: 20)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(event.type.name.capitalize(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: event.color.withBlue(100))),
              Text(event.title, style: const TextStyle(color: Colors.black54), maxLines: 2, overflow: TextOverflow.ellipsis),
              if (isAbsence) Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(isJustified ? "Justificada" : "Sin Justificar", style: TextStyle(fontSize: 12, color: isJustified ? Colors.green : Colors.orange.shade700, fontWeight: FontWeight.bold))
              )
            ])),
          ]),
        ),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200, width: 1.5)),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green.shade300, size: 48),
          const SizedBox(height: 12),
          const Text("¡Todo en orden!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("No hay eventos programados para este día.", style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  _SliverHeaderDelegate({required this.child, required this.minHeight, required this.maxHeight});
  @override double get minExtent => minHeight;
  @override double get maxExtent => maxHeight;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);
  @override bool shouldRebuild(_SliverHeaderDelegate oldDelegate) => false;
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}