import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inscription.dart'; // Asegúrate de que la ruta sea correcta

class InscriptionService {
  final CollectionReference _inscriptionsRef =
  FirebaseFirestore.instance.collection('inscripciones');

  // Método para generar un nuevo ID de documento para Firestore
  String generateNewId() {
    return _inscriptionsRef.doc().id;
  }

  Future<void> guardarInscripcion(Inscription inscripcion) async {
    try {
      // Usamos el método toJson() del modelo Inscription
      await _inscriptionsRef.doc(inscripcion.id).set(inscripcion.toJson());
    } catch (e) {
      throw Exception('Error al guardar inscripción: $e');
    }
  }

  // Opcional: Si quieres obtener una inscripción por ID
  Future<Inscription?> obtenerInscripcion(String inscriptionId) async {
    final doc = await _inscriptionsRef.doc(inscriptionId).get();
    if (doc.exists) {
      return Inscription.fromFirestore(doc);
    }
    return null;
  }

  // Opcional: Si quieres obtener todas las inscripciones de un estudiante
  Stream<List<Inscription>> getInscriptionsForStudent(String studentId) {
    return _inscriptionsRef
        .where('estudianteId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Inscription.fromFirestore(doc))
        .toList());
  }
}