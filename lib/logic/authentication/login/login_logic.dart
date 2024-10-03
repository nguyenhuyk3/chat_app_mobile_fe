import 'package:chat_app_mobile_fe/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công!')),
      );

      _saveLogin();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const Home())); // Sử dụng named route
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Không tìm thấy tài khoản!';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Mật khẩu không đúng!';
      } else {
        errorMessage = 'Email hoặc mật khẩu không đúng!';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _saveLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('isLogin', true);
  }
}
