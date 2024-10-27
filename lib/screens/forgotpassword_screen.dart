import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  //Hàm tạo mã 6 ký tự ngẫu nhiên

  Future<void> _sendVerificationLink() async {
    //.trim để loại bỏ các khoảng trắng ở đầu và cuối của chuỗi để tránh lỗi cho người dùng khi nhập dư khoảng trắng
    String email = _emailcontroller.text.trim();

    // Kiểm tra định dạng email
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email không hợp lệ')),
      );
      return;
    }

    try {
      // Truy vấn Firestore để kiểm tra sự tồn tại của email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isEmpty) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email không tồn tại')),
        );
        return;
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi link về mail của bạn!')),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi gửi mã: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xE80A2405),
            Color(0xE8181819),
            Color(0xE80E1332),
          ])),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Form(
            key: _formkey,
            child: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 80, left: 20),
                  child: Text(
                    'Quên mật khẩu',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 120, left: 20),
                  child: Text(
                    'Nhập địa chỉ email của bạn.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(top: 165, left: 20, right: 20),
                    child: TextFormField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.8)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      style: const TextStyle(color: Colors.white),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 240, left: 20, right: 20),
                  child: Container(
                    height: 40,
                    width: 380,
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                      onPressed: _sendVerificationLink,
                      child: const Text(
                        'TIẾP TỤC',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
