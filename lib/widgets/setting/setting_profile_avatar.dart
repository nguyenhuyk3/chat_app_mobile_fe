import 'package:flutter/material.dart';

class SettingProfileAvatar extends StatefulWidget {
  const SettingProfileAvatar({super.key});

  @override
  State<SettingProfileAvatar> createState() => _SettingProfileAvatarState();
}

class _SettingProfileAvatarState extends State<SettingProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Stack(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 80,
              child: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 160,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF9C),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
