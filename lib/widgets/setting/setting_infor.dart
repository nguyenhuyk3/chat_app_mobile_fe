import 'package:chat_app_mobile_fe/screens/setting/setting_change_profile_screen.dart';
import 'package:chat_app_mobile_fe/services/setting_service.dart';
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
    // Gọi service để lấy thông tin người dùng
    final userData = await _settingService.fetchUserData();
    setState(() {
      _fullName = userData['fullName']; // Cập nhật tên đầy đủ
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchUserData(); // Gọi hàm để lấy dữ liệu người dùng
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
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 30,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fullName ?? 'Người dùng',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const Text(
                    'Xin chào! đến với Ping ME',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_drop_down_circle_outlined,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
