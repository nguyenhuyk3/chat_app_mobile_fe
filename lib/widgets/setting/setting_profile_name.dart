import 'package:flutter/material.dart';

class SettingProfileName extends StatefulWidget {
  final String name;
  final bool isEditing;
  final Function() onEdit;

  const SettingProfileName({
    required this.name,
    required this.isEditing,
    required this.onEdit,
    super.key,
  });

  @override
  State<SettingProfileName> createState() => _SettingProfileNameState();
}

class _SettingProfileNameState extends State<SettingProfileName> {
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
                          widget.name.isNotEmpty ? widget.name : 'Chưa có tên',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (widget.isEditing) // Chỉ hiển thị khi đang chỉnh sửa
                    GestureDetector(
                      onTap: widget.onEdit,
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
