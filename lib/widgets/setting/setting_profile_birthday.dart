import 'package:flutter/material.dart';

class SettingProfileBirthday extends StatelessWidget {
  final String birthday;
  final bool isEditing;
  final Function() onEdit;

  const SettingProfileBirthday({
    required this.birthday,
    required this.isEditing,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 15, left: 15),
          child: Icon(
            Icons.calendar_month_outlined,
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
                          'Ngày sinh ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(
                          width: 299,
                          child: Text(
                            birthday.isNotEmpty ? birthday : 'Chưa có ngày',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (isEditing) // Chỉ hiển thị khi đang chỉnh sửa
                      GestureDetector(
                        onTap: onEdit,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.edit_calendar,
                            color: Color(0xFF00FF9C),
                          ),
                        ),
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
