import 'dart:convert';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/response/all_message_boxes.response.dart';
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
  late String? userId;
  late WebSocketChannel channel;
  List<MessageBoxResponse> messageBoxes = [];

  Future<void> _initUserId() async {
    userId = await SharedPreferencesHelper.getUserId();
  }

  Future<void> _getMessageBoxes() async {
    String url =
        "${GlobalVar.httpBaseUrl}/users/get_all_message_boxes?user_id=${userId!}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    
        setState(
          () {
            messageBoxes = MessageBoxResponse.parseJsonDataToList(jsonData);
          },
        );
      }
    } catch (error) {
      print('An error occurred while retrieving messageBoxes (getMessageBox): $error');
    }
  }

  Future<void> _initializeChat() async {
    await _getMessageBoxes();

    String url =
        "${GlobalVar.websocketBaseUrl}/join_master_room?user_id=${userId!}";

    channel = IOWebSocketChannel.connect(Uri.parse(url));
    channel.stream.listen(
      (dynamic data) {
        final jsonData = jsonDecode(data);

        print(jsonData);
      },
      onError: (error) {
        print('An error occurred: $error');
      },
      onDone: () {
        print('Connection closed');
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _initUserId().then(
      (_) => {_initializeChat()},
    );
  }

  @override
  void dispose() {
    channel.sink.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF222831),
      child: ListView.builder(
        itemCount: messageBoxes.length,
        itemBuilder: (context, index) {
          return ChatElementWidget(
            messageBoxId: messageBoxes[index].messageBoxId,
            receiverId: messageBoxes[index].firstInforUser.id != userId!
                ? messageBoxes[index].firstInforUser.id
                : messageBoxes[index].secondInforUser.id,
            messageBoxReponse: messageBoxes[index],
          );
        },
      ),
    );
  }
}
