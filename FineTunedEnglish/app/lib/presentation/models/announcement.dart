import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fechaPublicacion;

  Announcement({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaPublicacion,
  });

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      fechaPublicacion: (data['fechaPublicacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}