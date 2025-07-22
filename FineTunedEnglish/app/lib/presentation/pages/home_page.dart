import 'package:flutter/material.dart';
import '../models/enrolled_course.dart';
import '../models/english_level.dart';
import '../services/auth_service.dart';
import '../services/inscription_service.dart';
import '../services/task_service.dart';
import '../widgets/homework_card.dart';
import '../widgets/task_list_item.dart';
import 'all_tasks_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InscriptionService _inscriptionService = InscriptionService();
  final TaskService _taskService = TaskService();

  bool _isLoading = true;
  String? _errorMessage;

  List<EnrolledCourse> _allEnrolledCourses = [];
  List<EnglishLevel> _enrolledLevels = [];
  EnglishLevel? _selectedLevel;
  
  List<EnrolledCourse> _filteredCourses = [];
  EnrolledCourse? _selectedCourse;

  List<TaskWithSubmission> _currentTasks = [];
  bool _isLoadingTasks = false;
  
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final studentId = AuthService.currentUser?.id;
    if (studentId == null) {
      if (mounted) setState(() => _errorMessage = "Error: Usuario no autenticado.");
      return;
    }
    
    final courses = await _inscriptionService.getEnrolledCoursesForStudent(studentId);
    
    if (mounted) {
      final uniqueLevels = <String, EnglishLevel>{};
      for (var course in courses) {
        uniqueLevels[course.level.id] = course.level;
      }

      setState(() {
        _allEnrolledCourses = courses;
        _enrolledLevels = uniqueLevels.values.toList();

        if (courses.isNotEmpty) {
          final latestCourse = courses.first;
          _selectedLevel = latestCourse.level;
          _filterCoursesByLevel(_selectedLevel);
          _onCourseSelected(latestCourse);
        }
        _isLoading = false;
      });
    }
  }
  
  void _filterCoursesByLevel(EnglishLevel? level) {
    if (level == null) return;

    setState(() {
      _selectedLevel = level;
      _filteredCourses = _allEnrolledCourses
          .where((course) => course.inscription.nivelInglesId == level.id)
          .toList();
      
      if (_filteredCourses.isNotEmpty && !_filteredCourses.contains(_selectedCourse)) {
        _onCourseSelected(_filteredCourses.first);
      } else if (_filteredCourses.isEmpty) {
        _selectedCourse = null;
        _currentTasks = [];
      }
    });
  }

  Future<void> _onCourseSelected(EnrolledCourse? course) async {
    if (course == null) return;
    setState(() {
      _selectedCourse = course;
      _isLoadingTasks = true;
      _currentTasks = [];
    });
    
    final tasks = await _taskService.getTasksForInscription(
      course.inscription.id,
      AuthService.currentUser!.id
    );
    if(mounted) {
      setState(() {
        _currentTasks = tasks;
        _isLoadingTasks = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) return Center(child: Text(_errorMessage!));
    if (_allEnrolledCourses.isEmpty) return const Center(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No estás inscrito en ningún curso activo.", textAlign: TextAlign.center),
        ),
    );

    final newTasks = _currentTasks.where((taskWithSub) =>
        taskWithSub.submission.estado == TaskStatus.pending ||
        taskWithSub.submission.estado == TaskStatus.notDelivered).toList();

    final recentTasks = _currentTasks.where((taskWithSub) =>
        taskWithSub.submission.estado == TaskStatus.done ||
        taskWithSub.submission.estado == TaskStatus.graded).toList();
        
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _isLoadingTasks 
              ? const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 40.0), child: CircularProgressIndicator()))
              : Column(
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
      ),
    );
  }


  Widget _buildFilters() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildLevelDropdown(
                  'Nivel', 
                  _selectedLevel, 
                  _enrolledLevels, 
                  (level) => _filterCoursesByLevel(level),
                )
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AllTasksPage())),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Todas las Tareas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: const Color(0xFF213354), borderRadius: BorderRadius.circular(20)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<EnrolledCourse>(
                value: _selectedCourse,
                isExpanded: true,
                dropdownColor: const Color(0xFF334155),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                hint: const Text('Selecciona un programa', style: TextStyle(color: Colors.white70)),
                items: _filteredCourses.map((enrolledCourse) => DropdownMenuItem<EnrolledCourse>(
                    value: enrolledCourse, 
                    child: Text(enrolledCourse.subLevel.name)
                )).toList(),
                onChanged: (newValue) => _onCourseSelected(newValue),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLevelDropdown(String hint, EnglishLevel? value, List<EnglishLevel> items, Function(EnglishLevel?) onChanged) {
     return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF213354), borderRadius: BorderRadius.circular(20)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<EnglishLevel>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.white.withOpacity(0.8))),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          dropdownColor: const Color(0xFF334155),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: items.map((level) => DropdownMenuItem<EnglishLevel>(value: level, child: Text(level.name))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(title, style: const TextStyle(color: Colors.pink, fontSize: 22, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTasksList(List<TaskWithSubmission> tasks) {
    if (tasks.isEmpty) {
      return const SizedBox(height: 100, child: Center(child: Text("No hay tareas en esta sección.")));
    }
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final taskWithSub = tasks[index];
          Color cardColor;
          switch (taskWithSub.submission.estado) {
            case TaskStatus.notDelivered: cardColor = Colors.red.shade400; break;
            case TaskStatus.pending: cardColor = Colors.orange.shade400; break;
            case TaskStatus.graded: cardColor = const Color(0xFF334155); break;
            case TaskStatus.done: cardColor = Colors.green.shade700; break;
          }
          return HomeworkCard(
            title: taskWithSub.task.titulo,
            description: taskWithSub.task.descripcion,
            color: cardColor,
            bottomLeftWidget: _buildCardBottomLeft(taskWithSub.submission.estado, taskWithSub.submission.puntajeObtenido?.toStringAsFixed(1)),
            bottomRightWidget: _buildCardBottomRight(false, false),
          );
        },
      ),
    );
  }

  Widget _buildCardBottomLeft(TaskStatus status, String? score) {
    String text;
    Color textColor = Colors.black54;
    switch (status) {
      case TaskStatus.notDelivered: text = 'No Entregado'; textColor = Colors.red; break;
      case TaskStatus.pending: text = 'Pendiente'; break;
      case TaskStatus.graded: text = 'Calificada: ${score ?? 'N/A'}'; textColor = Colors.blue.shade800; break;
      case TaskStatus.done: text = 'Entregada'; textColor = Colors.green.shade800; break;
    }
    return Text(text, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600));
  }

  Widget _buildCardBottomRight(bool hasComment, bool isStarred) {
    if (!hasComment && !isStarred) return const SizedBox.shrink();
    return Row(mainAxisSize: MainAxisSize.min, children: [
      if (hasComment) const Icon(Icons.chat_bubble_outline_rounded, color: Colors.amber, size: 18),
      if (hasComment && isStarred) const SizedBox(width: 4),
      if (isStarred) const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
    ]);
  }
}