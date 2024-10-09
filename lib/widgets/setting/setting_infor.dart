import 'package:chat_app_mobile_fe/screens/setting/setting_change_profile_screen.dart';
import 'package:chat_app_mobile_fe/services/setting_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Đảm bảo đã thêm thư viện Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Thêm thư viện Firebase Auth
import 'package:flutter/material.dart';

class MySettingInfor extends StatefulWidget {
  const MySettingInfor({super.key});

  @override
  State<MySettingInfor> createState() => _MySettingInforState();
}

class _MySettingInforState extends State<MySettingInfor> {
  String? _fullName;
  final SettingService _settingService = SettingService();

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Gọi hàm để lấy dữ liệu người dùng
  }

  Future<void> _fetchUserData() async {
    // Gọi service để lấy thông tin người dùng
    final userData = await _settingService.fetchUserData();
    setState(() {
      _fullName = userData['fullName']; // Cập nhật tên đầy đủ
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingChangeProfileScreen(),
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.08, color: Colors.white),
            bottom: BorderSide(width: 0.08, color: Colors.white),
          ),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fullName ??
                        'Người dùng', // Hiển thị tên đầy đủ hoặc "Người dùng" nếu không có
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const Text(
                    'Xin chào! đến với Ping ME',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 80),
              child: const Icon(
                Icons.arrow_drop_down_circle_outlined,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
