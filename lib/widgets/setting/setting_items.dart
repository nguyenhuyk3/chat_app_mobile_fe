import 'package:chat_app_mobile_fe/screens/setting/setting_change_password_screen.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_item.dart';
import 'package:flutter/material.dart';

class SettingItems extends StatelessWidget {
  const SettingItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingItem(
          icon: Icons.key,
          title: 'Tài khoản',
          subtitle: 'Đổi mật khẩu',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SettingChangePasswordScreen()),
            );
          },
        ),
      ],
    );
  }
}
