

// english_level_detail_screen.dart
// Esta pantalla muestra los detalles de un nivel de inglés y sus subniveles disponibles.
import 'package:flutter/material.dart';
import '../models/english_level.dart'; // Importa el modelo EnglishLevel
import '../models/sub_level.dart';     // Importa el modelo SubLevel
import '../services/english_level_service.dart'; // Importa el servicio para obtener datos
import '../widgets/shared_footer.dart'; // Asegúrate de que esta ruta sea correcta para tu proyecto

class EnglishLevelDetailScreen extends StatefulWidget {
  final String levelId; // El ID del nivel de inglés a mostrar

  const EnglishLevelDetailScreen({super.key, required this.levelId});

  @override
  State<EnglishLevelDetailScreen> createState() => _EnglishLevelDetailScreenState();
}

class _EnglishLevelDetailScreenState extends State<EnglishLevelDetailScreen> {
  final EnglishLevelService _englishLevelService = EnglishLevelService();

  List<EnglishLevel> _allLevels = []; // Lista de todos los niveles disponibles para el Dropdown
  EnglishLevel? _selectedLevel;     // El nivel de inglés actualmente seleccionado
  List<SubLevel> _subLevels = [];   // Lista de subniveles para el nivel seleccionado

  bool _isLoadingLevels = true;     // Indicador de carga para los niveles principales
  bool _isLoadingSubLevels = false; // Indicador de carga para los subniveles

  @override
  void initState() {
    super.initState();
    // Al iniciar, cargamos todos los niveles y luego los subniveles del nivel inicial.
    _loadLevelsAndInit(widget.levelId);
  }

  // Carga todos los niveles de inglés y selecciona el nivel inicial.
  Future<void> _loadLevelsAndInit(String levelId) async {
    print('[_loadLevelsAndInit] Intentando cargar niveles...');
    setState(() {
      _isLoadingLevels = true;
      _isLoadingSubLevels = true; // También mostramos el indicador de carga para subniveles
    });

    try {
      final levels = await _englishLevelService.getAllEnglishLevels();
      print('[_loadLevelsAndInit] Niveles obtenidos: ${levels.length}');

      EnglishLevel? selected;

      if (levels.isNotEmpty) {
        // Intenta encontrar el nivel por el ID pasado al constructor.
        // Si no se encuentra, selecciona el primer nivel de la lista como predeterminado.
        selected = levels.firstWhere((lvl) => lvl.id == levelId, orElse: () {
          print('[_loadLevelsAndInit] Nivel con ID "$levelId" no encontrado. Seleccionando el primer nivel disponible.');
          return levels.first;
        });
        print('[_loadLevelsAndInit] Nivel inicial seleccionado: ${selected.name} (ID: ${selected.id})');
      } else {
        print('[_loadLevelsAndInit] No se encontraron niveles de inglés en Firestore.');
      }

      setState(() {
        _allLevels = levels;
        _selectedLevel = selected;
        _isLoadingLevels = false;
      });

      // Si se seleccionó un nivel, carga sus subniveles.
      if (selected != null) {
        await _loadSubLevels(selected.id);
      } else {
        setState(() {
          _isLoadingSubLevels = false; // Si no hay niveles, no hay subniveles que cargar.
        });
      }
    } catch (e) {
      print('[_loadLevelsAndInit] Error al cargar niveles o subniveles iniciales: $e');
      setState(() {
        _isLoadingLevels = false;
        _isLoadingSubLevels = false;
      });
    }
  }

  // Carga los subniveles para un nivel de inglés dado su ID.
  Future<void> _loadSubLevels(String levelId) async {
    setState(() {
      _isLoadingSubLevels = true;
      _subLevels = []; // Limpia la lista de subniveles anteriores antes de cargar nuevos.
    });

    try {
      final subs = await _englishLevelService.getSubLevelsForEnglishLevel(levelId);
      setState(() {
        _subLevels = subs;
        _isLoadingSubLevels = false;
      });
    } catch (e) {
      print('Error al cargar subniveles: $e');
      setState(() {
        _isLoadingSubLevels = false;
      });
    }
  }

  // Se llama cuando el usuario selecciona un nivel diferente en el Dropdown.
  void _onLevelChanged(EnglishLevel? newLevel) {
    if (newLevel != null) {
      setState(() => _selectedLevel = newLevel); // Actualiza el nivel seleccionado.
      _loadSubLevels(newLevel.id); // Carga los subniveles para el nuevo nivel.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horarios Disponibles'),
        backgroundColor: const Color(0xFF213354), // Color de la barra de aplicación
        iconTheme: const IconThemeData(color: Colors.white), // Color de los iconos en la barra
      ),
      body: _isLoadingLevels
          ? const Center(child: CircularProgressIndicator()) // Muestra un indicador de carga si los niveles están cargando.
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selecciona un nivel:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Dropdown para seleccionar el nivel de inglés.
            DropdownButton<EnglishLevel>(
              isExpanded: true,
              value: _selectedLevel,
              hint: const Text('Selecciona un nivel'),
              items: _allLevels.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level.name), // Muestra el nombre del nivel en el Dropdown.
                );
              }).toList(),
              onChanged: _onLevelChanged, // Maneja el cambio de selección.
            ),
            const SizedBox(height: 16),
            // Muestra la descripción del nivel seleccionado, si hay uno.
            if (_selectedLevel != null) ...[
              Text(
                _selectedLevel!.description,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 16),
            ],
            // Mensaje si no hay niveles cargados en absoluto.
            if (_allLevels.isEmpty && !_isLoadingLevels)
              const Text('No hay niveles de inglés disponibles en Firestore. Por favor, verifica tu base de datos y reglas de seguridad.'),
            const SizedBox(height: 16),
            // Muestra un indicador de carga si los subniveles están cargando.
            _isLoadingSubLevels
                ? const Center(child: CircularProgressIndicator())
            // Mensaje si no hay subniveles para el nivel seleccionado.
                : _subLevels.isEmpty && !_isLoadingLevels && _selectedLevel != null
                ? const Text('No hay subniveles disponibles para este nivel.')
            // Lista de subniveles si se han cargado.
                : ListView.builder(
              shrinkWrap: true, // Para que el ListView ocupe solo el espacio necesario.
              physics: const NeverScrollableScrollPhysics(), // Deshabilita el scroll propio del ListView.
              itemCount: _subLevels.length,
              itemBuilder: (context, index) {
                final sub = _subLevels[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: const Color(0xFF213354), // Color de fondo de la tarjeta.
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Muestra el nombre del subnivel.
                        Text(
                          sub.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        // Muestra el ID del subnivel.
                        Text(
                          'ID: ${sub.id}',
                          style: const TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        // Muestra el paralelo si está disponible.
                        if (sub.paralelo != null && sub.paralelo!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Paralelo ${sub.paralelo}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        const SizedBox(height: 8),
                        // Iconos y texto para días y horas.
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(sub.dias, style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(sub.horas, style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Información de cupos disponibles.
                        Text(
                          '${sub.cuposDisponibles} cupos disponibles de ${sub.cuposTotales}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        // Barra de progreso para los cupos.
                        LinearProgressIndicator(
                          value: sub.cuposTotales == 0
                              ? 0
                              : sub.cuposDisponibles / sub.cuposTotales,
                          backgroundColor: Colors.grey[700],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                        ),
                        const SizedBox(height: 10),
                        // Botón para inscribirse.
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Al presionar, se devuelve el subnivel seleccionado a la pantalla anterior.
                              Navigator.pop(context, sub);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF213354),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Inscribirse'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const SharedFooter(), // Pie de página compartido.
          ],
        ),
      ),
    );
  }
}
