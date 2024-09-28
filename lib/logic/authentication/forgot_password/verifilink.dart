// Hàm này thực hiện việc gửi link đặt lại mật khẩu
import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> sendVerificationLink(BuildContext context, String email) async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email không tồn tại')),
      );
      return;
    }
    // Gửi email đặt lại mật khẩu
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi link về mail của bạn!')),
    );

    // Điều hướng về trang đăng nhập sau khi gửi thành công
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi khi gửi mã: $e')),
    );
  }
}
