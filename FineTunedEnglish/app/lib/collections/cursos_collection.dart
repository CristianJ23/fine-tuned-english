
import 'package:cloud_firestore/cloud_firestore.dart';

class Curso {
  final String? id; // `id` es String? porque Firestore lo genera y puede ser null al crear un nuevo objeto
  final String subnivelId;
  final String nombre;
  final String tipo;

  Curso({
    this.id,
    required this.subnivelId,
    required this.nombre,
    required this.tipo,
  });

  // Constructor para crear un objeto Curso desde un DocumentSnapshot de Firestore
  factory Curso.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, [SnapshotOptions? options]) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Missing data for Curso document ${snapshot.id}');
    }
    return Curso(
      id: snapshot.id, // El ID del documento de Firestore
      subnivelId: data['subnivel_id'] as String,
      nombre: data['nombre'] as String,
      tipo: data['tipo'] as String,
    );
  }

  // Método para convertir un objeto Curso a un mapa de Dart para subir a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'subnivel_id': subnivelId,
      'nombre': nombre,
      'tipo': tipo,
    };
  }
}