import 'package:flutter/material.dart';
<<<<<<< HEAD
// Asegúrate de que estas rutas sean correctas para tu proyecto.
import 'package:app/presentation/widgets/homework_card.dart';
import 'package:app/presentation/widgets/task_list_item.dart'; // Importamos el enum TaskStatus
import 'all_tasks_page.dart';
=======
import '../widgets/header_menu.dart';
import '../widgets/filter_buttons.dart';
import '../widgets/task_card.dart';
import '../widgets/new_task_card.dart';
import '../widgets/custom_drawer.dart';
>>>>>>> 10ffd6c (Subiendo los últimos cambios al repositorio)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

<<<<<<< HEAD
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedProgramType;
  String? _selectedProgram;

  // FUENTE DE DATOS CENTRALIZADA
  final List<Map<String, dynamic>> allTasksData = [
    {
      'title': 'Reading',
      'description': 'Read chapter 5 and summarize.',
      'color': Colors.green.shade700,
      'status': TaskStatus.done // Estado "done"
    },
    {
      'title': 'Final Project',
      'description': 'Entregar el proyecto final del curso.',
      'color': Colors.red.shade400,
      'status': TaskStatus.graded, 'score': '0/10' // Estado "graded"
    },
    {
      'title': 'Present Tense',
      'description': 'Choose the correct word in the present tense.',
      'color': Colors.green.shade400,
      'status': TaskStatus.pending, 'hasComment': true // Estado "pending"
    },
    {
      'title': 'Verb To Be',
      'description': 'Research about verb to be and to use it.',
      'color': Colors.purple.shade400,
      'status': TaskStatus.notDelivered, 'isStarred': true // Estado "notDelivered"
    },
    
  ];

  @override
  Widget build(BuildContext context) {
    // FILTRADO DE DATOS
    final newTasks = allTasksData.where((task) =>
        task['status'] == TaskStatus.pending ||
        task['status'] == TaskStatus.done).toList();

    final recentTasks = allTasksData.where((task) =>
        task['status'] == TaskStatus.notDelivered ||
        task['status'] == TaskStatus.graded).toList();
        
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Tareas Nuevas'),
                const SizedBox(height: 16),
                _buildTasksList(newTasks),
                const SizedBox(height: 24),
                _buildSectionHeader('Tareas Recientes'),
                const SizedBox(height: 16),
                _buildTasksList(recentTasks),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
=======
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
>>>>>>> 10ffd6c (Subiendo los últimos cambios al repositorio)
      ),

    );
  }
<<<<<<< HEAD

  // Widget para la sección de filtros de la parte superior
  Widget _buildFilters() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDropdownButton('Tipo de Programa', _selectedProgramType, ['Kids', 'Teens']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllTasksPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Todas las Tareas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDropdownButton('Programa', _selectedProgram, ['Youth Program A.1.1', 'Adult Program B.2']),
        ],
      ),
    );
  }

  // Helper para crear los dropdowns con el estilo deseado
  Widget _buildDropdownButton(String hint, String? value, List<String> items) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF213354),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.white.withOpacity(0.8))),
          dropdownColor: const Color(0xFF334155),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (newValue) {},
        ),
      ),
    );
  }

  // Helper para los títulos de sección
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.pink,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Construye las listas horizontales de tareas
  Widget _buildTasksList(List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text("No hay tareas en esta sección.")),
      );
    }
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return HomeworkCard(
            title: task['title'],
            description: task['description'],
            color: task['color'],
            bottomLeftWidget: _buildCardBottomLeft(task['status'], task['score']),
            bottomRightWidget: _buildCardBottomRight(task['hasComment'] ?? false, task['isStarred'] ?? false),
          );
        },
      ),
    );
  }

  // ===== CAMBIO REALIZADO AQUÍ =====
  // Helper para construir el widget de la esquina inferior izquierda de la tarjeta
  Widget _buildCardBottomLeft(TaskStatus status, String? score) {
    String text;
    Color textColor = Colors.black54;

    switch (status) {
      case TaskStatus.notDelivered:
        text = 'No Entregado';
        textColor = Colors.red;
        text += ' - 0/10';
        break;
      case TaskStatus.pending:
        text = 'Pendiente';
        break;
      case TaskStatus.graded:
        text = 'Entregada';
        textColor = Colors.green;
        text += ' - $score';
        break;
      case TaskStatus.done:
        text = 'Entregada';
        textColor = Colors.green;
        text += ' - No Calificada';
        break;
    }
    return Text(
      text,
      style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600),
    );
  }
  // ===== FIN DEL CAMBIO =====

  // Helper para construir el widget de la esquina inferior derecha de la tarjeta
  Widget _buildCardBottomRight(bool hasComment, bool isStarred) {
    if (!hasComment && !isStarred) {
      return const SizedBox.shrink(); // No muestra nada si no hay iconos que mostrar
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasComment)
          const Icon(Icons.chat_bubble_outline_rounded, color: Colors.amber, size: 18),
        if (hasComment && isStarred)
          const SizedBox(width: 4),
        if (isStarred)
          const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
      ],
    );
  }
}
=======
}
>>>>>>> 10ffd6c (Subiendo los últimos cambios al repositorio)
