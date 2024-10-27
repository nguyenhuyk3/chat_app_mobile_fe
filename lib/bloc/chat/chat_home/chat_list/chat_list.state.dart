import 'package:chat_app_mobile_fe/models/response/all_message_boxes.response.dart';

abstract class ChatListState {}

class ChatInitial extends ChatListState {}

class ChatLoaded extends ChatListState {
  final List<MessageBoxResponse> messageBoxes;
  final Set<String> onlineFriendIds;

  ChatLoaded({required this.messageBoxes, required this.onlineFriendIds});
}