import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para ocultar la barra de estado
import 'presentation/pages/login_page.dart'; // Asegúrate que esta ruta sea correcta

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Oculta la barra de estado (hora, batería, etc.)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

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
      home: const LoginPage(), // <- Aquí inicia en Login
    );
  }
}
