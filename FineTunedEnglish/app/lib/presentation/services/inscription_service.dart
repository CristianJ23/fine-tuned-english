import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/english_level.dart';
import '../models/inscription.dart';
import '../models/sub_level.dart';
import '../models/enrolled_course.dart';

class InscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> createInscription({
    required String studentId,
    required String subLevelId,
    required String levelId,
    required double costPaid,
  }) async {
    final subLevelRef = _firestore
        .collection('nivelesIngles')
        .doc(levelId)
        .collection('subNiveles')
        .doc(subLevelId);
        
    try {
      await _firestore.runTransaction((transaction) async {
        final subLevelDoc = await transaction.get(subLevelRef);
        if (!subLevelDoc.exists) {
          throw Exception("¡El curso seleccionado ya no existe!");
        }
        
        int currentSlots = subLevelDoc.data()!['cuposDisponibles'] ?? 0;
        
        if (currentSlots <= 0) {
          throw Exception("¡Lo sentimos, ya no hay cupos disponibles para este horario!");
        }

        transaction.update(subLevelRef, {'cuposDisponibles': FieldValue.increment(-1)});

        final inscriptionRef = _firestore.collection('inscripciones').doc();
        transaction.set(inscriptionRef, {
          'estudianteId': studentId,
          'subNivelId': subLevelId,
          'nivelInglesId': levelId,
          'fechaInscripcion': Timestamp.now(),
          'estado': 'Activa',
          'notaFinal': null,
          'costoPagado': costPaid,
        });
      });
      return null;
    } catch (e) {
      print("Error al crear inscripción: $e");
      return e.toString();
    }
  }
  
  Future<List<EnrolledCourse>> getEnrolledCoursesForStudent(String studentId) async {
    List<EnrolledCourse> enrolledCourses = [];
    try {
      final inscriptionSnapshot = await _firestore
          .collection('inscripciones')
          .where('estudianteId', isEqualTo: studentId)
          .where('estado', isEqualTo: 'Activa')
          .orderBy('fechaInscripcion', descending: true)
          .get();

      for (var inscriptionDoc in inscriptionSnapshot.docs) {
        final inscription = Inscription.fromFirestore(inscriptionDoc);
        
        final levelRef = _firestore.collection('nivelesIngles').doc(inscription.nivelInglesId);
        final subLevelRef = levelRef.collection('subNiveles').doc(inscription.subNivelId);
        
        final levelDoc = await levelRef.get();
        final subLevelDoc = await subLevelRef.get();
        
        if(levelDoc.exists && subLevelDoc.exists) {
          final level = EnglishLevel.fromFirestore(levelDoc); 
          final subLevel = SubLevel.fromFirestore(subLevelDoc);
          
          enrolledCourses.add(EnrolledCourse(
            inscription: inscription,
            level: level,
            subLevel: subLevel
          ));
        }
      }
      return enrolledCourses;
    } catch(e) {
      print("Error obteniendo cursos inscritos: $e");
      return [];
    }
  }
}