import 'package:flutter/material.dart';

// ===== CORRECCIÓN AQUÍ =====
enum CalendarEventType { tarea, asistencia, falta, recordatorio }
// ==========================

class CalendarEvent {
  final String? documentId;
  final String title;
  final String? description;
  final CalendarEventType type;
  final DateTime date;


  CalendarEvent({
    this.documentId,
    required this.title,
    this.description,
    required this.type,
    required this.date,
  });

  // Helper para obtener el color asociado a cada tipo de evento
  Color get color {
    switch (type) {
      case CalendarEventType.tarea: return Colors.purple;
      case CalendarEventType.asistencia: return Colors.indigo;
      case CalendarEventType.falta: return Colors.redAccent;
      // ===== AÑADIMOS EL NUEVO CASO AQUÍ =====
      case CalendarEventType.recordatorio: return Colors.green;
      default: return Colors.grey;
    }
  }

  // Helper para obtener el icono asociado
  IconData get icon {
     switch (type) {
      case CalendarEventType.tarea: return Icons.book;
      case CalendarEventType.asistencia: return Icons.check_circle;
      case CalendarEventType.falta: return Icons.warning_amber_rounded;
      // ===== Y TAMBIÉN AQUÍ =====
      case CalendarEventType.recordatorio: return Icons.notifications;
      default: return Icons.info_outline;
    }
  }
}