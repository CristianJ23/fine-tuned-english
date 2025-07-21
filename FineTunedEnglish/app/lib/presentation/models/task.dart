import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fechaEntrega;
  final double puntajeDisponible;

  Task({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaEntrega,
    required this.puntajeDisponible,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      fechaEntrega: (data['fechaEntrega'] as Timestamp).toDate(),
      puntajeDisponible: (data['puntajeDisponible'] as num).toDouble(),
    );
  }

  // Method to convert a Task object into a Map for Firestore (or other JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      // 'id' is typically the document ID in Firestore, not usually stored as a field within the document itself,
      // but if you explicitly want it there, keep it. Otherwise, you'd get the ID from doc.id when fetching.
      // 'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fechaEntrega': Timestamp.fromDate(fechaEntrega), // Convert DateTime to Firestore Timestamp
      'puntajeDisponible': puntajeDisponible,
    };
  }
}