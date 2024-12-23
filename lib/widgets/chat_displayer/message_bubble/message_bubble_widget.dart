import 'package:bubble/bubble.dart';
import 'package:chat_app_mobile_fe/models/response/message.reponse.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/message_bubble/audio_media.widget.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/message_bubble/completed_media_bubble_widget.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/message_bubble/declined_media_bubble_widget.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/message_bubble/missed_media_bubble_widget.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/message_bubble/text_message.widget.dart';
import 'package:chat_app_mobile_fe/widgets/chat_displayer/message_bubble/video_messsage.widget.dart';
import 'package:flutter/material.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String senderId;
  final bool hasBubbleNip;
  final MessageResponse message;

  const MessageBubbleWidget({
    super.key,
    required this.senderId,
    required this.hasBubbleNip,
    required this.message,
  });

  bool get isCurrentUser => senderId == message.senderId;
  bool get isVideoMessage => message.type == "video";
  bool get isCompletedMediaCall => message.type == "completed-media-call";
  bool get isMissedMediaCall => message.type == "missed-media-call";
  bool get isDeclinedMediaCall => message.type == "declined-media-call";
  bool get isAudioMessage => message.type == "audio";

  Widget _buildMessageContent() {
    Widget createdAt = Text(
      message.createdAt.split(" ")[1].substring(0, 5),
      style: TextStyle(
        fontSize: 11,
        color: isVideoMessage ? Colors.white : Colors.grey,
      ),
    );
    Widget messageState = Icon(
      Icons.check_outlined,
      size: 15,
      color: message.state == "chưa đọc"
          ? Colors.grey
          : message.state == ""
              ? Colors.grey
              : Colors.blue,
    );

    if (isVideoMessage) {
      return VideoMessageWidget(
        fileUrl: message.content,
        createdAt: createdAt,
        messageState: messageState,
      );
    } else if (isCompletedMediaCall) {
      return CompletedMediaBubbleWidget(
        content: message.content,
        createdAt: createdAt,
        messageState: messageState,
        icon: Icons.phone_forwarded_outlined,
      );
    } else if (isMissedMediaCall) {
      return MissedMediaBubbleWidget(
        isCurrentUser: isCurrentUser,
        content: message.content,
        createdAt: createdAt,
        messageState: messageState,
        icon: Icons.phone_missed_outlined,
      );
    } else if (isDeclinedMediaCall) {
      return DeclinedMediaBubble(
        isCurrentUser: isCurrentUser,
        content: message.content,
        createdAt: createdAt,
        messageState: messageState,
        icon: Icons.phone_missed_outlined,
      );
    } else if (isAudioMessage) {
      return AudioMessageWidget(
        audioUrl: message.content,
        createdAt: createdAt,
        messageState: messageState,
      );
    } else {
      return TextMessageWidget(
        content: message.content,
        createdAt: createdAt,
        messageState: messageState,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Bubble(
        margin: hasBubbleNip
            ? const BubbleEdges.symmetric(horizontal: 7, vertical: 4)
            : const BubbleEdges.only(left: 15, right: 15, top: 4, bottom: 4),
        padding: isVideoMessage
            ? const BubbleEdges.all(4)
            : const BubbleEdges.all(8),
        nip: hasBubbleNip == false
            ? BubbleNip.no
            : isCurrentUser
                ? BubbleNip.rightTop
                : BubbleNip.leftTop,
        color:
            isCurrentUser ? const Color(0xFF005B41) : const Color(0xFF31363F),
        child: _buildMessageContent(),
      ),
    );
  }
}
