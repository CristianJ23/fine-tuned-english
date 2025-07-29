import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  final String id;
  final String titulo;
  final String? descripcion; // Descripción puede ser opcional
  final DateTime fecha;
  final String estudianteId; // Para saber a qué usuario pertenece

  Reminder({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.fecha,
    required this.estudianteId,
  });

  factory Reminder.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reminder(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      estudianteId: data['estudianteId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': Timestamp.fromDate(fecha),
      'estudianteId': estudianteId,
    };
  }
}