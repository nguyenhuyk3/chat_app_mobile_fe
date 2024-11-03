import 'dart:convert';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingService {
  Future<Map<String, String?>> fetchUserData() async {
    User? currentUser =
        FirebaseAuth.instance.currentUser; // Lấy người dùng hiện tại
    if (currentUser != null) {
      // Tìm kiếm trong collection 'users' theo email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Nếu tìm thấy tài liệu
        final userDocument = querySnapshot.docs.first; // Lấy tài liệu đầu tiên
        return {
          'fullName': userDocument.data()['information']['fullName'],
          'email': currentUser.email,
        };
      }
    }
    return {'fullName': null, 'email': null}; // Trả về null nếu không tìm thấy
  }

  Future<void> updateFullName(String fullName) async {
    final String? userId = await SharedPreferencesHelper.getUserId();
    const String url = "${GlobalVar.httpBaseUrl}/users/update_information";
    final Map<String, String> request = {
      "userId": userId!,
      "fullName": fullName,
    };
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode(request),
      );
      if (response.statusCode == 200) {
        print('Returned data (updateFullName): ${response.body}');
      } else {
        print(
            'POST request failed with status code (updateFullName): ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred (updateFullName): $error');
    }
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword, BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        final String email = currentUser.email!;
        final credential = EmailAuthProvider.credential(
            email: email, password: currentPassword);

        await currentUser.reauthenticateWithCredential(credential);

        // Cập nhật mật khẩu mới
        await currentUser.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công')),
        );
      } on FirebaseAuthException catch (e) {
        // Xử lý lỗi nếu có
        print('Lỗi: ${e.message}');
      }
    }
  }
}
