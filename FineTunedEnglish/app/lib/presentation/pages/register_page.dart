// register_page.dart (MODIFICADO PARA REDIRECCIONAR A PÁGINA DE PAGO)
import 'package:app/presentation/models/english_level.dart'; // No longer strictly needed for direct payment redirect, but can be kept if 'english_level.dart' is used elsewhere.
import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/auth_tabs.dart';
import 'login_page.dart';
import '../services/auth_service.dart';
// import '../services/english_level_service.dart'; // REMOVER: Ya no se necesita para la redirección directa al pago
// import 'englishleveldetailscreen.dart'; // REMOVER: Ya no se necesita para la redirección directa al pago
import 'payment_page.dart'; // IMPORTAR: Tu página de pago

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  bool _termsAccepted = false;
  final AuthService _authService = AuthService();
  // final EnglishLevelService _englishLevelService = EnglishLevelService(); // REMOVER: Ya no se necesita

  void _register() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe aceptar los términos y condiciones')),
      );
      return;
    }

    if (_nameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _cedulaController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _educationController.text.trim().isEmpty ||
        _birthDateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos requeridos')),
      );
      return;
    }

    DateTime? birthDate;
    try {
      final parts = _birthDateController.text.split('/');
      if (parts.length == 3) {
        birthDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formato de fecha de nacimiento inválido. Use DD/MM/YYYY')),
      );
      return;
    }

    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor seleccione una fecha de nacimiento válida')),
      );
      return;
    }

    String? errorMessage = await _authService.registerStudent(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      nombres: _nameController.text.trim(),
      apellidos: _lastNameController.text.trim(),
      numeroCedula: _cedulaController.text.trim(),
      telefono: _phoneController.text.trim(),
      nivelEducacion: _educationController.text.trim(),
      fechaNacimiento: birthDate,
    );

    if (errorMessage == null) {
      // Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso. Redireccionando a la página de pago...')),
      );

      // REDIRECCIÓN DIRECTA A LA PÁGINA DE PAGO
      Navigator.pushReplacement( // Usamos pushReplacement para que el usuario no pueda volver a la página de registro con el botón de atrás.
        context,
        MaterialPageRoute(
          builder: (_) => const PaymentPage(), // Asegúrate de que PaymentPage sea el nombre correcto de tu widget de página de pago
        ),
      );

    } else {
      // Registro fallido, mostrar el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
              const AuthTabs(isLogin: false),
              const SizedBox(height: 24),
              const Text(
                'Hola,\nRegístrate ahora :)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              InputField(
                icon: Icons.person_outline,
                hint: 'Nombres',
                controller: _nameController,
              ),
              const SizedBox(height: 15),
              InputField(
                icon: Icons.person_outline,
                hint: 'Apellidos',
                controller: _lastNameController,
              ),
              const SizedBox(height: 15),
              InputField(
                icon: Icons.email_outlined,
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
              const SizedBox(height: 15),
              InputField(
                icon: Icons.credit_card,
                hint: 'Número de Cédula',
                controller: _cedulaController,
              ),
              const SizedBox(height: 15),
              InputField(
                icon: Icons.phone,
                hint: 'Número de Celular',
                controller: _phoneController,
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.school),
                  hintText: 'Nivel de Educación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                value: _educationController.text.isEmpty
                    ? null
                    : _educationController.text,
                items: ['Primaria', 'Secundaria', 'Bachiller', 'Universitario']
                    .map((level) => DropdownMenuItem(
                  value: level,
                  child: Text(level),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _educationController.text = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _birthDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: 'Fecha de nacimiento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2005),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthDateController.text =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value!;
                      });
                    },
                    activeColor: const Color(0xFFE62054),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text.rich(
                        TextSpan(
                          text: 'He leído y acepto los ',
                          children: [
                            TextSpan(
                              text: 'Términos y Condiciones.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE62054),
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _termsAccepted ? const Color(0xFFE62054) : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _termsAccepted ? _register : null,
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: '¿Ya tienes cuenta? ',
                      children: [
                        TextSpan(
                          text: 'Iniciar sesión',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}