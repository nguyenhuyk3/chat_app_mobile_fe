import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final String userId;
  final TextEditingController messageController;
  final Function({required String content}) onSendMessage;
  
  const InputWidget({
    super.key,
    required this.userId,
    required this.messageController,
    required this.onSendMessage,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.messageController,
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
                    horizontal: 20.0, vertical: 10.0),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions,
                      color: Color(0xFFB7B7B7)),
                  onPressed: widget.onSendMessage(
                      content: widget.messageController.text),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () {},
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
