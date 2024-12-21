import 'package:chat_app_mobile_fe/models/response/all_message_boxes.response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatListState {}

class ChatLoaded extends ChatListState {
  final List<MessageBoxResponse> messageBoxes;
  final Set<String> onlineFriendIds;
  final String? onlineUserId;

  ChatLoaded({
    required this.messageBoxes,
    required this.onlineFriendIds,
    this.onlineUserId,
  });

  @override
  List<Object?> get props => [messageBoxes, onlineFriendIds, onlineUserId];
}

class CallInitiated extends ChatListState {
  final RTCPeerConnection peerConnection;
  final WebSocketChannel channel;
  final String messageBoxId;
  final String senderId;
  final String receiverId;
  final String receiverName;
  final String token;
  final String? receiverAvatarUrl;

  const CallInitiated({
    required this.peerConnection,
    required this.channel,
    required this.messageBoxId,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.token,
    this.receiverAvatarUrl,
  });

  @override
  List<Object?> get props => [
        peerConnection,
        channel,
        messageBoxId,
        senderId,
        receiverId,
        receiverName,
        token,
        receiverAvatarUrl,
      ];
}
