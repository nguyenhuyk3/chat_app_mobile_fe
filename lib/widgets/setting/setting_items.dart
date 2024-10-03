import 'package:flutter/material.dart';

class SettingItems extends StatelessWidget {
  const SettingItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SettingItem(
        //   icon: Icons.key,
        //   title: 'Tài khoản',
        //   subtitle: 'Đổi email, đổi mật khẩu',
        //   onPressed: () => _moveAccount(context),
        // ),
        // SettingItem(
        //   icon: Icons.supervised_user_circle,
        //   title: 'Ảnh đại diện',
        //   subtitle: 'Tạo, chỉnh sửa ảnh đại diện',
        // ),
      ],
    );
  }

  static void _moveAccount(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ChangeAccountInfo(),
    //   ),
    // );
  }
}
