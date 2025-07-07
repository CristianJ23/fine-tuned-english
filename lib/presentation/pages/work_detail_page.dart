// pages/work_detail_page.dart
import 'package:flutter/material.dart';

class WorkDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final String? score;
  final bool isCompleted;

  const WorkDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    this.score,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF213354)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.toLowerCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE62054),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isCompleted ? 'Delivered' : 'No Delivered',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                        isCompleted ? Colors.green : const Color(0xFFE62054),
                      ),
                    ),
                    Text(
                      score ?? '10pts',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE62054),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // Card de entrega
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Delivery date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE62054),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '18/06/2025',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213354),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFE62054),
                    child: Text(
                      'earring',
                      style: TextStyle(
                        color: Color(0xFF213354),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Attach File\nDe 10 pts',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF213354),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, color: Colors.black38),
                      SizedBox(width: 4),
                      Text(
                        'Add reminder notifications',
                        style: TextStyle(color: Colors.black54),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Comentarios',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF213354),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...',
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Entregar Deber'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE62054),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Cancelar Entrega'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF213354),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
