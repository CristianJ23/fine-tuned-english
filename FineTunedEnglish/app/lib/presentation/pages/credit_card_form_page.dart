// lib/presentation/pages/credit_card_form_page.dart (CÓDIGO COMPLETO Y SIN OMISIONES)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart'; // Importar el paquete principal
import 'package:flutter_credit_card/credit_card_brand.dart'; // Importar CreditCardBrand explícitamente

// --- WIDGET PRINCIPAL ---

class CreditCardFormPage extends StatefulWidget {
  // Recibe los datos del horario para mostrar el costo total.
  final Map<String, dynamic> scheduleData;

  const CreditCardFormPage({super.key, required this.scheduleData});

  @override
  State<CreditCardFormPage> createState() => _CreditCardFormPageState();
}

class _CreditCardFormPageState extends State<CreditCardFormPage> {
  // Clave global para el formulario de la tarjeta de crédito
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Variables de estado para los datos de la tarjeta
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false; // Para controlar la vista trasera de la tarjeta

  /// Valida el formulario y, si es correcto, simula un pago mostrando un diálogo.
  void _processPayment() {
    // Si el formulario no es válido, se detiene y muestra los errores.
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Si el formulario ES válido, simula el pago y muestra un diálogo.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pago Simulado"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("¡El pago ha sido procesado exitosamente!"),
            const SizedBox(height: 10),
            Text("Número de Tarjeta: $cardNumber"),
            Text("Fecha de Expiración: $expiryDate"),
            Text("Titular: $cardHolderName"),
            Text("CVV: $cvvCode"),
            Text("Total Pagado: \$${widget.scheduleData['cost']?.toStringAsFixed(2) ?? '0.00'}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
              Navigator.of(context).pop(true); // Regresa a la página anterior indicando éxito
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Información de pago", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Vista previa de la tarjeta de crédito (actualiza con los datos)
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused, // Muestra la parte trasera si el CVV está enfocado
              cardBgColor: const Color(0xFF213354), // Color de fondo de la tarjeta
              obscureCardNumber: false, // Puedes cambiar a true para ocultar el número
              obscureCardCvv: false,     // Puedes cambiar a true para ocultar el CVV
              isHolderNameVisible: true, // Muestra el nombre del titular
              onCreditCardWidgetChange: (CreditCardBrand brand) {
                // Callback para cuando cambia la marca de la tarjeta (opcional)
              },
            ),
            const SizedBox(height: 40),
            // Formulario de entrada de datos de la tarjeta
            CreditCardForm(
              formKey: formKey, // Asigna la clave global al formulario
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              onCreditCardModelChange: (CreditCardModel data) {
                // Callback que se ejecuta cada vez que los datos del formulario cambian
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                  isCvvFocused = data.isCvvFocused;
                });
              },
              themeColor: const Color(0xFF213354), // Color principal del tema del formulario
              cardNumberDecoration: const InputDecoration(
                labelText: 'Número de Tarjeta',
                hintText: 'XXXX XXXX XXXX XXXX',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              expiryDateDecoration: const InputDecoration(
                labelText: 'Fecha de Expiración',
                hintText: 'MM/YY',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              cvvCodeDecoration: const InputDecoration(
                labelText: 'CVV',
                hintText: 'XXX',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              cardHolderDecoration: const InputDecoration(
                labelText: 'Nombre del Titular',
                hintText: 'NOMBRE APELLIDO',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                Text("\$${widget.scheduleData['cost']?.toStringAsFixed(2) ?? '0.00'}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processPayment, // Llama a la función de simulación de pago
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF213354),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Realizar Pago", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
