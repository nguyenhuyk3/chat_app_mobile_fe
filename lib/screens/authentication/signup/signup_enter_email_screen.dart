import 'package:chat_app_mobile_fe/services/sendmaill_service.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/enter_email_form.dart';
import 'package:flutter/material.dart';

class SignupEnterEmailScreen extends StatefulWidget {
  const SignupEnterEmailScreen({super.key});

  @override
  State<SignupEnterEmailScreen> createState() => _SignupEnterEmailScreenState();
}

class _SignupEnterEmailScreenState extends State<SignupEnterEmailScreen> {
  final _emailcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final SendMailService _mailService = SendMailService();
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
        title: const Text(
          'Bước 1',
          style: TextStyle(color: Colors.white),
        ),
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
        child: EnterEmailForm(
          onSubmit: (email) {
            _mailService.sendCodeByMail(context, email);
          },
          emailController: _emailcontroller,
          formKey: _formkey,
        ),
      ),
    );
  }
}
