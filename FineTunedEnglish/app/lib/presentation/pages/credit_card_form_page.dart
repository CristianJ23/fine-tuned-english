// lib/presentation/pages/credit_card_form_page.dart (CÓDIGO COMPLETO Y SIN OMISIONES)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ----- CLASES DE FORMATEO PERSONALIZADAS -----
// Estas clases ayudan a mejorar la experiencia del usuario al introducir los datos.

/// Formatea el número de la tarjeta añadiendo espacios cada 4 dígitos.
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String enteredData = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < enteredData.length; i++) {
      buffer.write(enteredData[i]);
      if ((i + 1) % 4 == 0 && i != enteredData.length - 1) {
        buffer.write(' ');
      }
    }
    String result = buffer.toString();
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

/// Convierte el texto introducido a mayúsculas.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}


// --- WIDGET PRINCIPAL ---

class CreditCardFormPage extends StatefulWidget {
  // Recibe los datos del horario para mostrar el costo total.
  final Map<String, dynamic> scheduleData;
  
  const CreditCardFormPage({super.key, required this.scheduleData});

  @override
  State<CreditCardFormPage> createState() => _CreditCardFormPageState();
}

class _CreditCardFormPageState extends State<CreditCardFormPage> {
  final _formKey = GlobalKey<FormState>();

  /// Valida el formulario y, si es correcto, regresa a la página anterior
  /// enviando 'true' para indicar que los datos se han "guardado".
  void _saveCardAndReturn() {
    // Si el formulario no es válido, se detiene y muestra los errores.
    if (!_formKey.currentState!.validate()) {
      return; 
    }
    
    // Si el formulario ES válido, cierra esta página y devuelve 'true'.
    Navigator.of(context).pop(true); 
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCreditCardPreview(),
              const SizedBox(height: 40),
              _buildCardInfoForm(),
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
                onPressed: _saveCardAndReturn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF213354),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Guardar Tarjeta", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget que muestra una vista previa estática de una tarjeta de crédito.
  Widget _buildCreditCardPreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF213354), Color(0xFF0D1E3A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("**** **** **** ****", style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Nombre", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text("Titular de la Tarjeta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ], 
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                   Text("Expira", style: TextStyle(color: Colors.white70, fontSize: 12)),
                   Text("00/00", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Widget que construye los campos de texto del formulario de la tarjeta.
  Widget _buildCardInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Número de tarjeta", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "1234 5678 9023 4567", prefixIcon: Icon(Icons.credit_card)),
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(19), // 16 dígitos + 3 espacios
            CardNumberInputFormatter(),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) return "Campo requerido";
            final number = value.replaceAll(' ', '');
            if (number.length < 16) return "Número de tarjeta incompleto";
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Text("Titular de la Tarjeta", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "NOMBRE APELLIDO", prefixIcon: Icon(Icons.person)),
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
           validator: (value) => (value == null || value.isEmpty) ? "Campo requerido" : null,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Exp. Año", hintText: "YYYY"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                validator: (value) {
                   if (value == null || value.isEmpty) return "Requerido";
                   if (value.length < 4) return "Inválido";
                   final currentYear = DateTime.now().year;
                   if (int.parse(value) < currentYear) return "Expirada";
                   return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Exp. Mes", hintText: "MM"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                validator: (value) {
                   if (value == null || value.isEmpty) return "Requerido";
                   final month = int.tryParse(value);
                   if (month == null || month < 1 || month > 12) return "Inválido";
                   return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "CVV", hintText: "***"),
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                validator: (value) => (value == null || value.length < 3) ? "Inválido" : null,
              ),
            )
          ],
        )
      ],
    );
  }
}