import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final IconData icon; // Biến để nhận icon
  final String title; // Biến để nhận tiêu đề
  final String subtitle; // Biến để nhận phụ đề
  final VoidCallback onPressed; // Biến để nhận hàm callback khi nhấn
  const SettingItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Icon(
                icon, // Sử dụng icon từ biến
                color: Colors.white70,
              ),
            ),
            const SizedBox(width: 10), // Khoảng cách giữa icon và text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, // Sử dụng title từ biến
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                Text(
                  subtitle, // Sử dụng subtitle từ biến
                  style: const TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w400),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
