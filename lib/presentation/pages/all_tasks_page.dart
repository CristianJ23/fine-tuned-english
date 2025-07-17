import 'package:flutter/material.dart';
import 'package:app/presentation/widgets/task_list_item.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  String? _selectedProgramType;
  String? _selectedProgram;

  final List<Map<String, dynamic>> tasksData = [
    {
      'title': 'Final Project',
      'description': 'Entregar el proyecto final del curso.',
      'status': TaskStatus.notDelivered, 'statusText': 'No Entregado'
    },
    {
      'title': 'Present Tense Exercise',
      'description': 'Choose the correct word in the present tense.',
      'status': TaskStatus.pending, 'statusText': 'Pendiente'
    },
    {
      'title': 'Verb To Be',
      'description': 'Research about verb to be and to use it.',
      'status': TaskStatus.graded, 'score': '10/10'
    },
    {
      'title': 'Reading Comprehension',
      'description': 'Read chapter 5 and summarize.',
      'status': TaskStatus.done
    },
  ];

  @override
  Widget build(BuildContext context) {
    tasksData.sort((a, b) {
      int score(TaskStatus status) {
        if (status == TaskStatus.pending) return 0;
        if (status == TaskStatus.notDelivered) return 1;
        return 2; 
      }
      return score(a['status']).compareTo(score(b['status']));
    });

    List<Widget> taskWidgets = tasksData.map((taskData) {
      return TaskListItem(
        title: taskData['title'],
        description: taskData['description'],
        status: taskData['status'],
        score: taskData['score'],
        statusText: taskData['statusText'] ?? '',
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Todas Las Tareas', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF213354),
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey[100],
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 130,
            toolbarHeight: 130,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildFilters(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(taskWidgets),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDropdownButton('Tipo de Programa', _selectedProgramType, ['Kids', 'Teens']),
          const SizedBox(height: 10),
          _buildDropdownButton('Programa', _selectedProgram, ['Youth Program A.1.1', 'Adult Program B.2']),
        ],
      ),
    );
  }
  
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
          style: const TextStyle(color: Colors.white, fontSize: 16),
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
}