import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignupEnterEmailScreen extends StatefulWidget {
  const SignupEnterEmailScreen({super.key});

  @override
  State<SignupEnterEmailScreen> createState() => _SignupEnterEmailScreenState();
}

class _SignupEnterEmailScreenState extends State<SignupEnterEmailScreen> {
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xE80A2405),
          Color(0xE8181819),
          Color(0xE80E1332),
        ])),
      ),
    );
  }
}
