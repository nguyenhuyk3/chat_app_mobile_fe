import 'package:chat_app_mobile_fe/helpers/validating_helper.dart';
import 'package:chat_app_mobile_fe/services/auth_services.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/login/sign_up_link.dart';
import 'package:flutter/material.dart';
import 'login_textfield.dart';
import 'login_button.dart';
import 'package:chat_app_mobile_fe/screens/authentication/forgot_password/forgotpassword_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _userEmailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  double _paddingTop = 0;
  bool _obscureText = true;
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(
        () {
          _paddingTop = 200;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 800),
      padding: EdgeInsets.only(top: _paddingTop),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Colors.white,
        ),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/logo/logo_2.png',
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  LoginTextField(
                    controller: _userEmailcontroller,
                    label: 'Tên đăng nhập',
                    hint: 'Nhập email',
                    validator: ValidatingHelper().validateEmail,
                  ),
                  const SizedBox(height: 20),
                  LoginTextField(
                    controller: _passwordcontroller,
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
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  LoginButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        AuthServices().login(context, _userEmailcontroller.text,
                            _passwordcontroller.text);
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                  const SignUpLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
