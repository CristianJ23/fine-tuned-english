import 'package:cloud_firestore/cloud_firestore.dart';

// 1. La clase se llama Usuarios consistentemente.
class Usuarios {
  final String id;
  final String email;
  final String nombres;
  final String apellidos;
  final String numeroCedula;
  final String telefono;
  final DateTime fechaNacimiento;
  final String rol;
  final String? nivelEducacion;
  final String? representanteId;
  // El campo password se elimina del modelo, ya que es inseguro.

  Usuarios({
    required this.id,
    required this.email,
    required this.nombres,
    required this.apellidos,
    required this.numeroCedula,
    required this.telefono,
    required this.fechaNacimiento,
    required this.rol,
    this.nivelEducacion,
    this.representanteId,
  });

  // 2. CORREGIDO: El factory ahora crea un objeto 'Usuarios', no 'UserModel'.
  factory Usuarios.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Usuarios(
      id: doc.id,
      email: data['email'] ?? '',
      nombres: data['nombres'] ?? '',
      apellidos: data['apellidos'] ?? '',
      numeroCedula: data['numeroCedula'] ?? '',
      telefono: data['telefono'] ?? '',
      fechaNacimiento: (data['fechaNacimiento'] as Timestamp?)?.toDate() ?? DateTime.now(),
      rol: data['rol'] ?? 'estudiante',
      nivelEducacion: data['nivelEducacion'],
      representanteId: data['representanteId'],
    );
  }
}