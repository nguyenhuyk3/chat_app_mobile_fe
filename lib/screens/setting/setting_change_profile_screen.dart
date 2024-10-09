import 'package:chat_app_mobile_fe/services/setting_service.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_profile_avatar.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_profile_email.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_profile_name.dart';
import 'package:flutter/material.dart';

class SettingChangeProfileScreen extends StatefulWidget {
  const SettingChangeProfileScreen({super.key});

  @override
  State<SettingChangeProfileScreen> createState() =>
      _SettingChangeProfileScreenState();
}

class _SettingChangeProfileScreenState
    extends State<SettingChangeProfileScreen> {
  String? _email;
  final SettingService _settingService = SettingService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B141B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B141B),
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
        child: const SingleChildScrollView(
          child: Column(
            children: [
              SettingProfileAvatar(),
              SizedBox(height: 20),
              SettingProfileName(), // Truyền fullName
              SizedBox(height: 10),
              SettingProfileEmail(), // Truyền email
            ],
          ),
        ),
      ),
    );
  }
}
