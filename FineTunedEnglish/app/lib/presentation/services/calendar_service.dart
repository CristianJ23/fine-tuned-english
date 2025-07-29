import 'package:cloud_firestore/cloud_firestore.dart';

// Asegúrate de que todas estas rutas de modelos sean correctas para tu proyecto
import '../models/calendar_event.dart';
import '../models/inscription.dart';
import '../models/task.dart';
import '../models/reminder.dart';

class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Método principal que obtiene todos los eventos (académicos y personales) para un estudiante.
  Future<Map<DateTime, List<CalendarEvent>>> getEventsForStudent(String studentId) async {
    try {
      // Usamos Future.wait para ejecutar ambas consultas en paralelo, mejorando el rendimiento.
      final results = await Future.wait([
        _getAcademicEvents(studentId),
        _getPersonalReminders(studentId),
      ]);

      final academicEvents = results[0];
      final personalReminders = results[1];
      
      // Combinamos los resultados en un único mapa.
      final allEvents = Map<DateTime, List<CalendarEvent>>.from(academicEvents);
      
      personalReminders.forEach((date, reminders) {
        if (allEvents.containsKey(date)) {
          // Si ya hay eventos académicos para esa fecha, añadimos los personales a la misma lista.
          allEvents[date]!.addAll(reminders);
        } else {
          // Si no había nada para esa fecha, creamos una nueva entrada en el mapa.
          allEvents[date] = reminders;
        }
      });

      return allEvents;

    } catch(e) {
      print("Error obteniendo eventos del calendario: $e");
      return {}; // Devolvemos un mapa vacío en caso de error para evitar que la app falle.
    }
  }

  // --- MÉTODOS PRIVADOS PARA MEJOR ORGANIZACIÓN ---

  /// Obtiene eventos relacionados con los cursos del estudiante: tareas y asistencias.
  Future<Map<DateTime, List<CalendarEvent>>> _getAcademicEvents(String studentId) async {
    Map<DateTime, List<CalendarEvent>> academicEvents = {};
      
    // 1. Obtener todas las inscripciones activas del estudiante.
    final inscriptionSnapshot = await _firestore
        .collection('inscripciones')
        .where('estudianteId', isEqualTo: studentId)
        .where('estado', isEqualTo: 'Activa')
        .get();

    final inscriptions = inscriptionSnapshot.docs.map((doc) => Inscription.fromFirestore(doc)).toList();

    // Iteramos sobre cada inscripción para buscar sus eventos asociados.
    for (final inscription in inscriptions) {
      // 2. Para cada inscripción, obtener las asistencias y faltas.
      final attendanceSnapshot = await _firestore
          .collection('asistencias')
          .where('inscripcionId', isEqualTo: inscription.id)
          .get();
      
      for (final doc in attendanceSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final date = (data['fecha'] as Timestamp).toDate();
        final eventDate = DateTime.utc(date.year, date.month, date.day);
        
        final event = CalendarEvent(
          documentId: doc.id, // Guardamos el ID por si se necesita
          title: data['estado'] == 'falta' ? 'Falta no justificada' : 'Asistencia registrada',
          type: data['estado'] == 'falta' ? CalendarEventType.falta : CalendarEventType.asistencia,
          date: eventDate,
        );
        
        // Añadimos el evento al mapa en la fecha correspondiente.
        (academicEvents[eventDate] ??= []).add(event);
      }

      // 3. Para cada inscripción, obtener las fechas de entrega de tareas.
      final taskSnapshot = await _firestore
        .collection('nivelesIngles').doc(inscription.nivelInglesId)
        .collection('subNiveles').doc(inscription.subNivelId)
        .collection('tareas').get();
      
      for (final doc in taskSnapshot.docs) {
        final task = Task.fromFirestore(doc);
        final date = task.fechaEntrega;
        final eventDate = DateTime.utc(date.year, date.month, date.day);

        final event = CalendarEvent(
          documentId: task.id, // Guardamos el ID de la tarea
          title: 'Entrega: ${task.titulo}',
          description: task.descripcion,
          type: CalendarEventType.tarea,
          date: eventDate,
        );
        
        (academicEvents[eventDate] ??= []).add(event);
      }
    }
    return academicEvents;
  }
  
  /// Obtiene solo los recordatorios personales creados por el usuario.
  Future<Map<DateTime, List<CalendarEvent>>> _getPersonalReminders(String studentId) async {
    Map<DateTime, List<CalendarEvent>> reminderEvents = {};
    
    final reminderSnapshot = await _firestore.collection('recordatorios')
        .where('estudianteId', isEqualTo: studentId).get();
        
    for (final doc in reminderSnapshot.docs) {
      final reminder = Reminder.fromFirestore(doc);
      final eventDate = DateTime.utc(reminder.fecha.year, reminder.fecha.month, reminder.fecha.day);
      
      final event = CalendarEvent(
        documentId: reminder.id, // ¡Importante! Pasamos el ID del documento
        title: reminder.titulo,
        description: reminder.descripcion,
        type: CalendarEventType.recordatorio,
        date: eventDate
      );
      
      (reminderEvents[eventDate] ??= []).add(event);
    }
    
    return reminderEvents;
  }
}