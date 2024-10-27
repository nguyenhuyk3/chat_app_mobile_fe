import 'package:flutter/material.dart';

class SettingChangePasswordTextfield extends StatefulWidget {
  final String hintText;
  final TextEditingController controller; // Thêm controller

  const SettingChangePasswordTextfield(
      {super.key,
      required this.hintText,
      required this.controller}); // Nhận controller từ constructor

  @override
  State<SettingChangePasswordTextfield> createState() =>
      _SettingChangePasswordTextfieldState();
}

class _SettingChangePasswordTextfieldState
    extends State<SettingChangePasswordTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: widget.controller, // Sử dụng controller
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(width: 0.08, color: Colors.white)),
          filled: true,
          fillColor: const Color.fromARGB(255, 3, 20, 51)),
      obscureText: true,
    );
  }
}
