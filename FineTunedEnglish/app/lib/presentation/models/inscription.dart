import 'package:cloud_firestore/cloud_firestore.dart';

class Inscription {
  final String id;
  final String estudianteId;
  final String subNivelId;
  final String nivelInglesId;
  final DateTime fechaInscripcion;
  final String estado;
  final double? notaFinal;
  final double? costoPagado;

  Inscription({
    required this.id,
    required this.estudianteId,
    required this.subNivelId,
    required this.nivelInglesId,
    required this.fechaInscripcion,
    required this.estado,
    this.notaFinal,
    this.costoPagado,
  });

  factory Inscription.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Inscription(
      id: doc.id,
      estudianteId: data['estudianteId'] ?? '',
      subNivelId: data['subNivelId'] ?? '',
      nivelInglesId: data['nivelInglesId'] ?? '',
      fechaInscripcion: (data['fechaInscripcion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      estado: data['estado'] ?? 'desconocido',
      // Convertir explícitamente a double si es necesario, aunque `as num?` ya lo hace bien
      notaFinal: (data['notaFinal'] as num?)?.toDouble(),
      costoPagado: (data['costoPagado'] as num?)?.toDouble(),
    );
  }

  // AÑADIMOS EL MÉTODO toJson() para guardar en Firestore más fácilmente
  Map<String, dynamic> toJson() {
    return {
      'estudianteId': estudianteId,
      'subNivelId': subNivelId,
      'nivelInglesId': nivelInglesId,
      'fechaInscripcion': Timestamp.fromDate(fechaInscripcion),
      'estado': estado,
      'notaFinal': notaFinal,
      'costoPagado': costoPagado,
    };
  }
}