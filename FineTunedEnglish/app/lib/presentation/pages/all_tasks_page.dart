import 'package:flutter/material.dart';
import '../models/enrolled_course.dart';
import '../models/english_level.dart';
import '../services/auth_service.dart';
import '../services/inscription_service.dart';
import '../services/task_service.dart';
import '../widgets/task_list_item.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
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
  
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() { _isLoading = true; });

    final studentId = AuthService.currentUser?.id;
    if (studentId == null) {
      if (mounted) setState(() { _isLoading = false; _errorMessage = "Usuario no autenticado."; });
      return;
    }
    
    final courses = await _inscriptionService.getEnrolledCoursesForStudent(studentId);
    if (mounted) {
      final uniqueLevels = <String, EnglishLevel>{};
      for (var course in courses) { uniqueLevels[course.level.id] = course.level; }

      setState(() {
        _allEnrolledCourses = courses;
        _enrolledLevels = uniqueLevels.values.toList();
        
        if (courses.isNotEmpty) {
          final latestCourse = courses.first;
          _selectedLevel = latestCourse.level;
          _filterCoursesByLevel(_selectedLevel, setDefaultCourse: latestCourse);
        } else {
          _isLoading = false;
        }
      });
    }
  }
  
  void _filterCoursesByLevel(EnglishLevel? level, {EnrolledCourse? setDefaultCourse}) {
    if (!mounted) return;
    setState(() {
      _selectedLevel = level;
      if (level == null) {
        _filteredCourses = List.from(_allEnrolledCourses);
        _selectedCourse = null;
        _loadAllTasks();
      } else {
        _filteredCourses = _allEnrolledCourses.where((c) => c.level.id == level.id).toList();
        if (_filteredCourses.isNotEmpty) {
          final courseToSelect = setDefaultCourse ?? _filteredCourses.first;
          if (_filteredCourses.contains(courseToSelect)) {
            _onCourseSelected(courseToSelect);
          } else {
            _onCourseSelected(_filteredCourses.first);
          }
        } else {
          _selectedCourse = null;
          _currentTasks = [];
        }
      }
    });
  }

  Future<void> _onCourseSelected(EnrolledCourse? course) async {
    if (course == _selectedCourse && !_isLoading) return;
    
    if (!mounted) return;
    setState(() {
      _selectedCourse = course;
      _isLoading = true;
    });
    
    await _loadAllTasks(specificCourse: course); 
  }

  Future<void> _loadAllTasks({EnrolledCourse? specificCourse}) async {
    if (!mounted) return;
    List<TaskWithSubmission> allTasks = [];
    final studentId = AuthService.currentUser!.id;
    
    final coursesToFetch = specificCourse != null ? [specificCourse] : _allEnrolledCourses;
    
    for (var course in coursesToFetch) {
      final tasks = await _taskService.getTasksForInscription(course.inscription.id, studentId);
      allTasks.addAll(tasks);
    }
    
    allTasks.sort((a, b) {
      int score(TaskStatus status) {
        if (status == TaskStatus.pending) return 0;
        if (status == TaskStatus.notDelivered) return 1;
        return 2;
      }
      return score(a.submission.estado).compareTo(score(b.submission.estado));
    });

    if(mounted) {
      setState(() { 
        _currentTasks = allTasks;
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Todas Las Tareas', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF213354),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitialData,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.grey[100], pinned: true, automaticallyImplyLeading: false,
              expandedHeight: 130, toolbarHeight: 130,
              flexibleSpace: FlexibleSpaceBar(background: _buildFilters()),
            ),
            if (_isLoading)
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            else if (_errorMessage != null)
              SliverFillRemaining(child: Center(child: Text(_errorMessage!)))
            else if (_currentTasks.isEmpty)
              const SliverFillRemaining(child: Center(child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No hay tareas para la selección actual.", textAlign: TextAlign.center),
              )))
            else
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => TaskListItem(
                      taskWithSubmission: _currentTasks[index],
                      onTaskUpdated: _loadInitialData,
                    ),
                    childCount: _currentTasks.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLevelDropdown('Nivel', _selectedLevel, _enrolledLevels, (level) => _filterCoursesByLevel(level)),
          const SizedBox(height: 10),
          _buildCourseDropdown('Programa', _selectedCourse, _filteredCourses, (course) => _onCourseSelected(course)),
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
          value: value, isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.white.withOpacity(0.8))),
          dropdownColor: const Color(0xFF334155),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: items.map((item) => DropdownMenuItem<EnglishLevel>(value: item, child: Text(item.name))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildCourseDropdown(String hint, EnrolledCourse? value, List<EnrolledCourse> items, Function(EnrolledCourse?) onChanged) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF213354), borderRadius: BorderRadius.circular(20)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<EnrolledCourse>(
          value: value, isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.white.withOpacity(0.8))),
          dropdownColor: const Color(0xFF334155),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: items.map((item) => DropdownMenuItem<EnrolledCourse>(value: item, child: Text(item.subLevel.name))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}