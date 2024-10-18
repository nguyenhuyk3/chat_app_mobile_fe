class Message {
  final String _senderId;
  final String _content;
  final String _state;
  final String _createdAt;

  Message({
    required String senderId,
    required String content,
    required String state,
    required String createdAt,
  })  : _senderId = senderId,
        _content = content,
        _state = state,
        _createdAt = createdAt;

  String get senderId => _senderId;
  String get content => _content;
  String get state => _state;
  String get createdAt => _createdAt;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      content: json['content'],
      state: json['state'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': _senderId,
      'content': _content,
      'state': _state,
      'createdAt': _createdAt,
    };
  }
}
