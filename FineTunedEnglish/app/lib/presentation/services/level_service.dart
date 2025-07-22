import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/english_level.dart';
import '../models/sub_level.dart';

class LevelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<List<EnglishLevel>> getAvailableLevels(DateTime birthDate) async {
    final age = _calculateAge(birthDate);
    try {
      final querySnapshot = await _firestore.collection('nivelesIngles').where('edadMinima', isLessThanOrEqualTo: age).get();
      return querySnapshot.docs
          .map((doc) => EnglishLevel.fromFirestore(doc))
          .where((level) => level.maxAge >= age)
          .toList();
    } catch (e) {
      print("Error obteniendo niveles: $e");
      return [];
    }
  }

  Future<List<SubLevel>> getSubLevelsForLevel(String levelId) async {
    try {
      final querySnapshot = await _firestore.collection('nivelesIngles').doc(levelId).collection('subNiveles').get();
      return querySnapshot.docs.map((doc) => SubLevel.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error obteniendo subniveles: $e");
      return [];
    }
  }
  Future<List<String>> getProgramTypes() async {
    try {
      final querySnapshot = await _firestore.collection('nivelesIngles').get();
      final types = querySnapshot.docs.map((doc) => doc['tipo'] as String).toSet().toList();
      return types;
    } catch (e) {
      print("Error obteniendo tipos de programa: $e");
      return [];
    }
  }
}