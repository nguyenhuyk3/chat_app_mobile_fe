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
              backgroundColor: Colors.white,
              radius: 80,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green,
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
