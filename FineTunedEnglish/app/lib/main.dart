import 'package:flutter/material.dart';
import 'presentation/pages/main_screen.dart'; // <-- CAMBIO: Importamos MainScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fine App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF4F5F7),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(), // <-- CAMBIO: MainScreen es ahora la página de inicio
    );
  }
}