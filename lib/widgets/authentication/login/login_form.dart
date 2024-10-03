import 'package:chat_app_mobile_fe/widgets/authentication/login/sign_up_link.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_mobile_fe/logic/authentication/login/login_logic.dart';
import 'login_textfield.dart';
import 'login_button.dart';
import 'package:chat_app_mobile_fe/screens/authentication/forgot_password/forgotpassword_screen.dart';
import 'package:chat_app_mobile_fe/screens/authentication/signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usercontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final LoginLogic loginLogic = LoginLogic();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  double _paddingTop = 0;
  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _paddingTop = 200;
      });
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
                    controller: _usercontroller,
                    label: 'Tên đăng nhập',
                    hint: 'Nhập email',
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 20),
                  LoginTextField(
                    controller: _passwordcontroller,
                    label: 'Mật khẩu',
                    hint: 'Nhập mật khẩu',
                    obscureText: _obscureText,
                    validator: _validatePassword,
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
                            builder: (context) => ForgotPasswordScreen(),
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
                        loginLogic.login(
                          context,
                          _usercontroller.text,
                          _passwordcontroller.text,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                  SignUpLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    } else if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }
}
