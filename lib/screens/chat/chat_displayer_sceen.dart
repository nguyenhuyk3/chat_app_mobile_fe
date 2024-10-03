import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/message_bubble_widget.dart';

class ChatDisplayerScreen extends StatefulWidget {
  final String roomId;
  const ChatDisplayerScreen({super.key, required this.roomId});

  @override
  State<ChatDisplayerScreen> createState() => _ChatDisplayerScreenState();
}

class _ChatDisplayerScreenState extends State<ChatDisplayerScreen> {
  late WebSocketChannel _channel;
  Random random = Random();
  late int id;
  late String username;
  TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    id = random.nextInt(20);
    username = "user" + GlobalVar.id.toString();

    String roomId = widget.roomId;

    final String url =
        "ws://localhost:8080/ws/joinRoom/$roomId?userId=$id&username=$username";

    print(id);

    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel.stream.listen(
      (data) {
        final jsonData = jsonDecode(data);

        setState(
          () {
            print(jsonData);

            String messageId = random.nextInt(200).toString();
            String content = jsonData["content"];
            String roomId = jsonData["roomId"];
            String userName = jsonData["username"];

            Message message = Message(
                messageId: random.nextInt(200).toString(),
                senderId: userName,
                roomId: roomId,
                content: content,
                createdAt: DateTime.now());

            messages.add(message);
          },
        );
      },
    );
  }

  void _sendMessage(
      {required String roomId,
      required String userName,
      required String content}) {
    if (content.isNotEmpty) {
      final message = jsonEncode(
        {
          "content": content,
          "roomId": roomId,
          "username": username,
        },
      );

      _channel.sink.add(message);
      _messageController.clear();
    }
  }

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
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubbleWidget(
                      senderId: username, message: messages[index]);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.black,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined,
                        color: Colors.white),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                          hintText: 'Soạn tin nhắn...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _sendMessage(
                          roomId: widget.roomId,
                          userName: username,
                          content: _messageController.text);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
