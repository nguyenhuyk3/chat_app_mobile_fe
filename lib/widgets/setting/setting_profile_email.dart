import 'package:chat_app_mobile_fe/services/setting_service.dart';
import 'package:flutter/material.dart';

class SettingProfileEmail extends StatefulWidget {
  const SettingProfileEmail({super.key}); // Nhận email từ constructor

  @override
  State<SettingProfileEmail> createState() => _SettingProfileEmailState();
}

class _SettingProfileEmailState extends State<SettingProfileEmail> {
  String? email; // Biến để lưu email
  final SettingService _settingService = SettingService();
  @override
  void initState() {
    super.initState();
    // Khởi tạo email từ widget
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userData = await _settingService.fetchUserData();
    setState(() {
      email = userData['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 15, left: 15),
          child: Icon(
            Icons.mail,
            color: Colors.white70,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 0.08, color: Colors.white),
            ),
          ),
          child: Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(
                          width: 299, // Chiều rộng tối đa cho email
                          child: Text(
                            email ?? 'Chưa có email', // Hiển thị email
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
