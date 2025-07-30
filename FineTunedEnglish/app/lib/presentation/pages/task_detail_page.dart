import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart' as task_model;
import '../models/task_submission.dart';
import '../services/task_service.dart';
import '../widgets/task_list_item.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskWithSubmission taskWithSubmission;
  const TaskDetailPage({super.key, required this.taskWithSubmission});
  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TaskStatus _currentStatus;
  late task_model.Task task;
  late TaskSubmission submission;

  final TaskService _taskService = TaskService();
  bool _isLoading = false;

  // Variable to simulate a selected file name
  String? _selectedFileName;

  @override
  void initState() {
    super.initState();
    task = widget.taskWithSubmission.task;
    submission = widget.taskWithSubmission.submission;
    _currentStatus = submission.estado;
  }

  Future<void> _submitHomework() async {
    setState(() { _isLoading = true; });

    final error = await _taskService.submitTaskSimulation(submission: submission);

    if (mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('¡Tarea entregada con éxito!'),
            backgroundColor: Colors.green
        ));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error),
            backgroundColor: Colors.red
        ));
        setState(() { _isLoading = false; });
      }
    }
  }

  // New method to show the file picker simulation dialog
  void _showFilePickerSimulationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Adjuntar Archivo', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Simulate file input field
              TextField(
                readOnly: true, // Make it read-only to simulate selection
                controller: TextEditingController(text: _selectedFileName ?? 'Ningún archivo seleccionado'),
                decoration: InputDecoration(
                  labelText: 'Archivo',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.folder_open),
                    onPressed: () {
                      // Simulate opening file explorer and selecting a file
                      setState(() {
                        _selectedFileName = 'documento_ejemplo.pdf'; // Simulate a file name
                      });
                      // Update the text field immediately
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_selectedFileName != null) {
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('¡Archivo subido!'),
                      backgroundColor: Colors.blueAccent,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Por favor, selecciona un archivo primero.'),
                      backgroundColor: Colors.orange,
                    ));
                  }
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Subir Archivo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _selectedFileName = null; // Clear simulated file name on cancel
                });
              },
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(task.titulo, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF213354),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBodyForStatus(),
      bottomNavigationBar: _buildBottomNavForStatus(),
    );
  }

  Widget _buildBodyForStatus() {
    switch (_currentStatus) {
      case TaskStatus.notDelivered: return _buildNotDeliveredView();
      case TaskStatus.pending: return _buildOldPendingView();
      case TaskStatus.done:
      case TaskStatus.graded: return _buildDeliveredView();
    }
  }

  Widget? _buildBottomNavForStatus() {
    if (_currentStatus == TaskStatus.notDelivered) {
      return _buildActionButtonsSheet();
    }
    if (_currentStatus == TaskStatus.pending) {
      return null;
    }
    return null;
  }

  Widget _buildNotDeliveredView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildTaskHeaderNew(task.titulo, "No Delivered", "${task.puntajeDisponible.toStringAsFixed(0)}pts", Colors.red.shade400),
        const SizedBox(height: 8),
        Text(task.descripcion, style: const TextStyle(color: Colors.black54, fontSize: 16)),
        const SizedBox(height: 24),
        _buildDeliveryInfoCard(),
        const SizedBox(height: 24),
        _buildCommentsSection(isDelivered: false),
        const SizedBox(height: 150),
      ]),
    );
  }

  Widget _buildOldPendingView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _buildTaskHeaderOld(task.titulo, 'Pendiente', Colors.orange, Icons.hourglass_top_rounded),
        const SizedBox(height: 8),
        const Text('Tarea en progreso. Termina de adjuntar los archivos para entregar.', style: TextStyle(color: Colors.black54, fontSize: 16)),
        const SizedBox(height: 30),
        Container(height: 200, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(16)), child: const Center(child: Text('Vista Previa'))),
        const SizedBox(height: 30),
        // Modified onPressed to call the new dialog method
        _buildActionButton('Adjuntar Archivo (Simulado)', Icons.attach_file, Colors.lightGreen, Colors.white, onPressed: _showFilePickerSimulationDialog),
        const SizedBox(height: 12),
        _buildActionButton('Entregar Deber', Icons.check_box_outlined, Colors.pink, Colors.white, onPressed: _isLoading ? null : _submitHomework),
        const SizedBox(height: 12),
        _buildActionButton('Cancelar Entrega', Icons.cancel_outlined, const Color(0xFF213354), Colors.white, onPressed: () => Navigator.of(context).pop()),
      ]),
    );
  }

  Widget _buildDeliveredView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildTaskHeaderOld(task.titulo, _currentStatus == TaskStatus.graded ? 'Calificada' : 'Entregada', Colors.green, Icons.check_circle_rounded),
        const SizedBox(height: 8),
        Text(task.descripcion, style: const TextStyle(color: Colors.black54, fontSize: 16)),
        const SizedBox(height: 24),
        _buildQualificationCard(),
        const SizedBox(height: 24),
        _buildCommentsSection(isDelivered: true),
      ]),
    );
  }

  Widget _buildActionButtonsSheet() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Modified onPressed to call the new dialog method
        _buildActionButton('Adjuntar Archivo (Simulado)', Icons.attach_file, Colors.lightGreen, Colors.white, onPressed: _isLoading ? null : _showFilePickerSimulationDialog),
        const SizedBox(height: 12),
        _buildActionButton('Entregar Deber', Icons.check_box_outlined, Colors.pink, Colors.white, onPressed: _isLoading ? null : _submitHomework),
        const SizedBox(height: 12),
        _buildActionButton('Cancelar', Icons.cancel_outlined, const Color(0xFF334155), Colors.white, onPressed: () => Navigator.of(context).pop()),
      ]),
    );
  }

  Widget _buildTaskHeaderNew(String title, String statusText, String points, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)), const SizedBox(height: 4), Row(children: [Icon(Icons.warning_amber_rounded, color: color, size: 16), const SizedBox(width: 4), Text(statusText, style: TextStyle(color: color, fontWeight: FontWeight.bold)), const Spacer(), Text(points, style: TextStyle(color: color, fontWeight: FontWeight.bold))]) ]);
  }

  Widget _buildTaskHeaderOld(String title, String statusText, Color statusColor, IconData statusIcon) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Row(children: [Icon(statusIcon, color: statusColor, size: 18), const SizedBox(width: 4), Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold))]) ]);
  }

  Widget _buildDeliveryInfoCard() {
    final formattedDate = DateFormat('dd/MM/yyyy').format(task.fechaEntrega);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Delivery date', style: TextStyle(color: Colors.pink, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(formattedDate, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.pink, width: 2.5)), child: const Center(child: Text('earring', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213354))))),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Attach File', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 16),
            Text('De ${task.puntajeDisponible.toStringAsFixed(0)} pts', style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ]),
        const SizedBox(height: 20),
        Row(children: [ const Icon(Icons.alarm, color: Colors.pink), const SizedBox(width: 8), Text('Add reminder notifications', style: TextStyle(color: Colors.grey[700])) ]),
      ]),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color bgColor, Color textColor, {VoidCallback? onPressed}) {
    return ElevatedButton.icon(onPressed: onPressed, icon: _isLoading && (text == 'Entregar Deber') ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(icon, color: textColor), label: Text(text), style: ElevatedButton.styleFrom(backgroundColor: bgColor, foregroundColor: textColor, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
  }

  Widget _buildQualificationCard() {
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.pink.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.pink.withOpacity(0.2))), child: Column(children: [ const Text('qualification', style: TextStyle(color: Colors.pink, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 16), Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.pink, width: 3)), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Text(submission.puntajeObtenido?.toStringAsFixed(1) ?? 'N/A', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.pink)), const Text('Periods', style: TextStyle(color: Colors.black54)) ]))), const SizedBox(height: 16), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ const Text('Attach File', style: TextStyle(fontWeight: FontWeight.bold)), Text('De ${task.puntajeDisponible.toStringAsFixed(0)} pts', style: const TextStyle(fontWeight: FontWeight.bold)) ]), const SizedBox(height: 8), SliderTheme(data: SliderTheme.of(context).copyWith(thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0), overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0), trackHeight: 6), child: Slider(value: submission.puntajeObtenido ?? 0.0, min: 0, max: task.puntajeDisponible, onChanged: null, activeColor: Colors.pink, inactiveColor: Colors.pink.withOpacity(0.3))), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Low: 0'), Text('Average: 7.5'), Text('high: 10')]), const SizedBox(height: 16), Row(children: [ const Text('Delivery date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)), const SizedBox(width: 8), Text(DateFormat('dd/MM/yyyy').format(submission.fechaEntrega ?? DateTime.now())) ]) ]));
  }

  Widget _buildCommentsSection({required bool isDelivered}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ const Text('Comentarios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), if(isDelivered) const Icon(Icons.check_circle_outline, color: Colors.green) ]), const SizedBox(height: 8), Text(submission.comentariosProfesor ?? "No hay comentarios aún.", style: const TextStyle(color: Colors.black54)), ]);
  }
}
