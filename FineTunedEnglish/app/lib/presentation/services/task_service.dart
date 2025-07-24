import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_submission.dart';
import '../models/task.dart' as task_model;
import '../widgets/task_list_item.dart';

class TaskWithSubmission {
  final task_model.Task task;
  final TaskSubmission submission;

  TaskWithSubmission({required this.task, required this.submission});
}

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TaskWithSubmission>> getTasksForInscription(String inscriptionId, String studentId) async {
    try {
      final inscriptionDoc = await _firestore.collection('inscripciones').doc(inscriptionId).get();
      if (!inscriptionDoc.exists) return [];
      final inscriptionData = inscriptionDoc.data()!;
      final subLevelId = inscriptionData['subNivelId'];
      final levelId = inscriptionData['nivelInglesId'];
      if(subLevelId == null || levelId == null) return [];
      
      final tasksSnapshot = await _firestore.collection('nivelesIngles').doc(levelId).collection('subNiveles').doc(subLevelId).collection('tareas').get();
      final submissionsSnapshot = await _firestore.collection('entregasTarea').where('inscripcionId', isEqualTo: inscriptionId).where('estudianteId', isEqualTo: studentId).get();
      final submissionsMap = { for (var doc in submissionsSnapshot.docs) doc['tareaId'] : TaskSubmission.fromFirestore(doc) };
      
      List<TaskWithSubmission> results = [];
      for (var taskDoc in tasksSnapshot.docs) {
        task_model.Task task = task_model.Task.fromFirestore(taskDoc);
        TaskSubmission? submission = submissionsMap[task.id];
        submission ??= TaskSubmission(id: '', tareaId: task.id, estudianteId: studentId, inscripcionId: inscriptionId, estado: TaskStatus.notDelivered);
        results.add(TaskWithSubmission(task: task, submission: submission));
      }
      return results;
    } catch (e) {
      print("Error fetching tasks for inscription: $e");
      return [];
    }
  }
  
  Future<String?> submitTaskSimulation({ required TaskSubmission submission }) async {
    try {
      final submissionData = {
          'estado': 'entregada',
          'fechaEntrega': Timestamp.now(),
          'tareaId': submission.tareaId,
          'estudianteId': submission.estudianteId,
          'inscripcionId': submission.inscripcionId,
          'archivoUrl': "url_simulada/archivo_entregado.pdf", // Dato quemado
      };

      if (submission.id.isEmpty) {
        await _firestore.collection('entregasTarea').add(submissionData);
      } else {
        await _firestore.collection('entregasTarea').doc(submission.id).update(submissionData);
      }
      return null;
    } catch (e) {
      print("Error al simular la entrega de tarea: $e");
      return "No se pudo entregar la tarea. Inténtalo de nuevo.";
    }
  }
}