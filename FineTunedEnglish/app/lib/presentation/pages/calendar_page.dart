import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/calendar_event.dart';
import '../services/calendar_service.dart';
import '../services/auth_service.dart';
import '../services/reminder_service.dart';
import '../services/attendance_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarPage> {
  final CalendarService _calendarService = CalendarService();
  final ReminderService _reminderService = ReminderService();
  final AttendanceService _attendanceService = AttendanceService();
  
  bool _isLoading = true;
  String? _errorMessage;

  late Map<DateTime, List<CalendarEvent>> _events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // Inicializamos el día seleccionado como UTC para consistencia
    _selectedDay = DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    _events = {};
    initializeDateFormatting('es_ES', null);
    initializeDateFormatting('en_US', null);
    _loadData();
  }

  Future<void> _loadData() async {
    final studentId = AuthService.currentUser?.id;
    if (studentId == null) {
      if (mounted) setState(() { 
        _errorMessage = "errors.notAuthenticated".tr(); 
        _isLoading = false; 
      });
      return;
    }
    
    if(!_isLoading && mounted) setState(() => _isLoading = true);
    
    final eventsData = await _calendarService.getEventsForStudent(studentId);
    
    if(mounted) {
      setState(() {
        _events = eventsData;
        _isLoading = false;
      });
    }
  }
  
  List<CalendarEvent> _getEventsForDay(DateTime day) {
    // La clave de búsqueda siempre debe ser UTC
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  // ===== SOLUCIÓN BUG DÍA ANTERIOR (Punto Clave 1) =====
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Normalizamos el día seleccionado a UTC inmediatamente al hacer clic.
    // Esto asegura que toda la lógica de la página use la fecha correcta.
    final selectedDayUtc = DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
    
    if (!isSameDay(_selectedDay, selectedDayUtc)) {
      setState(() {
        _selectedDay = selectedDayUtc;
        _focusedDay = focusedDay; // focusedDay puede permanecer local, es solo para la vista.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.toStringWithSeparator(separator: '_');

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
                _buildSliverCalendar(currentLocale),
                _CalendarHeader(selectedDay: _selectedDay!, locale: currentLocale),
                _buildSliverEventList(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
        tooltip: 'pages.calendar.addPersonalReminder'.tr(),
        child: const Icon(Icons.alarm_add, color: Colors.white),
      ),
    );
  }

  Widget _buildSliverCalendar(String locale) {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF8F9FA),
      pinned: true,
      // ===== SOLUCIÓN OVERFLOW: Aumentar altura para meses con 6 semanas =====
      expandedHeight: 420.0, 
      flexibleSpace: FlexibleSpaceBar(
        background: Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 4.0,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar<CalendarEvent>(
              locale: locale,
              rowHeight: 46.0, // Controlar la altura de las filas para consistencia
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2026, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              eventLoader: _getEventsForDay,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF213354)),
                leftChevronIcon: const Icon(Icons.chevron_left, color: Color(0xFF213354)),
                rightChevronIcon: const Icon(Icons.chevron_right, color: Color(0xFF213354)),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.grey[600]),
                weekendStyle: const TextStyle(color: Colors.pinkAccent),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                selectedDecoration: const BoxDecoration(color: Color(0xFF213354), shape: BoxShape.circle),
                selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                todayDecoration: BoxDecoration(color: Colors.pink.withOpacity(0.2), shape: BoxShape.circle),
                todayTextStyle: const TextStyle(color: Colors.pink),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 5,
                      child: _buildEventsMarker(day, events),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildEventsMarker(DateTime day, List<CalendarEvent> events) {
    final eventColors = events.map((event) => event.color).toSet();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: eventColors.map((color) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      }).toList(),
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
  
  Future<void> _showAddReminderDialog(DateTime selectedDate) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final currentLocale = context.locale.toStringWithSeparator(separator: '_');
    
    // ===== SOLUCIÓN BUG DÍA ANTERIOR (Punto Clave 2) =====
    // Aseguramos que la fecha que usamos sea UTC, sin importar si vino de _selectedDay (ya UTC)
    // o de DateTime.now() (local).
    final dateForDialog = DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("pages.calendar.addReminderFor".tr(namedArgs: {'date': DateFormat('dd/MM/yyyy', currentLocale).format(dateForDialog)})),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleController, decoration: InputDecoration(labelText: 'common.title'.tr(), border: const OutlineInputBorder()), textCapitalization: TextCapitalization.sentences),
          const SizedBox(height: 16),
          TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'common.descriptionOptional'.tr(), border: const OutlineInputBorder()), textCapitalization: TextCapitalization.sentences, maxLines: 3),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('common.cancel'.tr())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF213354), foregroundColor: Colors.white),
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();

                await _reminderService.createReminder(
                  titulo: titleController.text.trim(),
                  descripcion: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
                  fecha: dateForDialog, // Usamos la fecha UTC asegurada
                  estudianteId: AuthService.currentUser!.id,
                );
                await _loadData();
              }
            },
            child: Text("common.save".tr()),
          ),
        ],
      ),
    );
  }
  
  // (El resto de los métodos no necesitan cambios y se dejan igual)
  Future<void> _showEventDetailsDialog(CalendarEvent event) async {
    final canJustify = event.type == CalendarEventType.falta && (event.description == null || event.description!.isEmpty);
    final currentLocale = context.locale.toStringWithSeparator(separator: '_');
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
          if (event.description != null && event.description!.isNotEmpty) ...[const SizedBox(height: 8), Text((event.type == CalendarEventType.falta ? "${'pages.calendar.reasonForAbsence'.tr()}: " : "") + event.description!, style: const TextStyle(color: Colors.black54))],
          const Divider(height: 24),
          _buildDetailRow(Icons.calendar_today_outlined, DateFormat('EEEE, dd MMMM yyyy', currentLocale).format(event.date)),
        ]),
        actions: [
          if (event.type == CalendarEventType.recordatorio) ...[
            IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent), onPressed: () { Navigator.of(context).pop(); _showEditReminderDialog(event); }, tooltip: 'common.update'.tr()),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () { Navigator.of(context).pop(); _deleteReminder(event); }, tooltip: 'common.delete'.tr()),
            const Spacer(),
          ],
          if (canJustify) TextButton(onPressed: () { Navigator.of(context).pop(); _showJustifyAbsenceDialog(event); }, child: Text("pages.calendar.justifyAbsence".tr(), style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('common.close'.tr())),
        ],
      ),
    );
  }
  
  Future<void> _showJustifyAbsenceDialog(CalendarEvent event) async {
    final reasonController = TextEditingController();
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("pages.calendar.justifyAbsenceTitle".tr()),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: TextField(controller: reasonController, decoration: InputDecoration(labelText: 'pages.calendar.reasonForAbsence'.tr(), border: const OutlineInputBorder()), maxLines: 3, textCapitalization: TextCapitalization.sentences),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("common.cancel".tr())),
              ElevatedButton(
                onPressed: () async {
                  if (reasonController.text.trim().isNotEmpty) {
                    Navigator.of(context).pop();
                    final error = await _attendanceService.justifyAbsence(attendanceId: event.documentId!, reason: reasonController.text.trim());
                    if (mounted) {
                      if (error == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pages.calendar.absenceJustified'.tr()), backgroundColor: Colors.green));
                        _loadData();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                      }
                    }
                  }
                },
                child: Text("common.send".tr()),
              ),
            ]));
  }

  Future<void> _showEditReminderDialog(CalendarEvent eventToEdit) async {
    final titleController = TextEditingController(text: eventToEdit.title);
    final descriptionController = TextEditingController(text: eventToEdit.description);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("pages.calendar.editReminder".tr()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleController, decoration: InputDecoration(labelText: 'common.title'.tr(), border: const OutlineInputBorder()), textCapitalization: TextCapitalization.sentences),
          const SizedBox(height: 16),
          TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'common.descriptionOptional'.tr(), border: const OutlineInputBorder()), textCapitalization: TextCapitalization.sentences, maxLines: 3),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("common.cancel".tr())),
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
            child: Text("common.update".tr()),
          ),
        ],
      ),
    );
  }
  
  Future<void> _deleteReminder(CalendarEvent eventToDelete) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("pages.calendar.confirmDeletion".tr()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text("pages.calendar.confirmDeleteReminderMessage".tr()),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text("common.cancel".tr())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true), 
            child: Text("common.delete".tr(), style: const TextStyle(color: Colors.white))),
        ],
      )
    );
    if (confirmed == true) {
      await _reminderService.deleteReminder(eventToDelete.documentId!);
      _loadData();
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pages.calendar.reminderDeleted'.tr())));
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
            Text("pages.calendar.legend".tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
            const Divider(height: 20, thickness: 1),
            _buildLegendItem(Colors.purple, "pages.calendar.legendDueDate".tr()),
            _buildLegendItem(Colors.redAccent, "pages.calendar.legendAbsences".tr()),
            _buildLegendItem(Colors.indigo, "pages.calendar.legendAttendance".tr()),
            _buildLegendItem(Colors.green, "pages.calendar.legendPersonalReminder".tr()),
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

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({required this.selectedDay, required this.locale});
  final DateTime selectedDay;
  final String locale;
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
            'pages.calendar.eventsOf'.tr(namedArgs: {'date': DateFormat('dd MMMM yyyy', locale).format(selectedDay)}),
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
                child: Text(
                  isJustified ? 'pages.calendar.justified'.tr() : 'pages.calendar.unjustified'.tr(), 
                  style: TextStyle(fontSize: 12, color: isJustified ? Colors.green : Colors.orange.shade700, fontWeight: FontWeight.bold)
                )
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
          Text("pages.calendar.emptyStateTitle".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("pages.calendar.emptyStateMessage".tr(), style: TextStyle(color: Colors.grey.shade600)),
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