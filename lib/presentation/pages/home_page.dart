import 'package:flutter/material.dart';
import '../widgets/header_menu.dart';
import '../widgets/filter_buttons.dart';
import '../widgets/task_card.dart';
import '../widgets/new_task_card.dart';
import '../widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderMenu(),
            const FilterButtons(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Tareas Pendientes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF213354),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TaskCard(
                    title: 'perfect tense',
                    description: 'choose the correct word in the perfect tense',
                    date: 'Domingo 28 Dic.',
                    status: 'Pendiente',
                    color: Color(0xFFA8C686),
                  ),
                  const SizedBox(height: 16),
                  const TaskCard(
                    title: 'verb to be',
                    description: 'research about verb to be and to use it',
                    date: 'Domingo 29 Dic.',
                    status: 'Pendiente',
                    color: Color(0xFF2D2F35),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tareas Nuevas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF213354),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        NewTaskCard(
                          title: 'new grammar',
                          description: 'learn reported speech',
                          date: '03 Jul 2025',
                          status: 'Nueva',
                          backgroundColor: Colors.purple,
                        ),
                        SizedBox(width: 12),
                        NewTaskCard(
                          title: 'reading',
                          description: 'Read the article “Time Travel”',
                          date: '04 Jul 2025',
                          status: 'Nueva',
                          backgroundColor: Colors.teal,
                        ),
                      ],
                    ),
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
