import 'package:flutter/material.dart';
import 'home_page.dart';
import 'schedule_page.dart';
import 'profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Índice de la pestaña seleccionada, empieza en 0 (Inicio)

  // Lista de las páginas que se mostrarán
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SchedulePage(),
    ProfilePage(),
  ];

  // Método que se llama cuando se toca una pestaña
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Muestra la página seleccionada
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded), // Ícono de libro para Inicio
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded), // Ícono de calendario para Horario
            label: 'Horario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded), // Ícono de persona para Perfil
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex, // La pestaña actualmente activa
        selectedItemColor: Colors.blue[800], // Color del ícono seleccionado
        onTap: _onItemTapped, // Función que se ejecuta al tocar
      ),
    );
  }
}