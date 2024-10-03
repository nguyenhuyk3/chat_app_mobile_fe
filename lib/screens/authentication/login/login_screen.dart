import 'package:chat_app_mobile_fe/widgets/authentication/login/login_background.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/login/login_form.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          LoginBackground(),
          LoginForm(),
        ],
      ),
    );
  }
}
