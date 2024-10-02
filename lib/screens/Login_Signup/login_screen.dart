import 'dart:convert';

import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/screens/authentication/forgot_password/forgotpassword_screen.dart';
import 'package:chat_app_mobile_fe/screens/authentication/signup/signup_screen.dart';
import 'package:chat_app_mobile_fe/screens/home.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _usercontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final bool _isValid = false;
  String errorMessage = '';
  double _paddingTop =
      0; // Bắt đầu với giá trị lớn để Container không thấy ban đầu
  // Hàm kiểm tra ký tự hợp lệ (chỉ chấp nhận chữ cái, số và không có ký tự đặc biệt)
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // Delay để tạo hiệu ứng trượt
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        setState(
          () {
            _paddingTop = 200; // Sau 300ms, đặt padding về giá trị mong muốn
          },
        );
      },
    );
  }

  void _login() async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _usercontroller.text, password: _passwordcontroller.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thành công!')),
        );
        SharedPreferencesHelper.saveLogin();
        
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          errorMessage = 'Không tìm thấy tài khoản!';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Mật khẩu không đúng!';
        } else {
          errorMessage = 'Đăng nhập thất bại!';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  // void _saveUser({required dynamic jsonData}) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();

  //   print(jsonData);

  //   await pref.setString('user', jsonData);
  // }

  // void _getUserByEmail({required String email}) async {
  //   String url = "http://192.168.1.39:8080/users/get_user?email=$email";
  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);

  //       _saveUser(jsonData: jsonData);
  //     }
  //   } catch (e) {
  //     print("Có lỗi xảy ra: $e");
  //   }
  // }

  // Validator cho email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  // Validator cho mật khẩu
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    } else if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xE80A2405),
              Color(0xE8181819),
              Color(0xE80E1332),
            ])),
            padding: const EdgeInsets.only(top: 60, left: 20),
            child: const Text(
              'Chào\nĐăng Nhập!',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          AnimatedPadding(
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
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6EBF1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12, // Màu của bóng đổ
                                offset: Offset(4, 4), // Vị trí bóng đổ
                                blurRadius: 15, // Độ mờ của bóng
                              ),
                              BoxShadow(
                                color: Colors.white, // Màu highlight phía trên
                                offset: Offset(-4, -4),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _usercontroller,
                            validator: _validateEmail,
                            decoration: const InputDecoration(
                              hintText: 'Nhập email',
                              hintStyle: TextStyle(fontWeight: FontWeight.w400),
                              border:
                                  InputBorder.none, // Bỏ đường viền mặc định
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              label: Text(
                                'Tên đăng nhập',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6EBF1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12, // Màu của bóng đổ
                                offset: Offset(4, 4), // Vị trí bóng đổ
                                blurRadius: 15, // Độ mờ của bóng
                              ),
                              BoxShadow(
                                color: Colors.white, // Màu highlight phía trên
                                offset: Offset(-4, -4),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _passwordcontroller,
                            validator: _validatePassword,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              label: const Text(
                                'Mật khẩu',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w400),
                              border:
                                  InputBorder.none, // Bỏ đường viền mặc định
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                            ),
                            obscureText: _obscureText,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()));
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
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xE80E1332),
                                Color(0xE8181819),
                                Color(0xE80A2405),
                              ],
                            ),
                          ),
                          child: TextButton(
                            onPressed: _login,
                            child: const Text(
                              'ĐĂNG NHẬP',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Bạn chưa có tài khoản?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignupScreen()));
                                },
                                child: const Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
