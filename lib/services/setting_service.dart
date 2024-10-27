import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Tìm tài liệu theo email
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .get();

      // Kiểm tra xem có tài liệu nào không
      if (snapshot.docs.isNotEmpty) {
        DocumentReference userDoc =
            snapshot.docs.first.reference; // Lấy tài liệu đầu tiên
        await userDoc.update({
          'information': {
            'fullName': fullName,
          },
        }).catchError((error) {
          print("Cập nhật tên thất bại: $error");
        });
      } else {
        print("Không tìm thấy người dùng với email: ${currentUser.email}");
      }
    } else {
      print("Người dùng chưa đăng nhập.");
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
