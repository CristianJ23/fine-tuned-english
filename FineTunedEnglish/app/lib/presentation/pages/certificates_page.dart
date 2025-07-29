import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/foundation.dart' show compute, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Extras para flujo no bloqueante
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

// NUEVO: servicios/modelos y footer
import '../models/usuarios.dart';
import '../models/english_level.dart'; // Import EnglishLevel model
import '../services/auth_service.dart';
import '../services/level_service.dart'; // Import LevelService
import '../widgets/shared_footer.dart';

// ====== Isolate: función pura que construye el PDF ======
class _PdfParams {
  final Uint8List bgBytes;
  final String studentName;
  _PdfParams(this.bgBytes, this.studentName);
}

Future<Uint8List> _buildPdfIsolate(_PdfParams params) async {
  final pdf = pw.Document();
  final bg = pw.MemoryImage(params.bgBytes);

  final pageTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    margin: pw.EdgeInsets.zero,
    theme: pw.ThemeData.withFont(),
    buildBackground: (context) => pw.FullPage(
      ignoreMargins: true,
      child: pw.Image(bg, fit: pw.BoxFit.cover),
    ),
  );

  pdf.addPage(
    pw.Page(
      pageTheme: pageTheme,
      build: (context) {
        return pw.Stack(
          children: [
            pw.Positioned(
              left: 230,
              top: 300,
              child: pw.Transform.rotate(
                angle: -math.pi / 2,
                child: pw.Text(
                  params.studentName,
                  style: const pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

// ====== Widget ======
class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  final ValueNotifier<int> _jobsInProgress = ValueNotifier<int>(0);
  Uint8List? _bgBytes;

  Usuarios? _currentUser;
  String _studentName = '';

  final LevelService _levelService = LevelService();
  List<EnglishLevel> _availableLevels = [];
  EnglishLevel? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _preloadBackground();
    _loadUserName();
    _loadAvailableLevels();
  }

  @override
  void dispose() {
    _jobsInProgress.dispose();
    super.dispose();
  }

  void _loadUserName() {
    _currentUser = AuthService.currentUser;
    final nombres = _currentUser?.nombres?.trim() ?? '';
    final apellidos = _currentUser?.apellidos?.trim() ?? '';
    final fullName = [nombres, apellidos].where((s) => s.isNotEmpty).join(' ');
    setState(() {
      _studentName = fullName.isNotEmpty ? fullName : 'Estudiante';
    });
  }

  Future<void> _preloadBackground() async {
    try {
      final byteData =
      await rootBundle.load('assets/certificates/certificado.png');
      var bytes = byteData.buffer.asUint8List();
      setState(() {
        _bgBytes = bytes;
      });
    } catch (e) {
      debugPrint('No se pudo precargar el fondo: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cargar el fondo del certificado.')),
      );
    }
  }

  Future<void> _loadAvailableLevels() async {
    if (_currentUser == null) return;
    final levels = await _levelService.getAvailableLevels(_currentUser!.fechaNacimiento);
    if (mounted) {
      setState(() {
        _availableLevels = levels;
        if (levels.isNotEmpty) {
          _selectedLevel = levels.first;
        }
      });
    }
  }

  Future<void> _generatePdfInBackground() async {
    if (_bgBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cargando recursos, intenta de nuevo…')),
      );
      return;
    }

    if (_studentName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener el nombre del usuario.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generando certificado en segundo plano…')),
    );

    _jobsInProgress.value++;

    try {
      final bytes = await compute(
        _buildPdfIsolate,
        _PdfParams(_bgBytes!, _studentName.trim()),
      );

      if (kIsWeb) {
        await Printing.sharePdf(
          bytes: bytes,
          filename:
          'certificado_${_studentName.trim().replaceAll(' ', '_')}.pdf',
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Certificado listo para descargar.')),
        );
        return;
      }

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/certificado_${_studentName.trim().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(bytes, flush: true);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Certificado generado!'),
          action: SnackBarAction(
            label: 'ABRIR',
            onPressed: () {
              OpenFilex.open(file.path);
            },
          ),
          duration: const Duration(seconds: 6),
        ),
      );

      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (ctx) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Text('Certificado listo'),
                  subtitle: Text('¿Qué deseas hacer?'),
                ),
                ListTile(
                  leading: const Icon(Icons.open_in_new),
                  title: const Text('Abrir'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    OpenFilex.open(file.path);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Compartir'),
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await Share.shareXFiles([XFile(file.path)]);
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Error al generar/guardar/compartir el PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      _jobsInProgress.value--;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _bgBytes != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF213354),
        title: const Text('Generador de Certificados',
            style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // Adjust height as needed
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButtonFormField<EnglishLevel>(
              value: _selectedLevel,
              onChanged: (EnglishLevel? newValue) {
                setState(() {
                  _selectedLevel = newValue;
                  // You might want to reload student name or other data based on the selected level here
                });
              },
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
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 10),
          ValueListenableBuilder<int>(
            valueListenable: _jobsInProgress,
            builder: (_, jobs, __) {
              if (jobs <= 0) return const SizedBox.shrink();
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),
        ],
        elevation: 0,
      ),

      body: Center(
        child: ElevatedButton(
          onPressed: isReady ? _generatePdfInBackground : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF213354),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: Text(
            isReady ? 'Generar certificado' : 'Preparando recursos…',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),

      // Footer compartido con el mismo estilo
      bottomNavigationBar: const SharedFooter(),
    );
  }
}