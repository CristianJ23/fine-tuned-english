import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> createAttendance({
    required String studentId,
    required String inscriptionId,
    required DateTime date,
    required String status,
    String? reason,
  }) async {
    try {
      final existing = await _firestore.collection('asistencias')
        .where('estudianteId', isEqualTo: studentId)
        .where('inscripcionId', isEqualTo: inscriptionId)
        .where('fecha', isEqualTo: Timestamp.fromDate(date))
        .limit(1).get();

      if (existing.docs.isNotEmpty) {
        return "Ya existe un registro de asistencia para este día en este curso.";
      }
      
      await _firestore.collection('asistencias').add({
        'estudianteId': studentId,
        'inscripcionId': inscriptionId,
        'fecha': Timestamp.fromDate(date),
        'estado': status,
        'justificacionMotivo': reason,
      });
      return null;
    } catch(e) {
      print("Error al crear asistencia: $e");
      return "No se pudo guardar el registro de asistencia.";
    }
  }

  Future<String?> justifyAbsence({
    required String attendanceId,
    required String reason,
    String? fileUrl,
  }) async {
    try {
      await _firestore.collection('asistencias').doc(attendanceId).update({
        'justificacionMotivo': reason,
        'justificacionArchivoUrl': fileUrl,
      });
      return null;
    } catch(e) {
      print("Error al justificar la falta: $e");
      return "No se pudo guardar la justificación.";
    }
  }
}