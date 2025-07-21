import 'package:cloud_firestore/cloud_firestore.dart';

class Usuarios {
  final String id; // El UID de Firebase Auth
  final String email;
  final String password;
  final String nombres;
  final String apellidos;
  final String numeroCedula;
  final String telefono;
  final DateTime fechaNacimiento;
  final String rol; // "estudiante" o "representante"

  // Campos específicos de estudiante (pueden ser nulos si el rol es "representante")
  final String? nivelEducacion;
  final String? representanteId;

  Usuarios({
    required this.id,
    required this.email,
    required this.password,
    required this.nombres,
    required this.apellidos,
    required this.numeroCedula,
    required this.telefono,
    required this.fechaNacimiento,
    required this.rol,
    this.nivelEducacion,
    this.representanteId,
  });

  factory Usuarios.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Usuarios(
      id: doc.id,
      email: data['email'] ?? '',
      password: data['password'] ?? '',
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

  factory Usuarios.fromJson(Map<String, dynamic> json) {
    return Usuarios(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      numeroCedula: json['numeroCedula'] ?? '',
      telefono: json['telefono'] ?? '',
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.parse(json['fechaNacimiento'].toString().split(',')[0].trim())
          : DateTime.now(),
      rol: json['rol'] ?? 'estudiante',
      nivelEducacion: json['nivelEducacion'],
      representanteId: json['representanteId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'nombres': nombres,
      'apellidos': apellidos,
      'numeroCedula': numeroCedula,
      'telefono': telefono,
      'fechaNacimiento': Timestamp.fromDate(fechaNacimiento),
      'rol': rol,
    };

    if (nivelEducacion != null) {
      data['nivelEducacion'] = nivelEducacion;
    }
    if (representanteId != null) {
      data['representanteId'] = representanteId;
    }

    return data;
  }
}