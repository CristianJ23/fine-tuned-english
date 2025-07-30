import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // <-- IMPORT
import '../widgets/announcement_card.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final List<Map<String, dynamic>> _announcements = [
    {
      'type': 'Tarea creada',
      'description': 'Lorem Lopus bebesss sadbas asdddsahb',
      'date': '12/05/1015',
      'time': '10:30',
      'color': const Color(0xFFFFEBEE),
      'icon': Icons.laptop,
      'iconColor': Colors.redAccent,
      'trailingIcon': Icons.remove_red_eye_outlined,
      'trailingIconColor': Colors.green,
    },
    {
      'type': 'Cancelacion de clases',
      'description': 'Lorem Lopus bebesss sadbas asdddsahb',
      'date': '12/05/1015',
      'time': '10:30',
      'color': const Color(0xFFE3F2FD),
      'icon': Icons.close,
      'iconColor': Colors.blueAccent,
      'trailingIcon': null,
      'trailingIconColor': null,
    },
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF213354),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        // <-- CORRECCIÓN
        title: Text(
          'pages.announcements.title'.tr(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: const Color(0xFF213354),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // <-- CORRECCIÓN
                _buildTab('pages.announcements.tabAll'.tr(), 0),
                _buildTab('pages.announcements.tabUnread'.tr(), 1),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          final announcement = _announcements[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: AnnouncementCard(
              type: announcement['type'],
              description: announcement['description'],
              date: announcement['date'],
              time: announcement['time'],
              backgroundColor: announcement['color'],
              leadingIcon: announcement['icon'],
              leadingIconColor: announcement['iconColor'],
              trailingIcon: announcement['trailingIcon'],
              trailingIconColor: announcement['trailingIconColor'],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  // <-- CORRECCIÓN
                  SnackBar(content: Text('pages.announcements.openingAnnouncement'.tr(
                    namedArgs: {'type': announcement['type']}
                  ))),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}