import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:flutter/material.dart';

class LoginLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: const Text(
        'Đã có tài khoản? Đăng nhập',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
