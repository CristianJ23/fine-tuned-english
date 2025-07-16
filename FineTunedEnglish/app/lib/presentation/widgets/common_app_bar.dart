import 'package:flutter/material.dart';
import '../pages/announcements_page.dart'; // Asegúrate de que esta ruta sea correcta

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CommonAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF213354),
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_off_outlined),
          onPressed: () {
            // Navegar a AnnouncementsPage cuando se presiona el icono
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnnouncementsPage()),
            );
          },
        ),
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}