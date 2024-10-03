import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/information.dart';
import 'package:chat_app_mobile_fe/models/collections/user.collec.dart';
import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:chat_app_mobile_fe/screens/home.screen.dart';
import 'package:chat_app_mobile_fe/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registerUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = AppUser(
        phoneNumber: '',
        email: email,
        information: Infomation(
          fullName: '',
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

      // Navigate to LoginScreen or any other screen after registration
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
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

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công!')),
      );

      SharedPreferencesHelper.saveLogin();
      UserService.saveAllIdsIntoSP(email);

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
}
