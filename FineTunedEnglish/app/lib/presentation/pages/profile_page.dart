import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const Text(
              "Datos Personales",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF213354),
              ),
            ),
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/perfil.jpg'),
            ),
            const SizedBox(height: 24),
            _buildInfoRow(Icons.person, "Alejandro XXXXXX"),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email, "xxxxxx@xxxx.com"),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.fingerprint, "1025639879"),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.calendar_today, "24/02/2004"),
            const SizedBox(height: 32),
            _buildAcademicButton(),
            const SizedBox(height: 16),
            _buildModifyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(value),
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF213354),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {},
      icon: const Icon(Icons.school, color: Colors.white),
      label: const Text("Historial Académico", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildModifyButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {},
      icon: const Icon(Icons.edit, color: Colors.white),
      label: const Text("Modificar", style: TextStyle(color: Colors.white)),
    );
  }
}
