// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_brand.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: PaymentPage(),
//     );
//   }
// }
//
// class PaymentPage extends StatefulWidget {
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;
//
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   void simulatePayment() {
//     if (formKey.currentState!.validate()) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Pago simulado"),
//           content: const Text("¡El pago ha sido procesado exitosamente!"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Simulador de Pago"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             CreditCardWidget(
//               cardNumber: cardNumber,
//               expiryDate: expiryDate,
//               cardHolderName: cardHolderName,
//               cvvCode: cvvCode,
//               showBackView: isCvvFocused,
//               cardBgColor: Colors.deepPurple,
//               obscureCardNumber: false,
//               obscureCardCvv: false,
//               isHolderNameVisible: true,
//               onCreditCardWidgetChange: (CreditCardBrand brand) {},
//             ),
//             CreditCardForm(
//               formKey: formKey,
//               cardNumber: cardNumber,
//               expiryDate: expiryDate,
//               cardHolderName: cardHolderName,
//               cvvCode: cvvCode,
//               onCreditCardModelChange: (CreditCardModel data) {
//                 setState(() {
//                   cardNumber = data.cardNumber;
//                   expiryDate = data.expiryDate;
//                   cardHolderName = data.cardHolderName;
//                   cvvCode = data.cvvCode;
//                   isCvvFocused = data.isCvvFocused;
//                 });
//               },
//               themeColor: Colors.deepPurple,
//               cardNumberDecoration: InputDecoration(
//                 labelText: 'Número de Tarjeta',
//                 border: OutlineInputBorder(),
//               ),
//               expiryDateDecoration: InputDecoration(
//                 labelText: 'Expira',
//                 border: OutlineInputBorder(),
//               ),
//               cvvCodeDecoration: InputDecoration(
//                 labelText: 'CVV',
//                 border: OutlineInputBorder(),
//               ),
//               cardHolderDecoration: InputDecoration(
//                 labelText: 'Titular',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: simulatePayment,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//               ),
//               child: const Text(
//                 'Simular Pago',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
