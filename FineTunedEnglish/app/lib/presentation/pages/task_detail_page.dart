import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart'; // <-- IMPORT
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
        // <-- CORRECCIÓN
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('pages.taskDetail.submissionSuccess'.tr()),
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

  void _showFilePickerSimulationDialog() {
    // Usamos un StatefulBuilder para que el TextField se actualice dentro del diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              // <-- CORRECCIÓN
              title: Text('pages.taskDetail.attachFile'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    readOnly: true,
                    // <-- CORRECCIÓN
                    controller: TextEditingController(text: _selectedFileName ?? 'pages.taskDetail.noFileSelected'.tr()),
                    decoration: InputDecoration(
                      labelText: 'common.file'.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.folder_open),
                        onPressed: () {
                          // Simulamos la selección y actualizamos el estado del diálogo
                          setDialogState(() {
                            _selectedFileName = 'documento_ejemplo.pdf';
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_selectedFileName != null) {
                        Navigator.of(context).pop();
                        // <-- CORRECCIÓN
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('pages.taskDetail.fileUploaded'.tr()),
                          backgroundColor: Colors.blueAccent,
                        ));
                      } else {
                        // <-- CORRECCIÓN
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('pages.taskDetail.selectFileFirst'.tr()),
                          backgroundColor: Colors.orange,
                        ));
                      }
                    },
                    icon: const Icon(Icons.upload_file),
                    // <-- CORRECCIÓN
                    label: Text('pages.taskDetail.uploadFile'.tr()),
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
                    Navigator.of(context).pop();
                    setDialogState(() {
                      _selectedFileName = null;
                    });
                  },
                  // <-- CORRECCIÓN
                  child: Text('common.cancel'.tr(), style: const TextStyle(color: Colors.grey)),
                ),
              ],
            );
          },
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
    return null; // El resto no tiene barra inferior
  }
  
  // Mapea el enum a las claves de traducción
  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'taskStatus.pending'.tr();
      case TaskStatus.notDelivered:
        return 'taskStatus.notDelivered'.tr();
      case TaskStatus.done:
        return 'taskStatus.done'.tr();
      case TaskStatus.graded:
        return 'taskStatus.graded'.tr();
      default:
        return '';
    }
  }

  Widget _buildNotDeliveredView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // <-- CORRECCIÓN
        _buildTaskHeaderNew(task.titulo, _getStatusText(TaskStatus.notDelivered), "${task.puntajeDisponible.toStringAsFixed(0)}pts", Colors.red.shade400),
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
        // <-- CORRECCIÓN
        _buildTaskHeaderOld(task.titulo, _getStatusText(TaskStatus.pending), Colors.orange, Icons.hourglass_top_rounded),
        const SizedBox(height: 8),
        // <-- CORRECCIÓN
        Text('pages.taskDetail.pendingMessage'.tr(), style: const TextStyle(color: Colors.black54, fontSize: 16)),
        const SizedBox(height: 30),
        Container(height: 200, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(16)), child: Center(child: Text('Vista Previa'))), // "Vista Previa" podría ser otra clave
        const SizedBox(height: 30),
        // <-- CORRECCIÓN
        _buildActionButton('pages.taskDetail.attachFileSimulated'.tr(), Icons.attach_file, Colors.lightGreen, Colors.white, onPressed: _showFilePickerSimulationDialog),
        const SizedBox(height: 12),
        _buildActionButton('pages.taskDetail.submitHomework'.tr(), Icons.check_box_outlined, Colors.pink, Colors.white, onPressed: _isLoading ? null : _submitHomework),
        const SizedBox(height: 12),
        _buildActionButton('pages.taskDetail.cancelSubmission'.tr(), Icons.cancel_outlined, const Color(0xFF213354), Colors.white, onPressed: () => Navigator.of(context).pop()),
      ]),
    );
  }

  Widget _buildDeliveredView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // <-- CORRECCIÓN
        _buildTaskHeaderOld(task.titulo, _getStatusText(_currentStatus), Colors.green, Icons.check_circle_rounded),
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
        // <-- CORRECCIÓN
        _buildActionButton('pages.taskDetail.attachFileSimulated'.tr(), Icons.attach_file, Colors.lightGreen, Colors.white, onPressed: _isLoading ? null : _showFilePickerSimulationDialog),
        const SizedBox(height: 12),
        _buildActionButton('pages.taskDetail.submitHomework'.tr(), Icons.check_box_outlined, Colors.pink, Colors.white, onPressed: _isLoading ? null : _submitHomework),
        const SizedBox(height: 12),
        _buildActionButton('common.cancel'.tr(), Icons.cancel_outlined, const Color(0xFF334155), Colors.white, onPressed: () => Navigator.of(context).pop()),
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
    final formattedDate = DateFormat.yMMMMd(context.locale.toString()).format(task.fechaEntrega);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // <-- CORRECCIÓN
        Text('pages.taskDetail.deliveryDate'.tr(), style: const TextStyle(color: Colors.pink, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(formattedDate, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.pink, width: 2.5)), child: Center(child: Text('taskStatus.pending'.tr(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213354))))),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // <-- CORRECCIÓN
            Text('pages.taskDetail.attachFile'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 16),
            Text('pages.taskDetail.ofPoints'.tr(namedArgs: {'points': task.puntajeDisponible.toStringAsFixed(0)}), style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ]),
        const SizedBox(height: 20),
        // <-- CORRECCIÓN
        Row(children: [ const Icon(Icons.alarm, color: Colors.pink), const SizedBox(width: 8), Text('pages.taskDetail.addReminderNotifications'.tr(), style: TextStyle(color: Colors.grey[700])) ]),
      ]),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color bgColor, Color textColor, {VoidCallback? onPressed}) {
    return ElevatedButton.icon(onPressed: onPressed, icon: _isLoading && text == 'pages.taskDetail.submitHomework'.tr() ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(icon, color: textColor), label: Text(text), style: ElevatedButton.styleFrom(backgroundColor: bgColor, foregroundColor: textColor, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
  }

  Widget _buildQualificationCard() {
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.pink.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.pink.withOpacity(0.2))), child: Column(children: [ 
      // <-- CORRECCIÓN
      Text('pages.taskDetail.qualification'.tr(), style: const TextStyle(color: Colors.pink, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 16), 
      Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.pink, width: 3)), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ 
        Text(submission.puntajeObtenido?.toStringAsFixed(1) ?? 'N/A', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.pink)), 
        Text('pages.taskDetail.periods'.tr(), style: const TextStyle(color: Colors.black54)) 
      ]))), const SizedBox(height: 16), 
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ 
        Text('pages.taskDetail.attachFile'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)), 
        Text('pages.taskDetail.ofPoints'.tr(namedArgs: {'points': task.puntajeDisponible.toStringAsFixed(0)}), style: const TextStyle(fontWeight: FontWeight.bold)) 
      ]), const SizedBox(height: 8), 
      SliderTheme(data: SliderTheme.of(context).copyWith(thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0), overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0), trackHeight: 6), child: Slider(value: submission.puntajeObtenido ?? 0.0, min: 0, max: task.puntajeDisponible, onChanged: null, activeColor: Colors.pink, inactiveColor: Colors.pink.withOpacity(0.3))), 
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('pages.taskDetail.low'.tr()), 
        Text('pages.taskDetail.average'.tr()), 
        Text('pages.taskDetail.high'.tr())
      ]), const SizedBox(height: 16), 
      Row(children: [ 
        Text('pages.taskDetail.deliveryDate'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)), 
        const SizedBox(width: 8), 
        Text(DateFormat.yMMMMd(context.locale.toString()).format(submission.fechaEntrega ?? DateTime.now())) 
      ]) 
    ]));
  }

  Widget _buildCommentsSection({required bool isDelivered}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ 
        Text('pages.taskDetail.comments'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), 
        if(isDelivered) const Icon(Icons.check_circle_outline, color: Colors.green) 
      ]), const SizedBox(height: 8), 
      Text(submission.comentariosProfesor ?? 'pages.taskDetail.noCommentsYet'.tr(), style: const TextStyle(color: Colors.black54)), 
    ]);
  }
}