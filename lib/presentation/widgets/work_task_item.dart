import 'package:flutter/material.dart';
import '../pages/work_detail_page.dart';

class WorkTaskItem extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final String? score;
  final bool isCompleted;

  const WorkTaskItem({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    this.score,
    this.isCompleted = false,
  });

  bool get isPerfectScore => score?.trim() == "10/10";

  double get scoreProgress {
    if (score != null && score!.contains("/")) {
      final parts = score!.split("/");
      final obtained = double.tryParse(parts[0].trim());
      final total = double.tryParse(parts[1].trim());
      if (obtained != null && total != null && total > 0) {
        return (obtained / total).clamp(0.0, 1.0);
      }
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkDetailPage(
              title: title,
              description: description,
              score: score,
              status: status,
              isCompleted: isCompleted,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título + icono/círculo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF213354),
                    ),
                  ),
                ),
                if (isPerfectScore)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE62054),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '10',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  Icon(
                    isCompleted ? Icons.check : Icons.timer_outlined,
                    color: const Color(0xFF213354),
                  ),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),

            const SizedBox(height: 10),
            Text(
              score ?? status,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),

            // Barra de progreso
            if (score != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: scoreProgress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFEFEFEF),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      scoreProgress >= 1
                          ? const Color(0xFFE62054)
                          : const Color(0xFF213354),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline,
                    color: Color(0xFFFFC107), size: 18),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('¿Presentar tarea?'),
                        content: const Text('¿Quieres presentar esta tarea?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Acción de entrega aquí
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE62054),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Sí, presentar'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFE62054),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Presentar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
