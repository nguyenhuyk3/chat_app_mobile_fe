import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/models/response/message.reponse.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http/http.dart';
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
        debugPrint(
            "Lỗi với mã phản hổi là (getMessageBoxById): ${response.statusCode}");
        return [];
      }
    } catch (error) {
      debugPrint("Đã có lỗi xảy ra (getMessageBoxById): $error");
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
          "type": "text",
          "content": content,
        },
      );
      channel.sink.add(message);
    }
  }

  static Future<String> uploadFile(File file) async {
    try {
      const url = "${GlobalVar.httpBaseUrl}/file/upload_file";
      final MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(url));

      request.files.add(await http.MultipartFile.fromPath(
        // Field name in your API
        'file',
        file.path,
        // Get file name
        filename: file.uri.pathSegments.last,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseData.body);

        return jsonResponse['fileUrl'];
      } else {
        throw Exception('Failed to upload file');
      }
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return '';
    }
  }

  static Future<String> sendFile({
    required String senderId,
    required String receiverId,
    required String token,
    required String messageBoxId,
    required String sendedId,
    required File file,
    required WebSocketChannel channel,
  }) async {
    try {
      String fileUrl = await uploadFile(file);

      if (fileUrl.isEmpty) {
        debugPrint('Upload failed. File URL is empty.');
        return "";
      }

      String extension = path.extension(fileUrl).toLowerCase();
      late String type;

      if (['.mp4', '.mov', '.avi'].contains(extension)) {
        type = 'video';
      } else if (['.jpg', '.png', '.jpeg', '.gif'].contains(extension)) {
        type = 'image';
      } else if (['.pdf', '.doc', '.docx', '.txt'].contains(extension)) {
        type = 'document';
      } else {
        type = 'unknown';
      }

      final messageData = jsonEncode({
        "senderId": senderId,
        "receiverId": receiverId,
        "token": token,
        "messageBoxId": messageBoxId,
        "type": type,
        "sendedId": sendedId,
        "content": fileUrl,
      });

      channel.sink.add(messageData);

      debugPrint('File metadata sent successfully: $messageData');

      return fileUrl;
    } catch (e) {
      debugPrint('Error sending file message: $e');

      return "";
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
