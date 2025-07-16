import 'package:flutter/material.dart';

class HomeworkCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final Widget? bottomLeftWidget; // <-- CAMBIO: Widget para la esquina inferior izquierda
  final Widget? bottomRightWidget; // <-- CAMBIO: Widget para la esquina inferior derecha

  const HomeworkCard({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    this.bottomLeftWidget, // Opcional
    this.bottomRightWidget, // Opcional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bloque de color con el título (no cambia)
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Descripción de la tarea (no cambia)
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // ===== NUEVA FILA INFERIOR FLEXIBLE =====
          // Usamos Spacer para asegurar que el contenido se vaya a cada extremo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Si nos dan un widget para la izquierda, lo mostramos
              if (bottomLeftWidget != null) bottomLeftWidget!,
              // Si nos dan un widget para la derecha, lo mostramos
              if (bottomRightWidget != null) bottomRightWidget!,
            ],
          ),
        ],
      ),
    );
  }
}