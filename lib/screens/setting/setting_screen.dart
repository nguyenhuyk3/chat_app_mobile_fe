import 'package:chat_app_mobile_fe/widgets/setting/setting_infor.dart';
import 'package:chat_app_mobile_fe/widgets/setting/setting_items.dart';
import 'package:flutter/material.dart';

class MySettingScreen extends StatefulWidget {
  const MySettingScreen({super.key});

  @override
  State<MySettingScreen> createState() => _MySettingScreenState();
}

class _MySettingScreenState extends State<MySettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222831),
      appBar: AppBar(
        backgroundColor: const Color(0xFF303841),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Text(
              'Cài đặt',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            MySettingInfor(),
            SettingItems(),
          ],
        ),
      ),
    );
  }
}
