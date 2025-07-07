import 'package:flutter/material.dart';

class HeaderMenu extends StatelessWidget {
  final bool showBackButton;

  const HeaderMenu({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF213354),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Botón atrás o botón menú
              if (showBackButton)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                )
              else
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: const Icon(Icons.menu, color: Colors.white),
                ),
            ],
          ),
          const Icon(Icons.notifications, color: Colors.white),
        ],
      ),
    );
  }
}
