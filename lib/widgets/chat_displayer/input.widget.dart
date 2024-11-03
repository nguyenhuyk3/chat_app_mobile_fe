// chat_input_widget.dart
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController messageController;
  final Function(String, String?) onSendMessage;
  final Future<void> Function() onPickFile;

  const InputWidget({
    super.key,
    required this.messageController,
    required this.onSendMessage,
    required this.onPickFile,
  });

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.first.path!);
      await onPickFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.attach_file,
              color: Color(0xFFB7B7B7),
            ),
            onPressed: _pickFile,
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nhắn tin',
                hintStyle: const TextStyle(color: Color(0xFFB7B7B7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF31363F),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                prefixIcon: IconButton(
                  icon: const Icon(
                    Icons.emoji_emotions,
                    color: Color(0xFFB7B7B7),
                  ),
                  onPressed: () {}, // Mở emoji picker
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () => onSendMessage(messageController.text, null),
            backgroundColor: const Color(0xFF00FF9C),
            mini: true,
            child: const Icon(
              Icons.send,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
