class MessageResponse {
  late final String _senderId;
  late final String _content;
  late final String _state;
  late final String _createdAt;

  MessageResponse({
    required String senderId,
    required String content,
    required String state,
  })  : _senderId = senderId,
        _content = content,
        _state = state,
        _createdAt = "";

  MessageResponse.createdAt({
    required String senderId,
    required String content,
    required String state,
    required String createdAt,
  })  : _senderId = senderId,
        _content = content,
        _state = state,
        _createdAt = createdAt;

  // Private constructor, can only create objects via fromJson
  MessageResponse._({
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

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse._(
      senderId: json['senderId'] ?? "",
      content: json['content'] ?? "",
      state: json['state'] ?? "",
      createdAt: json['createdAt'] ?? "",
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

  MessageResponse copyWith({
    String? senderId,
    String? content,
    String? state,
    String? createdAt,
  }) {
    return MessageResponse.createdAt(
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt
    );
  }
}
