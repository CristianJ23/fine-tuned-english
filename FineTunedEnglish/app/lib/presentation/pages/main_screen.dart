import 'package:flutter/material.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/app_drawer.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'calendar_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  static const List<String> _appBarTitles = <String>[
    'Calendario',
    'Inicio',
    'Perfil',
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    CalendarPage(),
    HomePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: _appBarTitles[_selectedIndex]),
      drawer: const AppDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF213354),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Horario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Perfil',
          ),
        ],
        // ==============================================================

        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}