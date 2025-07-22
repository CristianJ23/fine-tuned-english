import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/representative.dart';

class RepresentativeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('usuarios');

  Future<String> findOrCreateRepresentative(Representative representative) async {
    try {
      final querySnapshot = await _usersCollection
          .where('numeroCedula', isEqualTo: representative.numeroCedula)
          .where('rol', isEqualTo: 'representante')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await _usersCollection.doc(docId).update(representative.toFirestore());
        return docId;
      } else {
        final docRef = await _usersCollection.add(representative.toFirestore());
        return docRef.id;
      }
    } catch (e) {
      print('Error en findOrCreateRepresentative: $e');
      throw Exception('No se pudo guardar la información del representante.');
    }
  }
  
  Future<void> linkStudentToRepresentative({required String studentId, required String representativeId}) async {
    try {
      await _usersCollection.doc(studentId).update({
        'representanteId': representativeId
      });
    } catch(e) {
      print('Error al enlazar estudiante con representante: $e');
      throw Exception('No se pudo actualizar la información del estudiante.');
    }
  }

  Future<Representative?> getRepresentativeById(String id) async {
    try {
      final doc = await _firestore.collection('usuarios').doc(id).get();
      if(doc.exists) {
        return Representative.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error al obtener representante: $e');
      return null;
    }
  }
}