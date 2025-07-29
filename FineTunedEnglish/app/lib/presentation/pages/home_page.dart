import 'package:flutter/material.dart';
import '../models/enrolled_course.dart';
import '../models/english_level.dart';
import '../services/auth_service.dart';
import '../services/inscription_service.dart';
import '../services/task_service.dart';
import '../services/level_service.dart';
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
  final LevelService _levelService = LevelService();

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
    if (!mounted) return;
    setState(() => _isLoading = true);

    final studentId = AuthService.currentUser?.id;
    if (studentId == null) {
      if (mounted) setState(() { _errorMessage = "Error: Usuario no autenticado."; _isLoading = false; });
      return;
    }
    
    try {
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
            _filteredCourses = _allEnrolledCourses
                .where((course) => course.level.id == _selectedLevel!.id)
                .toList();
            _selectedCourse = latestCourse;
            _onCourseSelected(_selectedCourse);
          }
          _isLoading = false;
        });
      }
    } catch(e) {
      if(mounted) {
        setState(() { 
        _errorMessage = "Error al cargar datos: $e"; 
        _isLoading = false; 
      });
      }
    }
  }
  
  void _filterCoursesByLevel(EnglishLevel? level) {
    if (level == null || !mounted) return;
    
    setState(() {
      _selectedLevel = level;
      _filteredCourses = _allEnrolledCourses
          .where((course) => course.level.id == level.id)
          .toList();
      
      if (_filteredCourses.isNotEmpty) {
        _onCourseSelected(_filteredCourses.first);
      } else {
        _selectedCourse = null;
        _currentTasks = [];
      }
    });
  }

  Future<void> _onCourseSelected(EnrolledCourse? course) async {
    if (course == null || !mounted) return;
    
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
    if (_allEnrolledCourses.isEmpty) {
      return const Center(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No estás inscrito en ningún curso activo.", textAlign: TextAlign.center),
        ),
    );
    }

    final newTasks = _currentTasks.where((taskWithSub) =>
        taskWithSub.submission.estado == TaskStatus.pending ||
        taskWithSub.submission.estado == TaskStatus.notDelivered).toList();

    final recentTasks = _currentTasks.where((taskWithSub) =>
        taskWithSub.submission.estado == TaskStatus.done ||
        taskWithSub.submission.estado == TaskStatus.graded).toList();
        
    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                child: _buildDropdownContainer(
                  DropdownButton<EnglishLevel>(
                    value: _selectedLevel,
                    isExpanded: true,
                    hint: const Text("Nivel", style: TextStyle(color: Colors.white70)),
                    dropdownColor: const Color(0xFF334155),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    items: _enrolledLevels.map((level) => DropdownMenuItem<EnglishLevel>(value: level, child: Text(level.name))).toList(),
                    onChanged: (level) => _filterCoursesByLevel(level),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final shouldRefresh = await Navigator.push<bool>(context, 
                      MaterialPageRoute(builder: (context) => const AllTasksPage())
                    );
                    if (shouldRefresh == true) {
                      _loadInitialData();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Todas las Tareas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDropdownContainer(
            DropdownButton<EnrolledCourse>(
              value: _selectedCourse,
              isExpanded: true,
              hint: const Text("Programa", style: TextStyle(color: Colors.white70)),
              dropdownColor: const Color(0xFF334155),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: _filteredCourses.map((course) => DropdownMenuItem<EnrolledCourse>(value: course, child: Text(course.subLevel.name))).toList(),
              onChanged: (newValue) => _onCourseSelected(newValue),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDropdownContainer(Widget dropdown) {
     return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF213354), borderRadius: BorderRadius.circular(20)),
      child: DropdownButtonHideUnderline(child: dropdown),
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
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final taskWithSub = tasks[index];
          return Container(
            width: 320,
            margin: const EdgeInsets.only(right: 12.0),
            child: TaskListItem(
              taskWithSubmission: taskWithSub,
              onTaskUpdated: _loadInitialData,
            ),
          );
        },
      ),
    );
  }
}