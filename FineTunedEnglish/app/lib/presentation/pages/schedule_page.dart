import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- CAMBIO AQUÍ ---
    // Se eliminó el 'const' de Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Horario'),
        backgroundColor: const Color(0xFFF4F5F7),
      ),
      body: const Center(
        child: Text(
          'Aquí se mostrará el horario del estudiante.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
