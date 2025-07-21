import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class Asistencia {
  final String estado;
  final String estudianteId;
  final DateTime fecha;
  final String inscripcionId;

  Asistencia({
    required this.estado,
    required this.estudianteId,
    required this.fecha,
    required this.inscripcionId,
  });

  // Factory constructor for creating an Asistencia from a Firestore DocumentSnapshot
  factory Asistencia.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Asistencia(
      estado: data['estado'] ?? '', // Provide default values for safety
      estudianteId: data['estudianteId'] ?? '',
      // Convert Firestore Timestamp to DateTime
      fecha: (data['fecha'] as Timestamp).toDate(),
      inscripcionId: data['inscripcionId'] ?? '',
    );
  }

  // Factory constructor for creating an Asistencia from a general Map (e.g., from other JSON sources)
  // This is optional if you only ever fetch attendance from Firestore.
  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      estado: json['estado'],
      estudianteId: json['estudianteId'],
      // Assuming 'fecha' is a string that can be parsed directly to DateTime if not from Firestore
      fecha: DateTime.parse(json['fecha'].split(',')[0].trim()),
      inscripcionId: json['inscripcionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estado': estado,
      'estudianteId': estudianteId,
      // Convert DateTime to Firestore Timestamp for saving
      'fecha': Timestamp.fromDate(fecha),
      'inscripcionId': inscripcionId,
    };
  }
}