import 'package:chat_app_mobile_fe/widgets/setting/setting_change_password_form.dart';
import 'package:flutter/material.dart';

class SettingChangePasswordScreen extends StatefulWidget {
  const SettingChangePasswordScreen({super.key});

  @override
  State<SettingChangePasswordScreen> createState() =>
      _SettingChangePasswordScreenState();
}

class _SettingChangePasswordScreenState
    extends State<SettingChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B141B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B141B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Hồ sơ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Đổi mật khẩu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SettingChangePasswordForm(),
          ],
        ),
      ),
    );
  }
}
