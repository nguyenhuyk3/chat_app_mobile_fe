
import 'package:chat_app_mobile_fe/widgets/chat_displayer/message_bubble_widget.dart';

abstract class ChatServices {
  void sendMessage(
      {required String roomId,
      required String userName,
      required String content});
  Message createMessageFromJson({required dynamic json});
}
