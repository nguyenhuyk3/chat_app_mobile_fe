import 'dart:convert';
import 'package:chat_app_mobile_fe/models/enum/genre.dart';
import 'package:chat_app_mobile_fe/models/information.dart';
import 'package:chat_app_mobile_fe/models/user.dart';
import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class SignupLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = AppUser(
        phoneNumber: '',
        email: email,
        information: Infomation(
          fullName: '',
          dateOfBirth: DateTime.now().toString(),
          genre: Genre.male,
        ),
        state: true,
        sendingInvitationBoxId: "",
        receivingInvitationBoxId: "",
        friends: [],
        chatRooms: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('users').doc(user.id).set({
        'phoneNumber': user.phoneNumber,
        'email': user.email,
        'information': {
          'fullName': user.information.fullName,
          'dateOfBirth': user.information.dateOfBirth,
          'genre': user.information.genre.index,
        },
        'state': user.state,
        'friends': user.friends,
        'chatRooms': user.chatRooms,
        'createdAt': user.createdAt,
        'updatedAt': user.updatedAt,
      });
  
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    } else if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }
}
