import 'package:chat_app_mobile_fe/widgets/ChatHome/message_bubble_widget.dart';
import 'package:flutter/material.dart';

import 'package:chat_app_mobile_fe/models/message.dart';

class ChatDisplayerScreen extends StatefulWidget {
  const ChatDisplayerScreen({super.key});

  @override
  State<ChatDisplayerScreen> createState() => _ChatDisplayerScreenState();
}

class _ChatDisplayerScreenState extends State<ChatDisplayerScreen> {
  final List<Message> messages = [
    Message(sender: 'User1', text: 'Hello! How are you?', isMe: false),
    Message(
        sender: 'User2', text: 'I am fine, thanks! How about you?', isMe: true),
    Message(sender: 'User1', text: 'I am doing well, thank you!', isMe: false),
    // Thêm nhiều tin nhắn hơn ở đây
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111E26),
        leading: const Icon(
          Icons.account_circle_outlined,
          color: Colors.grey,
          size: 40,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                './assets/img/app/background_for_chat_displayer.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubbleWidget(message: messages[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
