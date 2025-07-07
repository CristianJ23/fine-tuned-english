// widgets/new_task_card.dart
import 'package:flutter/material.dart';

class NewTaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String status;
  final Color backgroundColor;

  const NewTaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            height: 120,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF213354),
                  ),
                ),
                const SizedBox(height: 4),
                Text("Creada: $date", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      status,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.chat_bubble_outline, color: Color(0xFFE62054), size: 18),
                        SizedBox(width: 6),
                        Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
