

// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/widgets/modals/form_day_month_year.dart';
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
        final userDocument = querySnapshot.docs.first;
        return {
          'fullName': userDocument.data()['information']['fullName'],
          'birthday': userDocument.data()['information']['dayOfBirth'],
          'email': currentUser.email,
        };
      }
    }
    return {'fullName': null, 'email': null}; 
  }

  Future<void> updateInformation({required String fullName, required String dayOfBirth}) async {
    final String? userId = await SharedPreferencesHelper.getUserId();
    const String url = "${GlobalVar.httpBaseUrl}/users/update_information";
    final Map<String, String> request = {
      "userId": userId!,
      "fullName": fullName,
      "dayOfBirth": dayOfBirth,
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
        await currentUser.updatePassword(newPassword);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công')),
        );
      } on FirebaseAuthException catch (e) {
        print('Error: ${e.message}');
      }
    }
  }

  Future<void> editName(BuildContext context, String currentName,
      Function(String) onNameUpdated) async {
    TextEditingController controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chỉnh sửa tên'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Nhập tên mới"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                String newName = controller.text; // Lấy tên mới
                if (newName.isNotEmpty) {
                  onNameUpdated(newName); // Gọi callback để cập nhật tên
                }
                Navigator.of(context).pop();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDatePicker(BuildContext context, String currentBirthday,
      Function(String) onDateSelected) async {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: FormSelectDayMonthYear(
            onDateSelected: (date) {
              onDateSelected(date); // Gọi callback để thông báo ngày đã chọn
              Navigator.pop(context);
            },
            initialDate:
                currentBirthday, // Gán giá trị birthday vào initialDate
          ),
        );
      },
    );
  }
}
