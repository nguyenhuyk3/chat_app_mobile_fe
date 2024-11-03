import 'package:chat_app_mobile_fe/widgets/modals/form_day_month_year.dart';
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
          'birthday': userDocument.data()['information']['dateOfBirth'],
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
