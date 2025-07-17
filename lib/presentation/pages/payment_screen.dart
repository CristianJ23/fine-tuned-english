import 'package:flutter/material.dart';
import '../widgets/payment_methods_widget.dart'; // Import the new widget file

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  bool _isPaymentEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Pago',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.black),
                onPressed: () {
                  // Handle home button press
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estas a un solo paso de ser parte de nosotros',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            Text(
              'Completa el siguiente paso:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle "Datos del Representante" button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Datos del Representante',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFC107), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFFFC107),
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Selecciona un Curso!',
                          style: TextStyle(
                            color: const Color(0xFFFFC107),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Debe seleccionar un horario para la inscripcion.',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle "Elegir un Horario" button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Elegir un Horario',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Método de Pago',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),

            PaymentMethodCard(
              title: 'Tarjeta de Crédito/Débito',
              subtitle: 'Visa, Mastercard',
              value: 'credit_debit',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                  _isPaymentEnabled = (_selectedPaymentMethod != null);
                });
              },
            ),
            const SizedBox(height: 15),
            PaymentMethodCard(
              title: 'Transferencia Bancaria',
              subtitle: 'Pichincha, Banco de Loja',
              value: 'bank_transfer',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                  _isPaymentEnabled = (_selectedPaymentMethod != null);
                });
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _isPaymentEnabled
                    ? () {
                  print('Realizar Pago with: $_selectedPaymentMethod');
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPaymentEnabled
                      ? const Color(0xFFF48FB1)
                      : const Color(0xFFE0E0E0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Realizar Pago - \$0.00',
                  style: TextStyle(
                    color: _isPaymentEnabled
                        ? Colors.white
                        : Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: const Color(0xFFEEEEEE),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Tienes alguna duda?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Ponte en contacto con nosotros: +593 912 423 3132',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFF48FB1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
