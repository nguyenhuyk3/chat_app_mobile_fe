import 'package:bubble/bubble.dart';
import 'package:chat_app_mobile_fe/models/response/message.reponse.dart';
import 'package:flutter/material.dart';

class MessageBubbleWidget extends StatefulWidget {
  final String senderId;
  final bool hasBubbleNip;
  final MessageResponse message;

  const MessageBubbleWidget({
    super.key,
    required this.senderId,
    required this.hasBubbleNip,
    required this.message,
  });

  @override
  State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
}

class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
  bool get isCurrentUser => widget.senderId == widget.message.senderId;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Bubble(
        margin: widget.hasBubbleNip
            ? const BubbleEdges.symmetric(horizontal: 7, vertical: 4)
            : const BubbleEdges.only(left: 15, right: 15, top: 4, bottom: 4),
        padding: const BubbleEdges.all(8),
        nip: widget.hasBubbleNip == false
            ? BubbleNip.no
            : isCurrentUser
                ? BubbleNip.rightTop
                : BubbleNip.leftTop,
        color:
            isCurrentUser ? const Color(0xFF005B41) : const Color(0xFF31363F),
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: Text(
                  widget.message.content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Baseline(
                baseline: 10,
                baselineType: TextBaseline.alphabetic,
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.message.createdAt.split(" ")[1].substring(0, 5),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    Icon(
                      Icons.check_outlined,
                      size: 15,
                      color: widget.message.state == "chưa đọc"
                          ? Colors.grey
                          : const Color(0xFF1679AB),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
