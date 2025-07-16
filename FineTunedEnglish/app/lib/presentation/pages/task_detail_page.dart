import 'package:flutter/material.dart';
import 'package:app/presentation/widgets/task_list_item.dart';

class TaskDetailPage extends StatefulWidget {
  final String taskTitle;
  final TaskStatus initialStatus;

  const TaskDetailPage({
    super.key,
    required this.taskTitle,
    required this.initialStatus,
  });

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TaskStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tareas', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF213354),
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      body: _buildBodyForStatus(),
      bottomNavigationBar: _buildBottomNavForStatus(),
    );
  }

  Widget _buildBodyForStatus() {
    switch (_currentStatus) {
      case TaskStatus.notDelivered:
        return _buildNotDeliveredView();
      case TaskStatus.pending:
        return _buildOldPendingView();
      case TaskStatus.done:
      case TaskStatus.graded:
        return _buildDeliveredView();
    }
  }

  Widget? _buildBottomNavForStatus() {
    
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF213354),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Horario'),
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
      ],
    );
  }

  Widget _buildNotDeliveredView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskHeaderNew("Final Project", "No Delivered", "10pts", Colors.red.shade400),
          const SizedBox(height: 8),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          const SizedBox(height: 24),
          _buildDeliveryInfoCard(),
          const SizedBox(height: 24),
          _buildCommentsSection(isDelivered: false),
          const SizedBox(height: 150),
        ],
      ),
    );
  }
  
  Widget _buildOldPendingView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTaskHeaderOld(widget.taskTitle, 'Pendiente', Colors.orange, Icons.hourglass_top_rounded),
          const SizedBox(height: 8),
          const Text(
            'Tarea en progreso. Termina de adjuntar los archivos para entregar.',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          const SizedBox(height: 30),
          Container(
            height: 200,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text('Vista Previa', style: TextStyle(color: Colors.grey, fontSize: 20))),
          ),
          const SizedBox(height: 30),
          _buildActionButton('Adjuntar Archivo', Icons.attach_file, Colors.lightGreen, Colors.white, onPressed: () {}),

          const SizedBox(height: 12),
          _buildActionButton('Entregar Deber', Icons.check_box_outlined, Colors.pink, Colors.white, onPressed: () {
            setState(() { _currentStatus = TaskStatus.graded; });
          }),
          const SizedBox(height: 12),
          _buildActionButton(
            'Cancelar Entrega', 
            Icons.cancel_outlined, 
            const Color(0xFF213354), 
            Colors.white, 
            onPressed: () { Navigator.of(context).pop(); }
          ),
        ],
      ),
    );
  }
  
  Widget _buildDeliveredView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskHeaderOld(widget.taskTitle, 'Delivered', Colors.green, Icons.check_circle_rounded),
          const SizedBox(height: 8),
          const Text(
             'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
             style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          const SizedBox(height: 24),
          _buildQualificationCard(),
          const SizedBox(height: 24),
          _buildCommentsSection(isDelivered: true),
        ],
      ),
    );
  }
  
  


  Widget _buildTaskHeaderNew(String title, String statusText, String points, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: color, size: 16),
            const SizedBox(width: 4),
            Text(statusText, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(points, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
  
  Widget _buildTaskHeaderOld(String title, String statusText, Color statusColor, IconData statusIcon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 18),
            const SizedBox(width: 4),
            Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
  
  Widget _buildDeliveryInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Delivery date', style: TextStyle(color: Colors.pink, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('18/06/2025', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.pink, width: 2.5)),
                child: const Center(child: Text('earring', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF213354)))),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Attach File', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('De 10 pts', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.alarm, color: Colors.pink),
              const SizedBox(width: 8),
              Text('Add reminder notifications', style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton(String text, IconData icon, Color bgColor, Color textColor, {VoidCallback? onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildQualificationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text('qualification', style: TextStyle(color: Colors.pink, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.pink, width: 3)),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('10', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.pink)),
                  Text('Periods', style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Attach File', style: TextStyle(fontWeight: FontWeight.bold)), Text('De 10 pts', style: TextStyle(fontWeight: FontWeight.bold))],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
              trackHeight: 6,
            ),
            child: Slider(
              value: 7.5, min: 0, max: 10,
              onChanged: null,
              activeColor: Colors.pink,
              inactiveColor: Colors.pink.withOpacity(0.3),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Low: 0', style: TextStyle(fontSize: 12)), Text('Average: 7.5', style: TextStyle(fontSize: 12)), Text('high: 10', style: TextStyle(fontSize: 12))],
          ),
          const SizedBox(height: 16),
          const Row(
             children: [
               Text('Delivery date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
               SizedBox(width: 8),
               Text('18/06/2025'),
             ],
           )
        ],
      ),
    );
  }
  
  Widget _buildCommentsSection({required bool isDelivered}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Comentarios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if(isDelivered)
              const Icon(Icons.check_circle_outline, color: Colors.green),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the',
          style: TextStyle(color: Colors.black54),
        )
      ],
    );
  }
}