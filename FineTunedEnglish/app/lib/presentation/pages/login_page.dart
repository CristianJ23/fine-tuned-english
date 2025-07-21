import 'package:flutter/material.dart';
// Asegúrate de que las rutas de import sean correctas
import 'package:app/presentation/services/auth_service.dart';
import 'package:app/presentation/widgets/input_field.dart';
import 'package:app/presentation/widgets/auth_tabs.dart';
import 'package:app/presentation/pages/main_screen.dart';
import 'package:app/presentation/pages/register_page.dart'; // Añadir import si aún no estaba

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Usamos el nombre de clase estandarizado: AuthService
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // ===== AÑADE ESTA LÍNEA DE DEPURACIÓN AQUÍ =====
    print("Intentando iniciar sesión con: Email -> '$email' | Password -> '$password'");
    // ===============================================

    final error = await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );


    if (mounted) {
      if (error == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else {
        setState(() {
          _errorMessage = error;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FINE-TUNED ENGLISH\nLANGUAGE INSTITUTE',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, right: 4),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset('assets/splash/app_icon.png', fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Icon(Icons.school, size: 80, color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const AuthTabs(isLogin: true),
              const SizedBox(height: 24),
              const Text('Inicie sesión\nmediante su cuenta organizativa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(height: 30),

              InputField(icon: Icons.person_outline, hint: 'Correo', controller: _emailController),
              const SizedBox(height: 15),
              InputField(icon: Icons.lock_outline, hint: 'Contraseña', obscure: true, controller: _passwordController),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 14)),
                  ),
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
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text('Iniciar sesión', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text.rich(
                    TextSpan(
                      text: '¿Olvidaste tu contraseña? ',
                      children: [TextSpan(text: 'Click aquí', style: TextStyle(fontWeight: FontWeight.bold))],
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