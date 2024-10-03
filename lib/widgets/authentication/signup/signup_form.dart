import 'package:chat_app_mobile_fe/helpers/validating_helper.dart';
import 'package:chat_app_mobile_fe/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'signup_button.dart';
import 'signup_textfield.dart';
import 'login_link.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _controllerUsername = TextEditingController();

  bool _obscureText = true;
  bool _obscureTextCF = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            SignupTextField(
              controller: _controllerUsername,
              label: 'Tên đăng nhập',
              hint: 'Nhập email',
              obscureText: false,
              validator: ValidatingHelper().validateEmail,
            ),
            const SizedBox(height: 20),
            SignupTextField(
              controller: _passwordController,
              label: 'Mật khẩu',
              hint: 'Nhập mật khẩu',
              obscureText: _obscureText,
              validator: ValidatingHelper().validatePassword,
              toggleObscureText: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            const SizedBox(height: 20),
            SignupTextField(
              controller: _confirmPasswordController,
              label: 'Nhập lại mật khẩu',
              hint: 'Nhập lại mật khẩu',
              obscureText: _obscureTextCF,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập lại mật khẩu!';
                }
                if (value != _passwordController.text) {
                  return 'Mật khẩu không khớp!';
                }
                return null;
              },
              toggleObscureText: () {
                setState(() {
                  _obscureTextCF = !_obscureTextCF;
                });
              },
            ),
            const SizedBox(height: 30),
            SignupButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  AuthServices().registerUser(
                    _controllerUsername.text,
                    _passwordController.text,
                    context,
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            // Logo
            Image.asset(
              'assets/img/logo/logo_2.png',
              height: 150,
            ),
            LoginLink(), // Link đến màn hình đăng nhập
          ],
        ),
      ),
    );
  }
}
