import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/auth_tabs.dart';
import 'main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == '123@hotmail.com' && password == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // Título + imagen con padding abajo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'FINE-TUNED ENGLISH\nLANGUAGE INSTITUTE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Imagen
                    Padding(
                      padding: const EdgeInsets.only(top: 0, right: 4),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset(
                          'assets/splash/app_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const AuthTabs(isLogin: true),
              const SizedBox(height: 24),
              const Text(
                'Inicie sesión\nmediante su cuenta organizativa',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),

              InputField(
                icon: Icons.person_outline,
                hint: 'Correo',
                controller: _emailController,
              ),
              const SizedBox(height: 15),

              InputField(
                icon: Icons.lock_outline,
                hint: 'Contraseña',
                obscure: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE62054),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _login,
                  child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text.rich(
                    TextSpan(
                      text: '¿Olvidaste tu contraseña? ',
                      children: [
                        TextSpan(
                          text: 'Click aquí',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
