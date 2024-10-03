import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_background.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_form.dart';
import 'package:flutter/material.dart'; // import logic cho chức năng đăng ký
import '../login/login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SignupBackground(),
          SignupForm(), // Sử dụng widget SignupForm
        ],
      ),
    );
  }
}
