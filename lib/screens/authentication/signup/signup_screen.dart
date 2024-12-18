import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_background.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_form.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  final String email;

  const SignupScreen({super.key, required this.email});

  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen> {
  final bool _obscureText = true;
  final bool _obscureTextCF = true;
  double _paddingBottom = 0;
  double _paddingTop = 200;

  @override
  void initState() {
    super.initState();
    // Delay to create sliding effect
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        setState(
          () {
            _paddingBottom = 200;
            // After 300ms, set padding to expected value
            _paddingTop = 0;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const SignupBackground(),
          SignupForm(
            email: widget.email,
          ),
        ],
      ),
    );
  }
}
