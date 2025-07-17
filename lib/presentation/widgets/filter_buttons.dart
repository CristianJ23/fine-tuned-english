import 'package:flutter/material.dart';
import '../pages/works_page.dart';

class FilterButtons extends StatefulWidget {
  const FilterButtons({super.key});

  @override
  State<FilterButtons> createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  String selectedProgram = 'Tipo de Programa';

  void _showProgramTypes(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Selecciona un tipo de programa",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...[
              "Tiny Kids",
              "Children"
              "Youth",
              "Teens",
              "Seniors",
            ].map(
                  (program) => ListTile(
                title: Text(program),
                onTap: () {
                  setState(() {
                    selectedProgram = program;
                  });
                  Navigator.pop(context); // cerrar el modal
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showProgramTypes(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF213354),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      selectedProgram,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorksPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE62054),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Todas las Tareas"),
            ),
          ),
        ],
      ),
    );
  }
}
