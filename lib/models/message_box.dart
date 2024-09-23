import 'package:chat_app_mobile_fe/models/message.dart';

class MessageBox {
  final String _id;
  final List<Message> _messages;
  final DateTime _createdAt;

  MessageBox({
    required String id,
    required List<Message> messages,
    required DateTime createdAt,
  })  : _id = id,
        _messages = messages,
        _createdAt = createdAt;

  String get id => _id;
  List<Message> get messages => _messages;
  DateTime get createdAt => _createdAt;
}
