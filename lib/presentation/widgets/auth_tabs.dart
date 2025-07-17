import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

class AuthTabs extends StatelessWidget {
  final bool isLogin;

  const AuthTabs({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (!isLogin) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
          },
          child: Column(
            children: [
              Text(
                "Login",
                style: TextStyle(
                  color: isLogin ? const Color(0xFFE62054) : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isLogin)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 2,
                  width: 40,
                  color: const Color(0xFFE62054),
                ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            if (isLogin) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
          },
          child: Column(
            children: [
              Text(
                "Register",
                style: TextStyle(
                  color: !isLogin ? const Color(0xFFE62054) : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!isLogin)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 2,
                  width: 40,
                  color: const Color(0xFFE62054),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
