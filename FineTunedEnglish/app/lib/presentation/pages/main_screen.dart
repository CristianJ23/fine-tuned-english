import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/app_drawer.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'calendar_page.dart';

class MainScreen extends StatefulWidget {
  // CORRECCIÓN: Aceptamos una Key en el constructor
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  // Volvemos a usar static final porque la Key se encargará de la reconstrucción.
  static final List<Widget> _widgetOptions = <Widget>[
    const CalendarPage(),
    const HomePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Esta lista se crea en cada build, lo cual es correcto.
    final List<String> appBarTitles = <String>[
      'pages.main.calendar'.tr(),
      'pages.main.home'.tr(),
      'pages.main.profile'.tr(),
    ];

    return Scaffold(
      appBar: CommonAppBar(title: appBarTitles[_selectedIndex]),
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF213354),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today_rounded),
            label: 'pages.main.schedule'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: 'pages.main.home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            label: 'pages.main.profile'.tr(),
          ),
        ],
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