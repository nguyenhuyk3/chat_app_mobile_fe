// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/models/response/message.reponse.dart';
import 'package:chat_app_mobile_fe/utils/log.utils.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatServices {
  static final logger = Logger(printer: CustomPrinter());

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
      String? token,
      required String messageBoxId,
      required String content,
      required String? type,
      required WebSocketChannel channel}) {
    if (content.isNotEmpty) {
      final message = jsonEncode(
        {
          "senderId": senderId,
          "receiverId": receiverId,
          "token": token,
          "messageBoxId": messageBoxId,
          "type": type ??= "text",
          "content": content,
        },
      );
      channel.sink.add(message);
    }
  }

  static Future<String> uploadFile(
      {required File file, required String type}) async {
    try {
      final subUrl =
          type == "video" ? "upload_video_file" : "upload_audio_file";
      final url = "${GlobalVar.httpBaseUrl}/file/$subUrl";
      final MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(url));

      request.files.add(await http.MultipartFile.fromPath(
        // Field name in your API
        "file",
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
      logger.w("==================================");
      logger.i("uploadFile");
      logger.i("Exception: $e");
      logger.w("==================================");
      return '';
    }
  }

  static Future<String> sendFile({
    required String senderId,
    required String receiverId,
    required String? token,
    required String messageBoxId,
    required String sendedId,
    required File file,
    required String typeOfFile,
    required WebSocketChannel channel,
  }) async {
    try {
      String fileUrl = await uploadFile(file: file, type: typeOfFile);

      if (fileUrl.isEmpty) {
        logger.e("Upload failed. File URL is empty.");
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
      } else if (['.mp3', '.mp4', '.aac', '.m4a', '.wav', '.ogg']
          .contains(extension)) {
        type = 'audio';
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

      logger.i('File metadata sent successfully (sendFile): $messageData');

      return fileUrl;
    } catch (e) {
      logger.e('Error sending file message (sendFile): $e');

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
        print('Retuned data: ${response.body}');
      } else {
        print(
            'Request post failing post with the status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurs (readUnreadMessages): $error');
    }
  }
}
