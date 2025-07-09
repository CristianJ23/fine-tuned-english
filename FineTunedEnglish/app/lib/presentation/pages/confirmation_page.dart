import 'package:flutter/material.dart';
import 'main_screen.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(), 
              const Text(
                'Listo Realizado el Pago',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF213354),
                ),
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.school,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
              // ----- FIN DEL CAMBIO -----

              const SizedBox(height: 30),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Finalizar',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}