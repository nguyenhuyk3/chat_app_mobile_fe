import 'package:chat_app_mobile_fe/models/response/last_state_for_message_box_on_master_room.response.dart';

abstract class ChatListEvent {}

class LoadMessageBoxes extends ChatListEvent {}

class UpdateOnlineFriends extends ChatListEvent {
  final List<String> friends;

  UpdateOnlineFriends(this.friends);
}

class UpdateFriendStatus extends ChatListEvent {
  final String userId;
  final bool isOnline;
  final String tokenDevice;

  UpdateFriendStatus({required  this.userId,required this.isOnline, required this.tokenDevice});
}

class UpdateLastStateForMessageBox extends ChatListEvent {
  final LastStateForMessageBoxOnMasterRoom lastStateForMessageBoxOnMasterRoom;

  UpdateLastStateForMessageBox(
      {required this.lastStateForMessageBoxOnMasterRoom});
}

class MarkMessageAsRead extends ChatListEvent {
  final String messageBoxId;
  final String userId;

  MarkMessageAsRead({required this.messageBoxId, required this.userId});
}
