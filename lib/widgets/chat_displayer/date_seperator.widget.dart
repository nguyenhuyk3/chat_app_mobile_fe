import 'package:chat_app_mobile_fe/utils/check_date.util.dart';
import 'package:flutter/material.dart';

class DateSeperatorWidget extends StatelessWidget {
  final String createdAt;

  const DateSeperatorWidget({super.key, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF31363F),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            CheckDate.formatDate(createdAt),
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
