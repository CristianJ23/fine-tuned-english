import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String date;
  final String imageUrl;
  final Color color;
  final bool isLiked;

  const NewsCard({
    super.key,
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.color,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Ancho definido para las tarjetas
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Imagen de fondo (si existe)
          if (imageUrl.isNotEmpty)
          Positioned(
            right: -20,
            top: 20,
            child: Opacity(
              opacity: 0.8,
              // Usamos un try-catch por si el archivo de imagen no existe
              child: Image.asset(imageUrl, width: 120, errorBuilder: (c, e, s) => const SizedBox()),
            ),
          ),
          // Contenido de texto
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lorem Ipsum',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),
          // Icono de Corazón
          Positioned(
            bottom: 16,
            right: 16,
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
