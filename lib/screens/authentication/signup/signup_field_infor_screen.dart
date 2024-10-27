import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_field_infor.dart';
import 'package:flutter/material.dart';

class SignupFieldInforScreen extends StatefulWidget {
  final String email;
  const SignupFieldInforScreen({super.key, required this.email});

  @override
  State<SignupFieldInforScreen> createState() => _SignupFieldInforScreenState();
}

class _SignupFieldInforScreenState extends State<SignupFieldInforScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bổ sung thông tin',
          style: TextStyle(color: Colors.white),
        ),
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
      ),
      body: SignupFieldInfor(email: widget.email),
    );
  }
}
