import 'package:flutter/material.dart';
import '../widgets/shared_footer.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String _selectedProgram = 'youth_program';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF213354),
        title: const Text('Horarios', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 10),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProgramSelector(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildScheduleCard(
                    title: 'Paralelo A',
                    titleColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
                    scheduleDays: 'Lunes a Viernes',
                    scheduleHours: '17:00 - 19:00',
                    availableSlots: 12,
                    totalSlots: 16,
                  ),
                  const SizedBox(height: 20),
                   _buildScheduleCard(
                    title: 'Paralelo B',
                    titleColor: Colors.blueAccent,
                    iconColor: Colors.blueAccent,
                    scheduleDays: 'Lunes a Viernes',
                    scheduleHours: '15:00 - 17:00',
                    availableSlots: 16,
                    totalSlots: 16,
                  ),
                  const SizedBox(height: 30),
                  _buildBenefitsSection(),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const SharedFooter(),
    );
  }

    Widget _buildProgramSelector() {
    return Container(
      color: const Color(0xFF213354),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white54, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedProgram,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProgram = newValue!;
                  });
                },
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                dropdownColor: const Color(0xFF334155),
                items: const [
                  DropdownMenuItem(
                    value: 'youth_program',
                    child: Text(
                      'A.1.1 YOUTH PROGRAM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              'Octubre 2025 - Febrero 2026',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required Color titleColor,
    required Color iconColor,
    required String scheduleDays,
    required String scheduleHours,
    required int availableSlots,
    required int totalSlots,
  }) {
    double progress = availableSlots > 0 ? (totalSlots - availableSlots) / totalSlots : 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF213354),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: TextStyle(color: titleColor, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildCardInfoRow(Icons.calendar_today_outlined, scheduleDays, scheduleHours),
          const SizedBox(height: 16),
          _buildCardInfoRow(Icons.people_outline, '$availableSlots Cupos Disponibles', '', iconColor: iconColor),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade600,
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 40, top: 4),
              child: Text('$totalSlots Total', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              final scheduleData = {
                'name': title,
                'days': scheduleDays,
                'hours': scheduleHours,
                'cost': 250.00,
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
            if (line2.isNotEmpty) 
              Text(line2, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitsSection() {
    return Column(
      children: [
        const Text(
          'Obtendras',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBenefitItem(Icons.phone_android, 'Acceso al\nApp Movil'),
            _buildBenefitItem(Icons.workspace_premium_outlined, 'Certificado al finalizar\nel programa'),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.grey.shade600, size: 30),
        ),
        const SizedBox(height: 8),
        Text(text, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }
}