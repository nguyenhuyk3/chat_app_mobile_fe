import 'package:chat_app_mobile_fe/widgets/ChatHome/chat_list_widget.dart';
import 'package:flutter/material.dart';

import 'package:chat_app_mobile_fe/widgets/ChatHome/chat_header_widget.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ChatHeaderWidget(),
      body: ChatListWidget(),
    );
  }
}
