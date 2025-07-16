import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  final String type;
  final String description;
  final String date;
  final String time;
  final Color backgroundColor;
  final IconData leadingIcon;
  final Color leadingIconColor;
  final IconData? trailingIcon; // Puede ser nulo
  final Color? trailingIconColor; // Puede ser nulo
  final VoidCallback? onTap;

  const AnnouncementCard({
    super.key,
    required this.type,
    required this.description,
    required this.date,
    required this.time,
    required this.backgroundColor,
    required this.leadingIcon,
    required this.leadingIconColor,
    this.trailingIcon,
    this.trailingIconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: InkWell( // Permite que la tarjeta sea pulsable
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(leadingIcon, color: leadingIconColor, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      type,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  if (trailingIcon != null)
                    Icon(trailingIcon, color: trailingIconColor, size: 24),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$date $time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'ver', // Texto "ver" estático
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Color verde como en el diseño
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}