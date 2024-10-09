import 'package:chat_app_mobile_fe/services/auth_services.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/forgot_password/forgot_password_form.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyForgotPasswordScreen();
  }
}

class _MyForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final _emailcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final AuthServices _authServices =
      AuthServices(); // Tạo instance của AuthServices

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
        child: ForgotPasswordForm(
          emailController: _emailcontroller,
          formKey: _formkey,
          onSubmit: (email) {
            _authServices.sendVerifycationLink(
                context, email); // Truyền hàm vào đây
          },
        ),
      ),
    );
  }
}
