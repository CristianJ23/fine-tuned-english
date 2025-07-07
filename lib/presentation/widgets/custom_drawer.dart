import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF213354),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/images/profile.jpg'), // Asegúrate de tener esta imagen
          ),
          const SizedBox(height: 10),
          const Text(
            'Hi, Alexander Ramirez',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Text(
            'xxx@xxxxx.com',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 20),
          const _DrawerButton(
            icon: Icons.chat_bubble_outline,
            label: 'Recomendaciones',
          ),
          const _DrawerButton(
            icon: Icons.info_outline,
            label: 'Sobre Nosotros',
          ),
          const _DrawerButton(
            icon: Icons.settings,
            label: 'Configuraciones',
          ),
          const _DrawerButton(
            icon: Icons.settings_applications,
            label: 'Configuraciones',
          ),
          const _DrawerButton(
            icon: Icons.assignment,
            label: 'Matrícula',
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE62054),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DrawerButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2B4670),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(label, style: const TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ),
    );
  }
}
