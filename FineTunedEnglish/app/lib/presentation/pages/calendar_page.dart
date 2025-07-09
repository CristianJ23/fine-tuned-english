import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, String> statusMap = {
    DateTime.utc(2025, 7, 1): 'falta',
    DateTime.utc(2025, 7, 2): 'deber',
    DateTime.utc(2025, 7, 3): 'asistencia',
    DateTime.utc(2025, 7, 4): 'recordatorio',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 20),
            if (_selectedDay != null) _buildDayInfoSection(_selectedDay!),
            const SizedBox(height: 20),
            _buildLegendCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(color: Colors.red),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _) {
            final key = DateTime.utc(day.year, day.month, day.day);
            final status = statusMap[key];

            Color? bgColor;
            Color textColor = Colors.black;

            switch (status) {
              case 'falta':
                bgColor = Colors.redAccent;
                textColor = Colors.white;
                break;
              case 'deber':
                bgColor = Colors.purple;
                textColor = Colors.white;
                break;
              case 'asistencia':
                bgColor = Colors.indigo;
                textColor = Colors.white;
                break;
              case 'recordatorio':
                bgColor = Colors.green;
                textColor = Colors.white;
                break;
            }

            final isSelected = isSameDay(_selectedDay, day);

            return Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : bgColor,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.deepPurple, width: 2)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: isSelected ? Colors.black : textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayInfoSection(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);
    final status = statusMap[key];

    IconData icon;
    String title;
    String message;
    Color color;

    switch (status) {
      case 'falta':
        icon = Icons.warning_amber_rounded;
        title = "Falta injustificada";
        message = "Pulsa para justificar esta falta.";
        color = Colors.redAccent;
        break;
      case 'deber':
        icon = Icons.book;
        title = "Fecha de Entrega";
        message = "Tienes un deber asignado este día.";
        color = Colors.purple;
        break;
      case 'asistencia':
        icon = Icons.check_circle;
        title = "Asistencia";
        message = "Asistencia registrada correctamente.";
        color = Colors.indigo;
        break;
      case 'recordatorio':
        icon = Icons.notifications;
        title = "Recordatorio";
        message = "Tienes algo pendiente este día.";
        color = Colors.green;
        break;
      default:
        icon = Icons.info_outline;
        title = "Sin eventos";
        message = "No hay eventos registrados para esta fecha.";
        color = Colors.grey;
    }

    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          '$title (${day.toLocal().toString().split(" ")[0]})',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        subtitle: Text(message),
        onTap: status == 'falta' ? () => _justificarFalta(day) : null,
      ),
    );
  }

  Widget _buildLegendCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF213354),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.purple, size: 12),
                SizedBox(width: 6),
                Text("Fecha de Entrega", style: TextStyle(color: Colors.white))
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.redAccent, size: 12),
                SizedBox(width: 6),
                Text("Faltas no Justificadas", style: TextStyle(color: Colors.white))
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.indigo, size: 12),
                SizedBox(width: 6),
                Text("Asistencia", style: TextStyle(color: Colors.white))
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 12),
                SizedBox(width: 6),
                Text("Recordatorio", style: TextStyle(color: Colors.white))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _justificarFalta(DateTime day) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Justificar falta"),
        content: Text("¿Deseas justificar la falta del ${day.toLocal().toString().split(" ")[0]}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Falta justificada correctamente')),
              );
              // Aquí podrías actualizar el estado en statusMap o en tu backend
            },
            child: const Text("Justificar"),
          ),
        ],
      ),
    );
  }
}
