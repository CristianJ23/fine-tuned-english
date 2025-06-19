import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF334155), // Color oscuro como en la imagen
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Lorem Ipsum!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey[400], size: 16),
                    const SizedBox(width: 4),
                    Icon(Icons.bar_chart_outlined, color: Colors.grey[400], size: 16),
                     const SizedBox(width: 4),
                    Icon(Icons.task_alt_outlined, color: Colors.grey[400], size: 16),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Aquí deberías poner el ícono del curso
          // Como placeholder, usamos un contenedor con un ícono.
          Container(
             width: 60,
             height: 60,
             decoration: BoxDecoration(
               color: Colors.blue.withOpacity(0.2),
               borderRadius: BorderRadius.circular(12)
             ),
            child: const Icon(Icons.language, color: Colors.white, size: 30),
          )
        ],
      ),
    );
  }
}
