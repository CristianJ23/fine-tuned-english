import 'package:flutter/material.dart';
import '../widgets/header_menu.dart';
import '../widgets/work_task_item.dart';

class WorksPage extends StatelessWidget {
  const WorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: Drawer(), // <-- Asegura que exista un drawer por si se usa el menú
      body: SafeArea(
        child: Column(
          children: [
            const HeaderMenu(showBackButton: true), // <-- Muestra el botón atrás
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  WorkTaskItem(
                    title: 'Lorem Lopus BEQES',
                    description: 'Lorem Lopus bebess sadbas asdas asdddsahb',
                    status: 'Pendiente',
                    isCompleted: false,
                  ),
                  WorkTaskItem(
                    title: 'Lorem Lopus BEQES',
                    description: 'Lorem Lopus bebess sadbas asdas asdddsahb',
                    status: '0/10',
                    isCompleted: true,
                  ),
                  WorkTaskItem(
                    title: 'Lorem Lopus BEQES',
                    description: 'Lorem Lopus bebess sadbas asdas asdddsahb',
                    status: '10/10',
                    isCompleted: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
