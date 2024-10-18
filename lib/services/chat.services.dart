import 'dart:convert';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/models/response/message.reponse.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatServices {
  static Future<List<MessageResponse>> getMessageBoxById(
      String messageBoxId) async {
    final String url =
        "${GlobalVar.httpBaseUrl}/users/get_message_box_by_id?message_box_id=$messageBoxId";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final messageBoxData = responseData['messageBox'];
        final List<dynamic> messages = messageBoxData['messages'];
        final List<MessageResponse> messageBox = messages
            .map(
              (messageJson) =>
                  MessageResponse.fromJson(messageJson as Map<String, dynamic>),
            )
            .toList();

        return messageBox;
      } else {
        print(
            "Lỗi với mã phản hổi là (getMessageBoxById): ${response.statusCode}");
        return [];
      }
    } catch (error) {
      print("Đã có lỗi xảy ra (getMessageBoxById): ${error}");
      return [];
    }
  }

  static void sendMessage(
      {required String senderId,
      required String receiverId,
      required String token,
      required String messageBoxId,
      required String content,
      required WebSocketChannel channel}) {
    if (content.isNotEmpty) {
      final message = jsonEncode(
        {
          "senderId": senderId,
          "receiverId": receiverId,
          "token": token,
          "messageBoxId": messageBoxId,
          "content": content,
        },
      );

      channel.sink.add(message);
    }
  }

  static Future<void> readUnreadMessages(
      {required String userId, required String messageBoxId}) async {
    const url = "${GlobalVar.httpBaseUrl}/users/read_unreaded_messages";
    final Map<String, dynamic> request = {
      "messageBoxId": messageBoxId,
      "userId": userId
    };

    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-type': 'application/json',
          },
          body: jsonEncode(request));

      if (response.statusCode == 200) {
        print('Dữ liệu trả về: ${response.body}');
      } else {
        print(
            'Yêu cầu POST thất bại với mã trạng thái: ${response.statusCode}');
      }
    } catch (error) {
      print('Đã xảy ra lỗi (readUnreadMessages): $error');
    }
  }
}
