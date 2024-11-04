import 'package:chat_app_mobile_fe/services/setting.service.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_profile_avatar.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_profile_email.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_profile_name.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_profile_birthday.dart'; // Import widget mới
import 'package:flutter/material.dart';

class SettingChangeProfileScreen extends StatefulWidget {
  const SettingChangeProfileScreen({super.key});

  @override
  State<SettingChangeProfileScreen> createState() =>
      _SettingChangeProfileScreenState();
}

class _SettingChangeProfileScreenState
    extends State<SettingChangeProfileScreen> {
  bool _isEditing = false;
  String name = ""; // Khởi tạo với giá trị mặc định
  String birthday = ""; // Khởi tạo với giá trị mặc định
  String originalName = ""; // Biến lưu tên ban đầu
  String originalBirthday = ""; // Biến lưu ngày sinh ban đầu

  final SettingService _settingService = SettingService();

  Future<void> _fetchUserData() async {
    final userData = await _settingService.fetchUserData();
    setState(() {
      name = userData['fullName']!;
      birthday = userData['birthday']!;
      originalName = name; // Ghi nhận tên ban đầu
      originalBirthday = birthday; // Ghi nhận ngày sinh ban đầu
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _toggleEditing() {
    setState(() {
      if (_isEditing) {
        // Khi hủy chỉnh sửa, khôi phục giá trị ban đầu
        name = originalName;
        birthday = originalBirthday;
      } else {
        // Khi bắt đầu chỉnh sửa, ghi nhận các giá trị ban đầu
        originalName = name;
        originalBirthday = birthday;
      }
      _isEditing = !_isEditing; // Chuyển đổi trạng thái
    });
  }

  void _editName() {
    _settingService.editName(context, name, (newName) {
      setState(() {
        name = newName; // Cập nhật tên mới
      });
    });
  }

  void _showDatePicker() {
    _settingService.showDatePicker(context, birthday, (date) {
      setState(() {
        birthday = date; // Cập nhật giá trị birthday
      });
      print("Updated birthday: $birthday");
    });
  }

  Future<void> _updateInformation(
      {required String fullName, required String dayOfBirth}) async {
    await SettingService()
        .updateInformation(fullName: fullName, dayOfBirth: dayOfBirth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303841),
      appBar: AppBar(
        backgroundColor: const Color(0xFF303841),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Text(
              'Hồ sơ',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SettingProfileAvatar(),
              const SizedBox(height: 20),
              const SettingProfileEmail(),
              const SizedBox(height: 10),
              SettingProfileName(
                name: name,
                isEditing: _isEditing,
                onEdit: _editName,
              ),
              const SizedBox(height: 10),
              SettingProfileBirthday(
                // Use widget SettingProfileBirthday
                birthday: birthday,
                isEditing: _isEditing,
                onEdit: _showDatePicker,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: _toggleEditing,
                    child: Text(
                      _isEditing ? 'Hủy chỉnh sửa' : 'Thay đổi thông tin',
                      style: const TextStyle(color: Color(0xFF00FF9C)),
                    ),
                  ),
                  if (_isEditing)
                    TextButton(
                      onPressed: () {
                        _updateInformation(
                            fullName: name, dayOfBirth: birthday);
                      },
                      child: const Text(
                        "Lưu",
                        style: TextStyle(color: Color(0xFF00FF9C)),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
