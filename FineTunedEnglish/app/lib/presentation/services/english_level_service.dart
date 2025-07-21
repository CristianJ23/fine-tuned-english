// Este servicio maneja la interacción con Firestore para los niveles y subniveles de inglés.
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/english_level.dart'; // Importa el modelo del nivel de inglés
import '../models/sub_level.dart';     // Importa el modelo del subnivel

class EnglishLevelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtiene todos los niveles de inglés de la colección "nivelesingles".
  Future<List<EnglishLevel>> getAllEnglishLevels() async {
    try {
      print('[EnglishLevelService] Intentando obtener todos los niveles de inglés de la colección "nivelesingles".');
      final querySnapshot = await _firestore.collection('nivelesingles').get();
      print('[EnglishLevelService] Documentos obtenidos: ${querySnapshot.docs.length}.');

      if (querySnapshot.docs.isEmpty) {
        print('[EnglishLevelService] La colección "nivelesingles" está vacía o no se pudo acceder.');
      } else {
        for (var doc in querySnapshot.docs) {
          print('  [EnglishLevelService] ID del Documento: ${doc.id}, Datos: ${doc.data()}');
        }
      }
      return querySnapshot.docs.map((doc) => EnglishLevel.fromFirestore(doc)).toList();
    } catch (e) {
      print('[EnglishLevelService] Error en getAllEnglishLevels: $e');
      return [];
    }
  }

  // Obtiene un nivel de inglés específico por su ID.
  Future<EnglishLevel?> getEnglishLevel(String levelId) async {
    try {
      final doc = await _firestore.collection('nivelesingles').doc(levelId).get();
      if (doc.exists) {
        return EnglishLevel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('[EnglishLevelService] Error en getEnglishLevel: $e');
      return null;
    }
  }

  // Obtiene los subniveles para un nivel de inglés específico.
  // La ruta es: 'nivelesingles' -> [levelId] -> 'subNiveles' (subcolección).
  Future<List<SubLevel>> getSubLevelsForEnglishLevel(String levelId) async {
    try {
      print('[EnglishLevelService] Intentando obtener subniveles para el nivel ID: $levelId');
      final snapshot = await _firestore
          .collection('nivelesingles')
          .doc(levelId)
          .collection('subNiveles') // Nombre de la subcolección en Firestore
          .get();

      print('[EnglishLevelService] Subniveles obtenidos para $levelId: ${snapshot.docs.length}.');
      if (snapshot.docs.isEmpty) {
        print('[EnglishLevelService] No se encontraron subniveles para el nivel ID: $levelId.');
      } else {
        for (var doc in snapshot.docs) {
          print('  [EnglishLevelService] Subnivel ID: ${doc.id}, Datos: ${doc.data()}');
        }
      }

      return snapshot.docs.map((doc) => SubLevel.fromFirestore(doc)).toList();
    } catch (e) {
      print('[EnglishLevelService] Error en getSubLevelsForEnglishLevel: $e');
      return [];
    }
  }
  }