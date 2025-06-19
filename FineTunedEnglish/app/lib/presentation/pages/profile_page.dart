import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- CAMBIO AQUÍ ---
    // Se eliminó el 'const' de Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xFFF4F5F7),
      ),
      body: const Center(
        child: Text(
          'Aquí se mostrará el perfil del estudiante.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}