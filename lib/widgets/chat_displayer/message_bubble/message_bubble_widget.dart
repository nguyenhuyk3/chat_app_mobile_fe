import 'package:bubble/bubble.dart';
import 'package:chat_app_mobile_fe/models/response/message.reponse.dart';
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
              : const Color(0xFF1679AB),
    );

    if (isVideoMessage) {
      return VideoMessageWidget(
        fileUrl: message.content,
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
