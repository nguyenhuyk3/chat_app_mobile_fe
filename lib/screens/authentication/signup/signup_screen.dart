import 'dart:convert';

import 'package:chat_app_mobile_fe/models/enum/genre.dart';
import 'package:chat_app_mobile_fe/models/information.dart';
import 'package:chat_app_mobile_fe/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

String hashPassword(String password) {
  // Chuyển đổi mật khẩu thành mảng byte
  final bytes = utf8.encode(password);

  // Tạo hash SHA-256
  final digest = sha256.convert(bytes);

  // Trả về chuỗi hash
  return digest.toString();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureText = true;
  bool _obscureTextCF = true;
  double _paddingBottom = 0;
  double _paddingTop =
      200; // Bắt đầu với giá trị lớn để Container không thấy ban đầu
  final _formKey =
      GlobalKey<FormState>(); // Thêm GlobalKey để quản lý trạng thái Form
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final _auth = FirebaseAuth.instance;
  //Biến để chứa lỗi

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

  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Thực hiện hành động đăng ký ở đây nếu không có lỗi
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: _controllerUsername.text,
                password: _passwordController.text);
        //Khởi tạo đối tượng AppUser
        final user = AppUser(
          phoneNumber: '', // Sử dụng số điện thoại hoặc email
          email: _controllerUsername.text, // Mật khẩu đã mã hóa
          information: Infomation(
            fullName: '', // Cần cập nhật giá trị nếu có
            dateOfBirth: DateTime.now().toString(),
            genre: Genre.male, // Thay đổi theo yêu cầu
          ),
          state: true, // Trạng thái mặc định
          friends: [],
          chatRooms: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        // Lưu thông tin người dùng vào Cloud Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.id).set({
          'phoneNumber': user.phoneNumber,
          'email': user.email,
          'information': {
            'fullName': user.information.fullName,
            'dateOfBirth': user.information.dateOfBirth,
            'genre':
                user.information.genre.index, // Lưu dưới dạng số hoặc chuỗi
          },
          'state': user.state,
          'friends': user.friends,
          'chatRooms': user.chatRooms,
          'createdAt': user.createdAt,
          'updatedAt': user.updatedAt,
        });
        // Điều hướng tới trang đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công')),
        );

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email đã được sử dụng!';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Email không hợp lệ!';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

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
              ]),
            ),
            padding: const EdgeInsets.only(bottom: 60, right: 20),
            child: const Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Chào\nĐăng Ký!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AnimatedPadding(
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
                  padding:
                      EdgeInsets.only(left: 18, right: 18, top: _paddingTop),
                  child: Form(
                    // Sử dụng widget Form
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        // Input tên đăng nhập
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE6EBF1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(4, 4),
                                blurRadius: 15,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4, -4),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _controllerUsername,
                            validator: _validateEmail,
                            decoration: const InputDecoration(
                              hintText: 'Nhập email',
                              hintStyle: TextStyle(fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              label: Text(
                                'Tên đăng nhập',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Input mật khẩu
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE6EBF1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(4, 4),
                                blurRadius: 15,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4, -4),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: TextFormField(
                              controller: _passwordController,
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
                                    fontSize: 18,
                                  ),
                                ),
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                              ),
                              obscureText: _obscureText,
                              validator: _validatePassword),
                        ),

                        const SizedBox(height: 20),

                        // Input nhập lại mật khẩu
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE6EBF1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(4, 4),
                                blurRadius: 15,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4, -4),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureTextCF = !_obscureTextCF;
                                  });
                                },
                                icon: Icon(
                                  _obscureTextCF
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              label: const Text(
                                'Nhập lại mật khẩu',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                            ),
                            obscureText: _obscureTextCF,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập lại mật khẩu!';
                              }
                              if (value != _passwordController.text) {
                                return 'Mật khẩu không khớp!';
                              }
                              return null; // Nếu không có lỗi, trả về null
                            },
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Nút Đăng Ký
                        Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color(0xE80E1332),
                              Color(0xE8181819),
                              Color(0xE80A2405),
                            ]),
                          ),
                          child: TextButton(
                            onPressed:
                                _register, // Gọi hàm kiểm tra khi nhấn nút
                            child: const Text(
                              'ĐĂNG KÝ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Logo
                        Image.asset(
                          'assets/img/logo/logo_2.png',
                          height: 150,
                        ),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Bạn đã có tài khoản!'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
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
