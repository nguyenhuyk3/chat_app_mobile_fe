import 'package:chat_app_mobile_fe/widgets/authentication/setting/setting_infor.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/setting/setting_item.dart';
import 'package:chat_app_mobile_fe/widgets/authentication/setting/setting_items.dart';
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
      backgroundColor: Color(0xFF0B141B),
      appBar: AppBar(
        backgroundColor: Color(0xFF0B141B),
        title: const Row(
          children: [
            Text(
              'Cài đặt',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        child: const SingleChildScrollView(
          child: Column(
            children: [
              MySettingInfor(),
              SettingItems(),
            ],
          ),
        ),
      ),
    );
  }
}
