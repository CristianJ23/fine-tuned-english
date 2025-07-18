import 'package:cloud_firestore/cloud_firestore.dart';

class Estudiante {
  final String? id;
  final String nombres;
  final String apellidos;
  final String email;
  final int cedula;
  final String telefono;
  final String nivelEducacion;
  final DateTime fechaNacimiento;

  Estudiante({
    this.id,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.cedula,
    required this.telefono,
    required this.nivelEducacion,
    required this.fechaNacimiento,
  });

  factory Estudiante.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, [SnapshotOptions? options]) {
    final data = snapshot.data();
    if (data == null) throw StateError('Missing data for Estudiante document ${snapshot.id}');
    return Estudiante(
      id: snapshot.id,
      nombres: data['nombres'] as String,
      apellidos: data['apellidos'] as String,
      email: data['email'] as String,
      cedula: data['cedula'] as int,
      telefono: data['telefono'] as String,
      nivelEducacion: data['nivel_educacion'] as String,
      fechaNacimiento: (data['fecha_nacimiento'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'cedula': cedula,
      'telefono': telefono,
      'nivel_educacion': nivelEducacion,
      'fecha_nacimiento': Timestamp.fromDate(fechaNacimiento),
    };
  }
}