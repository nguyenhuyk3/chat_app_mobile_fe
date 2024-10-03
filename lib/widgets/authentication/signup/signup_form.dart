import 'package:chat_app_mobile_fe/logic/authentication/signup/signup_logic.dart';
import 'package:flutter/material.dart';
import 'signup_button.dart';
import 'signup_textfield.dart';
import 'login_link.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _controllerUsername = TextEditingController();
  final _controllerFullname = TextEditingController();
  final SignupLogic _signupLogic = SignupLogic();

  bool _obscureText = true;
  bool _obscureTextCF = true;
  double _paddingBottom = 0;
  double _paddingTop =
      200; // Bắt đầu với giá trị lớn để Container không thấy ban đầu
  @override
  void initState() {
    super.initState();
    // Delay để tạo hiệu ứng trượt
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _paddingBottom = 200;
        _paddingTop = 0; // Sau 300ms, đặt padding về giá trị mong muốn
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: _paddingBottom),
      duration: const Duration(milliseconds: 800),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          color: Colors.white,
        ),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 800),
            padding: EdgeInsets.only(left: 18, right: 18, top: _paddingTop),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  SignupTextField(
                    controller: _controllerFullname,
                    label: 'Họ và tên',
                    hint: 'Nhập họ và tên',
                    obscureText: false,
                    validator: null,
                  ),
                  const SizedBox(height: 20),
                  SignupTextField(
                    controller: _controllerUsername,
                    label: 'Tên đăng nhập',
                    hint: 'Nhập email',
                    obscureText: false,
                    validator: _signupLogic.validateEmail,
                  ),
                  const SizedBox(height: 20),
                  SignupTextField(
                    controller: _passwordController,
                    label: 'Mật khẩu',
                    hint: 'Nhập mật khẩu',
                    obscureText: _obscureText,
                    validator: _signupLogic.validatePassword,
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
                        _signupLogic.registerUser(
                          _controllerFullname.text,
                          _controllerUsername.text,
                          _passwordController.text,
                          context,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  // Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/img/logo/logo_2.png',
                        height: 150,
                      ),
                      LoginLink(),
                    ],
                  )
                  // Link đến màn hình đăng nhập
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
