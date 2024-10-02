import 'package:flutter/material.dart';

class SenderWidget extends StatefulWidget {
  const SenderWidget({super.key});

  @override
  State<SenderWidget> createState() => _SenderWidgetState();
}

class _SenderWidgetState extends State<SenderWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.black,
      child: Row(
        children: <Widget>[
          IconButton(
            icon:
                const Icon(Icons.emoji_emotions_outlined, color: Colors.white),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  hintText: 'Soạn tin nhắn...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send,
                color: Colors.green,
              ))
        ],
      ),
    );
  }
}
