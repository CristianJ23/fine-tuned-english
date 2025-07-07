import 'package:flutter/material.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF213354),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: _chipStyle('Tipo de Programa'),
              items: ['A', 'B', 'C'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Todas las Tareas'),
          )
        ],
      ),
    );
  }

  InputDecoration _chipStyle(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
  );
}
