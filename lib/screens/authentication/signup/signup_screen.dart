import 'package:chat_app_mobile_fe/services/auth_services.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_background.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/signup/signup_form.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureText = true;
  bool _obscureTextCF = true;
  double _paddingBottom = 0;
  // Bắt đầu với giá trị lớn để Container không thấy ban đầu
  double _paddingTop = 200;
  // Thêm GlobalKey để quản lý trạng thái Form
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _controllerUserEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Delay để tạo hiệu ứng trượt
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _paddingBottom = 200;
        // Sau 300ms, đặt padding về giá trị mong muốn
        _paddingTop = 0;
      });
    });
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      await AuthServices().registerUser(
          _controllerUserEmail.text, _passwordController.text, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SignupBackground(),
          SignupForm(),
        ],
      ),
    );
  }
}
