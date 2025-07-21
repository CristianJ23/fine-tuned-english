import 'package:cloud_firestore/cloud_firestore.dart';
// Importa el enum desde tu widget (si está ahí)
import 'package:app/presentation/widgets/task_list_item.dart';

class TaskSubmission {
  final String id;
  final String tareaId;
  final String estudianteId;
  final String inscripcionId;
  final TaskStatus estado;
  final DateTime? fechaEntrega;
  final double? puntajeObtenido;
  final String? archivoUrl;
  final String? comentariosProfesor;

  TaskSubmission({
    required this.id,
    required this.tareaId,
    required this.estudianteId,
    required this.inscripcionId,
    required this.estado,
    this.fechaEntrega,
    this.puntajeObtenido,
    this.archivoUrl,
    this.comentariosProfesor,
  });

  factory TaskSubmission.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    TaskStatus statusFromString(String? statusStr) {
      switch (statusStr) {
        case 'no-entregado': return TaskStatus.notDelivered;
        case 'pendiente': return TaskStatus.pending;
        case 'entregada': return TaskStatus.done;
        case 'calificado': return TaskStatus.graded;
        default: return TaskStatus.notDelivered;
      }
    }

    return TaskSubmission(
      id: doc.id,
      tareaId: data['tareaId'] ?? '',
      estudianteId: data['estudianteId'] ?? '',
      inscripcionId: data['inscripcionId'] ?? '',
      estado: statusFromString(data['estado']),
      fechaEntrega: (data['fechaEntrega'] as Timestamp?)?.toDate(),
      puntajeObtenido: (data['puntajeObtenido'] as num?)?.toDouble(),
      archivoUrl: data['archivoUrl'],
      comentariosProfesor: data['comentariosProfesor'],
    );
  }
}