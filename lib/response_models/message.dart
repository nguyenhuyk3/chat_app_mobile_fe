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
