// ignore_for_file: use_build_context_synchronously

import 'package:chat_app_mobile_fe/services/setting_service.dart';
import 'package:flutter/material.dart';

class SettingProfileName extends StatefulWidget {
  const SettingProfileName({super.key}); // Nhận fullName từ constructor

  @override
  State<SettingProfileName> createState() => _SettingProfileNameState();
}

class _SettingProfileNameState extends State<SettingProfileName> {
  String? name; // Biến để lưu tên
  final SettingService _settingService = SettingService();

  Future<void> _fetchUserData() async {
    final userData = await _settingService.fetchUserData();
    setState(() {
      name = userData['fullName'];
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Khởi tạo tên từ widget
  }

  void _editName() {
    TextEditingController controller = TextEditingController(text: name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chỉnh sửa tên'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Nhập tên mới"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                String newName = controller.text;

                if (newName.isNotEmpty) {
                  setState(() {
                    name = newName; 
                  });
                  await _settingService
                      .updateFullName(newName);
                }
                
                Navigator.of(context).pop();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 15, left: 15),
          child: Icon(
            Icons.person,
            color: Colors.white70,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tên',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(
                        width: 299,
                        child: Text(
                          name ?? 'Chưa có tên', // Hiển thị tên
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _editName,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
