import 'dart:convert';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/widgets/chat_home/chat_element_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
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
    String url = "${GlobalVar.httpBaseUrl}/ws/getRooms";

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

    String url = "${GlobalVar.websocketBaseUrl}/joinMasterRoom";

    _channel = IOWebSocketChannel.connect(Uri.parse(url));

    print(_channel);
    _channel.stream.listen(
      (data) {
        final jsonData = jsonDecode(data);
        setState(() {
          _roomIds.add(jsonData["roomId"]);
        });
      },
      onError: (error) {
        print('Có lỗi xảy ra: $error');
      },
      onDone: () {
        print('Kết nối đã bị đóng');
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
