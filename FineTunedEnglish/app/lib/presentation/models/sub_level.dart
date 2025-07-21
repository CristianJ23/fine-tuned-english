
// sub_level.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class SubLevel {
  final String id;
  final String name;
  final String dias;
  final String horas;
  final double costo;
  final int cuposDisponibles;
  final int cuposTotales;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String? paralelo;

  SubLevel({
    required this.id,
    required this.name,
    required this.dias,
    required this.horas,
    required this.costo,
    required this.cuposDisponibles,
    required this.cuposTotales,
    required this.fechaInicio,
    required this.fechaFin,
    this.paralelo,
  });

  factory SubLevel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SubLevel(
      id: doc.id,
      name: data['nombre'] ?? '',
      dias: data['dias'] ?? '',
      horas: data['horas'] ?? '',
      costo: (data['costo'] as num?)?.toDouble() ?? 0.0,
      cuposDisponibles: data['cuposDisponibles'] ?? 0,
      cuposTotales: data['cuposTotales'] ?? 0,
      fechaInicio: (data['fechaInicio'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fechaFin: (data['fechaFin'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paralelo: data['paralelo'],
    );
  }
}
