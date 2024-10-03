import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class Message {
  final String _messageId;
  final String _senderId;
  final String _roomId;
  final String _content;
  final DateTime _createdAt;

  Message({
    required String messageId,
    required String senderId,
    required String roomId,
    required String content,
    required DateTime createdAt,
  })  : _messageId = messageId,
        _senderId = senderId,
        _roomId = roomId,
        _content = content,
        _createdAt = createdAt;

  String get messageId => _messageId;
  String get senderId => _senderId;
  String get roomId => _roomId;
  String get content => _content;
  DateTime get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    return {
      'message_id': _messageId,
      'sender_id': _senderId,
      'room_id': _roomId,
      'content': _content,
      'created_at': _createdAt.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['message_id'],
      senderId: json['sender_id'],
      roomId: json['room_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class MessageBubbleWidget extends StatefulWidget {
  final String senderId;
  final Message message;

  const MessageBubbleWidget(
      {super.key, required this.senderId, required this.message});

  @override
  State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
}

class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.senderId == widget.message.senderId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Bubble(
        margin: const BubbleEdges.symmetric(horizontal: 7, vertical: 4),
        padding: const BubbleEdges.symmetric(vertical: 0, horizontal: 0),
        // nip is used to adjust the position of sharp corners
        nip: widget.senderId == widget.message.senderId
            ? BubbleNip.rightTop
            : BubbleNip.leftTop,
        color: widget.senderId == widget.message.senderId
            ? const Color(0xFF07593B)
            : const Color(0xFF222D33),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            widget.message.content,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
