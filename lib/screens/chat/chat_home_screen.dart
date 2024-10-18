import 'package:chat_app_mobile_fe/widgets/chat_home/chat_list_widget.dart';
import 'package:flutter/material.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  // @override
  // void initState() {
  //   super.initState();

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Received message in foreground: ${message}');
  //     // Hiển thị alert hoặc banner thông báo trong UI
  //     showDialog(
  //       // ignore: use_build_context_synchronously
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: Text(message.notification?.title ?? ''),
  //         content: Text(message.notification?.body ?? ''),
  //         actions: [
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () => Navigator.of(context).pop(),
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const ChatListWidget();
  }
}
