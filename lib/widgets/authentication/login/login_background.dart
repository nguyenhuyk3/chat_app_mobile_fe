import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xE80A2405),
        Color(0xE8181819),
        Color(0xE80E1332),
      ])),
      padding: const EdgeInsets.only(top: 60, left: 20),
      child: const Text(
        'Chào\nĐăng Nhập!',
        style: TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
