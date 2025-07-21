import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String id;
  final String estudianteId;
  final String inscripcionId;
  final DateTime fecha;
  final String estado; // "asistencia" o "falta"
  final String? justificacionMotivo;
  final String? justificacionArchivoUrl;

  Attendance({
    required this.id,
    required this.estudianteId,
    required this.inscripcionId,
    required this.fecha,
    required this.estado,
    this.justificacionMotivo,
    this.justificacionArchivoUrl,
  });

  factory Attendance.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Attendance(
      id: doc.id,
      estudianteId: data['estudianteId'] ?? '',
      inscripcionId: data['inscripcionId'] ?? '',
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      estado: data['estado'] ?? 'desconocido',
      justificacionMotivo: data['justificacionMotivo'],
      justificacionArchivoUrl: data['justificacionArchivoUrl'],
    );
  }
}