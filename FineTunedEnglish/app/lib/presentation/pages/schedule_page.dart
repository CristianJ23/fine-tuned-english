import 'package:flutter/material.dart';
import '../models/english_level.dart';
import '../models/sub_level.dart';
import '../models/usuarios.dart'; 
import '../services/auth_service.dart';
import '../services/level_service.dart';
import '../widgets/shared_footer.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final LevelService _levelService = LevelService();
  late Usuarios _currentUser;

  List<EnglishLevel> _availableLevels = [];
  EnglishLevel? _selectedLevel;
  
  List<SubLevel> _subLevels = [];
  bool _isLoadingLevels = true;
  bool _isLoadingSubLevels = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }
  
  Future<void> _loadInitialData() async {
    _currentUser = AuthService.currentUser!;
    
    final levels = await _levelService.getAvailableLevels(_currentUser.fechaNacimiento);
    if (mounted) {
      setState(() {
        _availableLevels = levels;
        _isLoadingLevels = false;
        if (levels.isNotEmpty) {
          _onLevelSelected(levels.first);
        }
      });
    }
  }

  Future<void> _onLevelSelected(EnglishLevel? level) async {
    if (level == null || level == _selectedLevel) return;
    setState(() {
      _selectedLevel = level;
      _isLoadingSubLevels = true;
      _subLevels = [];
    });
    final subLevels = await _levelService.getSubLevelsForLevel(level.id);
    if (mounted) {
      setState(() {
        _subLevels = subLevels;
        _isLoadingSubLevels = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF213354),
        title: const Text('Horarios', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        actions: [
          IconButton(icon: const Icon(Icons.undo, size: 28), onPressed: () => Navigator.of(context).pop()),
          const SizedBox(width: 10),
        ],
        elevation: 0,
      ),
      body: _isLoadingLevels
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildProgramSelector(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _isLoadingSubLevels 
                        ? const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
                        : _buildSubLevelsList(),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const SharedFooter(),
    );
  }

  Widget _buildProgramSelector() {
    return Container(
      color: const Color(0xFF213354),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: DropdownButtonFormField<EnglishLevel>(
        value: _selectedLevel,
        onChanged: _onLevelSelected,
        isExpanded: true,
        dropdownColor: const Color(0xFF334155),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF213354),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white54)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: _availableLevels.map((level) {
          return DropdownMenuItem(
            value: level,
            child: Text(level.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          );
        }).toList(),
        hint: const Text('Selecciona un Nivel', style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  Widget _buildSubLevelsList() {
    if (_subLevels.isEmpty && !_isLoadingSubLevels) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text('No hay cursos disponibles para el nivel seleccionado.', textAlign: TextAlign.center,),
      ));
    }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _subLevels.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final subLevel = _subLevels[index];
        return _buildScheduleCard(subLevel: subLevel, levelId: _selectedLevel!.id);
      },
    );
  }

  Widget _buildScheduleCard({required SubLevel subLevel, required String levelId}) {
    Color cardColor = subLevel.cuposDisponibles > 5 ? Colors.blueAccent : Colors.redAccent;
    double progress = subLevel.cuposTotales > 0 ? (subLevel.cuposTotales - subLevel.cuposDisponibles) / subLevel.cuposTotales : 1.0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF213354), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(subLevel.name, style: TextStyle(color: cardColor, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildCardInfoRow(Icons.calendar_today_outlined, subLevel.dias, subLevel.horas),
          const SizedBox(height: 16),
          _buildCardInfoRow(Icons.people_outline, '${subLevel.cuposDisponibles} Cupos Disponibles', '', iconColor: cardColor),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade600,
              valueColor: AlwaysStoppedAnimation<Color>(cardColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 40, top: 4),
              child: Text('${subLevel.cuposTotales} Total', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              final scheduleData = {
                'id': subLevel.id,
                'levelId': levelId,
                'name': subLevel.name,
                'days': subLevel.dias,
                'hours': subLevel.horas,
                'cost': subLevel.costo,
              };
              Navigator.of(context).pop(scheduleData);
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Inscribirse', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInfoRow(IconData icon, String line1, String line2, {Color iconColor = Colors.white}) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(line1, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            if (line2.isNotEmpty) Text(line2, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
          ],
        ),
      ],
    );
  }
}