import 'dart:convert';

import 'package:chat_app_mobile_fe/widgets/ChatHome/chat_element_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({super.key});

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  late WebSocketChannel _channel;
  final Set<String> _roomIds = {};

  Future<void> _getRoomIds() async {
    const url = "http://localhost:8080/ws/getRooms";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        setState(() {
          for (var item in jsonData) {
            String id = item["id"];
            _roomIds.add(id);
          }
        });
      }
    } catch (e) {
      print('hihi Có lỗi xảy ra: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    String url = "ws://localhost:8080/ws/joinMasterRoom";

    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel.stream.listen(
      (data) {
        final jsonData = jsonDecode(data);
        setState(() {
          _roomIds.add(jsonData["roomId"]);
        });
      },
    );

    _getRoomIds();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF0F181D),
        child: ListView.builder(
          itemCount: _roomIds.length,
          itemBuilder: (context, index) {
            return ChatElementWidget(roomId: _roomIds.elementAt(index));
          },
        ));
  }
}
