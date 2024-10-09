import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_verify_code_form.dart';
import 'package:flutter/material.dart';

class SignupVerifyCodeScreen extends StatefulWidget {
  final String email; // Khai báo biến email

  const SignupVerifyCodeScreen({super.key, required this.email});

  @override
  State<SignupVerifyCodeScreen> createState() => _SignupVerifyCodeScreenState();
}

class _SignupVerifyCodeScreenState extends State<SignupVerifyCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xE80A2405),
                Color(0xE8181819),
                Color(0xE80E1332),
              ],
            ),
          ),
        ),
        title: const Text(
          'Bước 2',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
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
        child: SignupVerifyCodeForm(
          email: widget.email,
        ),
      ),
    );
  }
}
