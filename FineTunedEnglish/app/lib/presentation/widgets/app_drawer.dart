import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // <-- IMPORTANTE
import '../services/auth_service.dart';
import '../models/usuarios.dart';
import '../pages/payment_page.dart';
import '../pages/login_page.dart';
import '../pages/certificates_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const drawerBackgroundColor = Color(0xFF213354);
    const buttonColor = Color(0xFF334155);

    return Drawer(
      backgroundColor: drawerBackgroundColor,
      child: Column(
        children: [
          // === Botón de idioma en la parte superior ===
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red, //color del texto
                    ),
                    onPressed: () {
                      context.setLocale(const Locale('es'));
                    },
                    child: const Text("ES"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red, //color del texto
                    ),
                    onPressed: () {
                      context.setLocale(const Locale('en'));
                    },
                    child: const Text("EN"),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerHeader(context),
                _buildDrawerItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  // ===== CORRECCIÓN AQUÍ =====
                  text: 'drawer.recommendations'.tr(),
                  buttonColor: buttonColor,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.info_outline_rounded,
                  // ===== CORRECCIÓN AQUÍ =====
                  text: 'drawer.aboutUs'.tr(),
                  buttonColor: buttonColor,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  // ===== CORRECCIÓN AQUÍ =====
                  text: 'drawer.settings'.tr(),
                  buttonColor: buttonColor,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.account_balance_outlined,
                  // ===== CORRECCIÓN AQUÍ =====
                  text: 'drawer.enrollments'.tr(),
                  buttonColor: buttonColor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.school_outlined,
                  // ===== CORRECCIÓN AQUÍ =====
                  text: 'drawer.generateCertificate'.tr(),
                  buttonColor: buttonColor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CertificatePage()),
                    );
                  },
                ),
              ],
            ),
          ),
          _buildLogoutButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final Usuarios? currentUser = AuthService.currentUser;
    // ===== CORRECCIÓN AQUÍ (Para el saludo "Hola, X") =====
    final String displayName = currentUser != null
        ? 'common.hello'.tr(namedArgs: {'name': currentUser.nombres})
        : 'Invitado';
    final String displayEmail = currentUser?.email ?? 'No autenticado';

    final ImageProvider displayImage =
    const AssetImage('assets/splash/app_icon.png');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: displayImage,
            backgroundColor: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displayEmail,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          tileColor: buttonColor,
          leading: Icon(icon, color: Colors.white, size: 24),
          title: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          await AuthService().signOut();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
                  (Route<dynamic> route) => false,
            );
          }
        },
        icon: const Icon(Icons.exit_to_app_rounded, color: Colors.white),
        // ===== CORRECCIÓN AQUÍ =====
        label: Text(
          'drawer.logout'.tr(),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}