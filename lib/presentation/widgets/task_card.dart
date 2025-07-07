import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String status;
  final Color color;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Creada: $date",
                  style: const TextStyle(color: Colors.white70)),
              Text(status,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }
}
