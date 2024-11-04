import 'package:chat_app_mobile_fe/services/setting.service.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_change_password_button.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_change_password_textfield.dart';
import 'package:flutter/material.dart';

class SettingChangePasswordForm extends StatefulWidget {
  const SettingChangePasswordForm({super.key});

  @override
  State<SettingChangePasswordForm> createState() =>
      _SettingChangePasswordFormState();
}

class _SettingChangePasswordFormState extends State<SettingChangePasswordForm> {
  final SettingService _settingService = SettingService();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _changePassword() async {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword == confirmPassword) {
      await _settingService.updatePassword(
          currentPassword, newPassword, context);
      // Bạn có thể thêm một thông báo cho người dùng ở đây nếu muốn
    } else {
      // Xử lý trường hợp mật khẩu mới và xác nhận không khớp
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu nhập lại không khớp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SettingChangePasswordTextfield(
            hintText: 'Nhập mật khẩu hiện tại',
            controller: _currentPasswordController,
          ),
          const SizedBox(height: 10),
          SettingChangePasswordTextfield(
            hintText: 'Nhập mật khẩu mới',
            controller: _newPasswordController,
          ),
          const SizedBox(height: 10),
          SettingChangePasswordTextfield(
            hintText: 'Nhập lại mật khẩu mới',
            controller: _confirmPasswordController,
          ),
          const SizedBox(height: 20),
          SettingChangePasswordButton(onPressed: _changePassword),
        ],
      ),
    );
  }
}
