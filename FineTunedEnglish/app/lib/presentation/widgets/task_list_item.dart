import 'package:flutter/material.dart';
import '../models/task.dart' as task_model;
import '../models/task_submission.dart';
import '../services/task_service.dart';
import '../pages/task_detail_page.dart';

enum TaskStatus { notDelivered, pending, done, graded }

class TaskListItem extends StatelessWidget {
  final TaskWithSubmission taskWithSubmission;
  final VoidCallback onTaskUpdated;

  const TaskListItem({
    super.key,
    required this.taskWithSubmission,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final task_model.Task task = taskWithSubmission.task;
    final TaskSubmission submission = taskWithSubmission.submission;

    return InkWell(
      onTap: () async {
        final bool? shouldRefresh = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(taskWithSubmission: taskWithSubmission),
          ),
        );
        if (shouldRefresh == true) {
          onTaskUpdated();
        }
      },
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(task.descripcion, style: const TextStyle(color: Colors.black54, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                    if (submission.puntajeObtenido != null) ...[
                      const SizedBox(height: 4),
                      Text(
                          '${submission.puntajeObtenido?.toStringAsFixed(1)} / ${task.puntajeDisponible.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildStatusWidget(submission),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusWidget(TaskSubmission submission) {
    String statusText = '';

    switch (submission.estado) {
      case TaskStatus.notDelivered:
        statusText = 'No Entregado';
        return _statusColumn(Icons.error_outline, statusText, Colors.red);
      
      case TaskStatus.pending:
        statusText = 'Pendiente';
        return _statusColumn(Icons.watch_later_outlined, statusText, Colors.grey);
        
      case TaskStatus.done:
        return const Icon(Icons.check_circle_outline, color: Colors.green, size: 28);
        
      case TaskStatus.graded:
        return Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.blue, size: 28),
            const SizedBox(height: 4),
            Row(children: [
              Icon(Icons.chat_bubble_outline_rounded, color: Colors.amber.shade700, size: 16),
              const SizedBox(width: 4),
              const Text('Revisar', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
            ]),
          ],
        );
    }
  }

  Widget _statusColumn(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Row(
          children: [
            Icon(Icons.remove_red_eye_outlined, color: Colors.pink, size: 16),
            SizedBox(width: 4),
            Text('Presentar', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        )
      ],
    );
  }
}