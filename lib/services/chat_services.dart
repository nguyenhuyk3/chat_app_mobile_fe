import 'package:chat_app_mobile_fe/response_models/message.dart';

abstract class ChatServices {
  void sendMessage(
      {required String roomId,
      required String userName,
      required String content});
  Message createMessageFromJson({required dynamic json});
}
