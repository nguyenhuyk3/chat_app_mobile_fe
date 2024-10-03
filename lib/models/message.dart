import 'package:chat_app_mobile_fe/models/payload.dart';

class Message {
  final String _idOfChatRoom;
  final String _senderId;
  final String _receiverId;
  final Payload _payload;
  final DateTime _createdAt;

  Message({
    required String idOfChatRoom,
    required String senderId,
    required String receiverId,
    required Payload payload,
    required DateTime createdAt,
  })  : _idOfChatRoom = idOfChatRoom,
        _senderId = senderId,
        _receiverId = receiverId,
        _payload = payload,
        _createdAt = createdAt;

  String get idOfChatRoom => _idOfChatRoom;
  String get senderId => _senderId;
  String get receiverId => _receiverId;
  Payload get payload => _payload;
  DateTime get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    return {
      'idOfChatRoom': _idOfChatRoom,
      'senderId': _senderId,
      'receiverId': _receiverId,
      'payload': _payload.toJson(),
      'createdAt': _createdAt.toIso8601String(),
    };
  }
}
