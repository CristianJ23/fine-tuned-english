import 'package:flutter/material.dart';
// Asegúrate de que esta ruta sea correcta para tu proyecto.
// Reemplaza 'app' por el nombre de tu paquete en pubspec.yaml si es diferente.
import 'package:app/presentation/pages/task_detail_page.dart';

// 1. Enum actualizado con el nuevo estado
enum TaskStatus { notDelivered, pending, done, graded }

class TaskListItem extends StatelessWidget {
  final String title;
  final String description;
  final String? score;
  final String statusText;
  final TaskStatus status;

  const TaskListItem({
    super.key,
    required this.title,
    required this.description,
    this.score,
    this.statusText = '',
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(
              taskTitle: title,
              initialStatus: status,
            ),
          ),
        );
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
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(description, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                    if (score != null) ...[
                      const SizedBox(height: 4),
                      Text(score!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildStatusWidget(),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Widget de estado actualizado
  Widget _buildStatusWidget() {
    switch (status) {
      // ===== NUEVO CASO PARA 'NO ENTREGADO' =====
      case TaskStatus.notDelivered:
        return Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red), // Ícono de error en rojo
            const SizedBox(height: 4),
            Text(
              statusText,
              style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold), // Texto en rojo y negrita
            ),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.chat_bubble_outline_rounded, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text('Presentar', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        );

      // CASO PARA 'PENDIENTE'
      case TaskStatus.pending:
        return Column(
          children: [
            const Icon(Icons.watch_later_outlined, color: Colors.grey),
            const SizedBox(height: 4),
            Text(statusText, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.chat_bubble_outline_rounded, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text('Presentar', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        );
      
      // CASO PARA 'DONE' (Entregado sin calificar)
      case TaskStatus.done:
        return const Icon(Icons.check_circle_outline, color: Colors.green, size: 28);
      
      // CASO PARA 'GRADED' (Entregado y calificado)
      case TaskStatus.graded:
         return Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.blue, size: 28),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.chat_bubble_outline_rounded, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text('Presentar', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        );
    }
  }
}