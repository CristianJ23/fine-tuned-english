import 'english_level.dart'; // Importamos EnglishLevel
import 'inscription.dart';
import 'sub_level.dart';

class EnrolledCourse {
  final Inscription inscription;
  final EnglishLevel level; // <-- CAMBIO: Ahora guardamos el nivel completo
  final SubLevel subLevel;

  EnrolledCourse({
    required this.inscription,
    required this.level, // <-- CAMBIO: Y lo requerimos en el constructor
    required this.subLevel,
  });
}