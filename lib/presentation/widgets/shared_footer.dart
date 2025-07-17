import 'package:flutter/material.dart';

class SharedFooter extends StatelessWidget {
  const SharedFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      color: Colors.grey[100],
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.black54, fontSize: 14),
          children: [
            TextSpan(text: '¿Tienes alguna duda?\n'),
            TextSpan(
              text: 'Ponte en contacto con nosotros: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '+593 912 423 3132',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}