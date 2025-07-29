import 'package:cloud_firestore/cloud_firestore.dart';
// Asegúrate que la ruta al modelo Reminder sea correcta
import '../models/reminder.dart';

class ReminderService {
  final CollectionReference _remindersCollection = 
      FirebaseFirestore.instance.collection('recordatorios');
      
  /// Crea un nuevo documento de recordatorio en Firestore.
  Future<String?> createReminder({
    required String titulo,
    String? descripcion,
    required DateTime fecha,
    required String estudianteId,
  }) async {
    try {
      final newReminder = Reminder(
        id: '', // Firestore generará el ID automáticamente al usar .add()
        titulo: titulo,
        descripcion: descripcion,
        fecha: fecha,
        estudianteId: estudianteId,
      );
      
      // Usamos .add() para que Firestore cree un nuevo documento con un ID único
      await _remindersCollection.add(newReminder.toFirestore());
      return null; // Éxito
    } catch(e) {
      print('Error al crear recordatorio: $e');
      return 'No se pudo guardar el recordatorio. Intenta de nuevo.';
    }
  }

  /// Actualiza un recordatorio existente en Firestore.
  Future<String?> updateReminder({
    required String reminderId,
    required String newTitle,
    String? newDescription,
  }) async {
    try {
      await _remindersCollection.doc(reminderId).update({
        'titulo': newTitle,
        'descripcion': newDescription, // Si es null, lo guardará como null
      });
      return null; // Éxito
    } catch (e) {
      print("Error al actualizar recordatorio: $e");
      return "No se pudo actualizar el recordatorio.";
    }
  }

  /// Elimina un recordatorio de Firestore.
  Future<String?> deleteReminder(String reminderId) async {
    try {
      await _remindersCollection.doc(reminderId).delete();
      return null; // Éxito
    } catch (e) {
      print("Error al eliminar recordatorio: $e");
      return "No se pudo eliminar el recordatorio.";
    }
  }

  /// (Opcional) Obtiene una lista de todos los recordatorios para un estudiante.
  Future<List<Reminder>> getRemindersForStudent(String studentId) async {
    try {
      final querySnapshot = await _remindersCollection
        .where('estudianteId', isEqualTo: studentId)
        .orderBy('fecha', descending: true) // Los más recientes primero
        .get();

      return querySnapshot.docs.map((doc) => Reminder.fromFirestore(doc)).toList();
    } catch(e) {
      print('Error al obtener recordatorios: $e');
      return []; // Devuelve una lista vacía en caso de error
    }
  }
}