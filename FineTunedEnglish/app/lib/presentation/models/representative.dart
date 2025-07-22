import 'package:cloud_firestore/cloud_firestore.dart';

class Representative {
  final String id;
  final String nombres;
  final String apellidos;
  final String email;
  final String numeroCedula;
  final String telefono;
  final DateTime fechaNacimiento;

  Representative({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.numeroCedula,
    required this.telefono,
    required this.fechaNacimiento,
  });

  factory Representative.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Representative(
      id: doc.id,
      nombres: data['nombres'] ?? '',
      apellidos: data['apellidos'] ?? '',
      email: data['email'] ?? '',
      numeroCedula: data['numeroCedula'] ?? '',
      telefono: data['telefono'] ?? '',
      fechaNacimiento: (data['fechaNacimiento'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'numeroCedula': numeroCedula,
      'telefono': telefono,
      'fechaNacimiento': Timestamp.fromDate(fechaNacimiento),
      'rol': 'representante', // Asigna el rol automáticamente
    };
  }
}