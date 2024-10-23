class MessageResponse {
  late final String _senderId;
  late final String _type;
  late final String _content;
  late final String _sendedId;
  late final String _state;
  late final String _createdAt;

  MessageResponse({
    required String senderId,
    required String type,
    required String content,
    required String sendedId,
    required String state,
  })  : _senderId = senderId,
        _type = type,
        _content = content,
        _sendedId = senderId,
        _state = state,
        _createdAt = "";

  // Full constructor, including createdAt
  MessageResponse.createdAt({
    required String senderId,
    required String type,
    required String content,
    required String sendedId,
    required String state,
    required String createdAt,
  })  : _senderId = senderId,
        _type = type,
        _content = content,
        _sendedId = sendedId,
        _state = state,
        _createdAt = createdAt;

  MessageResponse.state({
    required String senderId,
    required String type,
    required String content,
    required String sendedId,
    required String createdAt,
  })  : _senderId = senderId,
        _type = type,
        _content = content,
        _sendedId = sendedId,
        _state = "",
        _createdAt = createdAt;

  // Private constructor, using for fromJson
  MessageResponse._({
    required String senderId,
    required String type,
    required String content,
    required String sendedId,
    required String state,
    required String createdAt,
  })  : _senderId = senderId,
        _type = type,
        _content = content,
        _sendedId = sendedId,
        _state = state,
        _createdAt = createdAt;

  String get senderId => _senderId;
  String get type => _type;
  String get content => _content;
  String get sendedId => _sendedId;
  String get state => _state;
  String get createdAt => _createdAt;

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse._(
      senderId: json['senderId'] ?? "",
      type: json['type'] ?? "text",
      content: json['content'] ?? "",
      sendedId: json['sendedId'] ?? "",
      state: json['state'] ?? "",
      createdAt: json['createdAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': _senderId,
      'type': _type,
      'content': _content,
      'sendedId': _sendedId,
      'state': _state,
      'createdAt': _createdAt,
    };
  }

  MessageResponse copyWith({
    String? senderId,
    String? type,
    String? content,
    String? sendedId,
    String? state,
    String? createdAt,
  }) {
    return MessageResponse.createdAt(
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      content: content ?? this.content,
      sendedId: senderId ?? this.sendedId,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
