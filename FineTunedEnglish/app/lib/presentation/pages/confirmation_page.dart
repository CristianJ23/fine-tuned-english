import 'package:flutter/material.dart';
import '../models/inscription.dart';
import '../services/inscription_service.dart';
import 'main_screen.dart';

class ConfirmationPage extends StatelessWidget {
  final Inscription inscription;

  // 🔧 Quitamos const del constructor porque tenemos un campo no constante abajo
  ConfirmationPage({super.key, required this.inscription});

  // Instancia del servicio de inscripción
  final InscriptionService _inscriptionService = InscriptionService();

  Future<void> _saveInscription(BuildContext context) async {
    try {
      await _inscriptionService.guardarInscripcion(inscription);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscripción registrada con éxito! 🎉')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar la inscripción: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveInscription(context);
    });

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
                '¡Pago Realizado con Éxito!',
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
                    Icons.check_circle_outline,
                    size: 100,
                    color: Colors.green,
                  );
                },
              ),
              const SizedBox(height: 30),
              const Text(
                '¡Felicidades! Tu inscripción ha sido procesada correctamente. Te enviaremos un correo con los detalles.',
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
