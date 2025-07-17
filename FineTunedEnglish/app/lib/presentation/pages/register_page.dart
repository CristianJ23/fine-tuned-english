import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/auth_tabs.dart';
import 'login_page.dart';
import 'payment_page.dart'; // 👈 Asegúrate de que la ruta esté correcta

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  bool _termsAccepted = false;

  void _register() {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe aceptar los términos y condiciones')),
      );
      return;
    }

    if (_nameController.text.trim().isEmpty ||
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

    // ✅ Si todo está correcto, ir a la pantalla de pago
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PaymentPage()),
    );
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
                hint: 'Nombre',
                controller: _nameController,
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

              // Dropdown de educación
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

              // Fecha de nacimiento
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
