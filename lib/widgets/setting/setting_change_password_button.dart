import 'package:flutter/material.dart';

class SettingChangePasswordButton extends StatefulWidget {
  final void Function() onPressed; // Khai báo biến onPressed

  const SettingChangePasswordButton({super.key, required this.onPressed});

  @override
  State<SettingChangePasswordButton> createState() =>
      _SettingChangePasswordButtonState();
}

class _SettingChangePasswordButtonState
    extends State<SettingChangePasswordButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.08, color: Colors.white)),
      child: TextButton(
        onPressed: widget.onPressed,
        child: const Text(
          'XÁC NHẬN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
