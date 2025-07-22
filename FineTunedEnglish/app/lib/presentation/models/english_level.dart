import 'package:cloud_firestore/cloud_firestore.dart';

class EnglishLevel {
  final String id;
  final String name;
  final String description;
  final int minAge;
  final int maxAge;
  final String tipo; // <-- CAMPO NUEVO

  EnglishLevel({
    required this.id,
    required this.name,
    required this.description,
    required this.minAge,
    required this.maxAge,
    required this.tipo, // <-- CAMPO NUEVO
  });

  factory EnglishLevel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EnglishLevel(
      id: doc.id,
      name: data['nombre'] ?? 'Sin Nombre',
      description: data['descripcion'] ?? 'Sin Descripción',
      minAge: data['edadMinima'] ?? 0,
      maxAge: data['edadMaxima'] ?? 99,
      tipo: data['tipo'] ?? 'General', // <-- CAMPO NUEVO
    );
  }
}