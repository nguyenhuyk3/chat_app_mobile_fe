import 'package:chat_app_mobile_fe/models/response/last_state_for_message_box_on_master_room.response.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ChatListEvent {}

class LoadMessageBoxes extends ChatListEvent {}

class UpdateOnlineFriends extends ChatListEvent {
  final List<String> friends;

  UpdateOnlineFriends({required this.friends});
}

class UpdateFriendStatus extends ChatListEvent {
  final String userId;
  final bool isOnline;
  final String tokenDevice;

  UpdateFriendStatus({
    required this.userId,
    required this.isOnline,
    required this.tokenDevice,
  });
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

class IncommingOffer extends ChatListEvent {
  final String messageBoxId;
  final String senderId;
  final RTCSessionDescription offer;
  final String callType;
  final String token;
  final String senderName;
  final String? senderAvartarUrl;

  IncommingOffer({
    required this.messageBoxId,
    required this.senderId,
    required this.offer,
    required this.callType,
    required this.token,
    required this.senderName,
    this.senderAvartarUrl,
  });
}

class HandleNotificationAction extends ChatListEvent {
  // 'reject' or 'answer'
  final String action;
  final String messageBoxId;
  final String senderId;
  final String callType;

  HandleNotificationAction({
    required this.action,
    required this.messageBoxId,
    required this.senderId,
    required this.callType,
  });
}

class NavigateToCallScreen extends ChatListEvent {
  final RTCPeerConnection? peerConnection;
  final WebSocketChannel channel;
  final String messageBoxId;
  final String senderId;
  final String receiverId;
  final String receiverName;
  final String token;
  final String? receiverAvatarUrl;

   NavigateToCallScreen({
    this.peerConnection,
    required this.channel,
    required this.messageBoxId,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.token,
    this.receiverAvatarUrl,
  });
}
