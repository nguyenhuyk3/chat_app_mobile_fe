import 'dart:convert';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/collections/user.collec.dart';
import 'package:chat_app_mobile_fe/models/information.dart';
import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:chat_app_mobile_fe/screens/authentication/signup/signup_field_infor_screen.dart';
import 'package:chat_app_mobile_fe/screens/authentication/signup/signup_screen.dart';
import 'package:chat_app_mobile_fe/screens/home/home.screen.dart';
import 'package:chat_app_mobile_fe/services/user.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registerUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential _ = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = AppUser(
        phoneNumber: '',
        email: email,
        information: Infomation(
          fullName: "",
          dateOfBirth: DateTime.now().toString(),
          genre: "Nam",
        ),
        state: true,
        sendingInvitationBoxId: "",
        receivingInvitationBoxId: "",
        friends: [],
        chatRooms: [],
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _db.collection('users').add(user.toJson());

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công')),
      );

      // The user will not be able to return to the previous screen by pressing the back button
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => SignupFieldInforScreen(email: email),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email đã được sử dụng!';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Email không hợp lệ!';
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> verifyCode(
      String email, String enteredCode, BuildContext context) async {
    try {
      // Lấy tài liệu từ Firestore
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('verificationSignupCodes')
          .doc(email)
          .get();

      if (document.exists) {
        // Ép kiểu dữ liệu để truy cập vào các phần tử
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        String? verificationCode = data?['verificationCode'];
        DateTime expirationTime =
            (data?['expirationTime'] as Timestamp).toDate();

        // Kiểm tra mã xác minh và thời gian hết hạn
        if (verificationCode == enteredCode) {
          if (DateTime.now().isBefore(expirationTime)) {
            // Chuyển tới trang SignupScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignupScreen(
                  email: email,
                ),
              ),
            );
          } else {
            // Thông báo mã đã hết hạn
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mã xác minh đã hết hạn.')),
            );
          }
        } else {
          // Thông báo mã xác minh không đúng
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mã xác minh không đúng.')),
          );
        }
      } else {
        // Thông báo không tìm thấy tài liệu
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Không tìm thấy mã xác minh cho email này.')),
        );
      }
    } catch (e) {
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }

  Future<void> updateUserInfo(
      String email, String fullName, String dateOfBirth, String genre) async {
    try {
      // Tìm người dùng trong Firestore dựa trên email
      QuerySnapshot querySnapshot =
          await _db.collection('users').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Lấy ID của tài liệu
        String userId = querySnapshot.docs.first.id;

        // Cập nhật thông tin người dùng
        await _db.collection('users').doc(userId).update({
          'information': {
            'fullName': fullName,
            'dateOfBirth': dateOfBirth,
            'genre': genre,
          },
        });

        print('Thông tin người dùng đã được cập nhật thành công!');
      } else {
        print('Không tìm thấy người dùng với email này.');
      }
    } catch (e) {
      print('Đã xảy ra lỗi khi cập nhật thông tin người dùng: $e');
    }
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      UserCredential _ = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công!')),
      );

      await Future.wait([
        SharedPreferencesHelper.saveLogin(),
        UserService.saveAllIdsIntoSP(email),
      ]);

      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            // Sử dụng named route
            builder: (context) => const HomeScreen(),
          ));
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'user-not-found') {
        errorMessage = 'Không tìm thấy tài khoản!';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Mật khẩu không đúng!';
      } else {
        errorMessage = 'Email hoặc mật khẩu không đúng!';
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> sendVerifycationLink(BuildContext context, String email) async {
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

  Future<void> logout() async {
    String? userId = await SharedPreferencesHelper.getUserId();
    const url = "${GlobalVar.httpBaseUrl}/ws/logout";
    final Map<String, String> request = {"userId": userId!};
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-type': 'application/json',
          },
          body: jsonEncode(request));
      if (response.statusCode == 200) {
        print('Returned data: ${response.body}');
      } else {
        print(
            'Request post failing post with the status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurs (logout): $error');
    }
  }
}
