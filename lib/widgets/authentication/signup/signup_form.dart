import 'package:chat_app_mobile_fe/utils/validating.util.dart';
import 'package:chat_app_mobile_fe/services/auth.services.dart';
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
  final _userNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureTextCF = true;
  double _paddingBottom = 0;
  // Bắt đầu với giá trị lớn để Container không thấy ban đầu
  double _paddingTop = 200;

  @override
  void initState() {
    super.initState();
    // Delay để tạo hiệu ứng trượt
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        setState(
          () {
            _paddingBottom = 200;
            // Sau 300ms, đặt padding về giá trị mong muốn
            _paddingTop = 0;
          },
        );
      },
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      await AuthServices().registerUser(_userNameController.text,
          _passwordController.text, _fullNameController.text, context);
    }
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
                    controller: _fullNameController,
                    label: 'Họ và tên',
                    hint: 'Nhập họ và tên',
                    obscureText: false,
                    validator: null,
                  ),
                  const SizedBox(height: 20),
                  SignupTextField(
                    controller: _userNameController,
                    label: 'Tên đăng nhập',
                    hint: 'Nhập email',
                    obscureText: false,
                    validator: ValidatingUtil().validateEmail,
                  ),
                  const SizedBox(height: 20),
                  SignupTextField(
                    controller: _passwordController,
                    label: 'Mật khẩu',
                    hint: 'Nhập mật khẩu',
                    obscureText: _obscureText,
                    validator: ValidatingUtil().validatePassword,
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
                  SignupButton(onPressed: _register),
                  const SizedBox(height: 10),
                  // Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/img/logo/logo_2.png',
                        height: 150,
                      ),
                      const LoginLink(),
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
