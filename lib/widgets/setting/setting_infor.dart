import 'package:chat_app_mobile_fe/screens/setting/setting_change_profile_screen.dart';
import 'package:chat_app_mobile_fe/services/setting.service.dart';
import 'package:flutter/material.dart';

class MySettingInfor extends StatefulWidget {
  const MySettingInfor({super.key});

  @override
  State<MySettingInfor> createState() => _MySettingInforState();
}

class _MySettingInforState extends State<MySettingInfor> {
  String? _fullName;
  final SettingService _settingService = SettingService();

  Future<void> _fetchUserData() async {
    // Call service to get user information
    final userData = await _settingService.fetchUserData();
    setState(() {
      // Update full name
      _fullName = userData['fullName'];
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingChangeProfileScreen(),
          ),
        );
        await _fetchUserData();
      },
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.08, color: Colors.white),
            bottom: BorderSide(width: 0.08, color: Colors.white),
          ),
        ),
        child: ListTile(
          leading: const Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 50,
          ),
          title: Text(
            _fullName ?? 'Người dùng',
            style: const TextStyle(color: Colors.white, fontSize: 20),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: const Text(
            'Xin chào! đến với Ping ME',
            style: TextStyle(color: Colors.white60, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(
            Icons.arrow_drop_down_circle_outlined,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
