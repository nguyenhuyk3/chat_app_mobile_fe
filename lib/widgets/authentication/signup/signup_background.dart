import 'package:flutter/material.dart';

class SignupBackground extends StatelessWidget {
  const SignupBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xE80A2405),
            Color(0xE8181819),
            Color(0xE80E1332),
          ],
        ),
      ),
      padding: const EdgeInsets.only(bottom: 60, right: 20),
      child: const Align(
        alignment: Alignment.bottomRight,
        child: Text(
          'Chào\nĐăng Ký!',
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
