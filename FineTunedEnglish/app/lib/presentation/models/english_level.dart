import 'package:cloud_firestore/cloud_firestore.dart';

// Esta clase representa un nivel de inglés, como "Principiante", "Intermedio", etc.
class EnglishLevel {
  // 'id' es el identificador único del nivel (generalmente el ID del documento en Firestore).
  final String id;
  // 'name' es el nombre del nivel, por ejemplo, "A1", "B2".
  final String name;
  // 'description' proporciona detalles sobre lo que abarca el nivel.
  final String description;
  // 'minAge' es la edad mínima recomendada para este nivel.
  final int minAge;
  // 'maxAge' es la edad máxima recomendada para este nivel.
  final int maxAge;
  // 'tipo' es un campo nuevo para clasificar el tipo de nivel (ej. "General", "Negocios").
  final String tipo;

  // Constructor para crear una instancia de EnglishLevel.
  EnglishLevel({
    required this.id,
    required this.name,
    required this.description,
    required this.minAge,
    required this.maxAge,
    required this.tipo, // <-- Campo 'tipo' requerido en el constructor
  });

  // ---
  // Sobrescribimos el operador de igualdad (==) y hashCode
  // para que Dart sepa cómo comparar dos objetos EnglishLevel.
  // Esto es crucial para que `DropdownButton` y otras colecciones
  // como `Set` puedan identificar niveles duplicados correctamente.
  // Consideramos que dos EnglishLevel son iguales si tienen el mismo 'id'.
  // ---
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Si son la misma instancia, son iguales.
    return other is EnglishLevel &&
        id == other.id; // Son iguales si sus 'id' son los mismos.
  }

  @override
  int get hashCode => id.hashCode; // El hashCode debe ser consistente con '=='.

  // ---

  // 'factory' constructor para crear una instancia de EnglishLevel
  // a partir de un DocumentSnapshot de Firestore.
  factory EnglishLevel.fromFirestore(DocumentSnapshot doc) {
    // Obtenemos los datos del documento como un Map.
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EnglishLevel(
      id: doc.id, // El ID del documento de Firestore.
      name: data['nombre'] ?? 'Sin Nombre', // Obtiene 'nombre' o un valor predeterminado.
      description: data['descripcion'] ?? 'Sin Descripción', // Obtiene 'descripcion' o un valor predeterminado.
      minAge: data['edadMinima'] ?? 0, // Obtiene 'edadMinima' o 0.
      maxAge: data['edadMaxima'] ?? 99, // Obtiene 'edadMaxima' o 99.
      tipo: data['tipo'] ?? 'General', // <-- Obtiene 'tipo' o 'General'.
    );
  }
}