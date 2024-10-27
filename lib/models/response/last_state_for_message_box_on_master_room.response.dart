class LastStateForMessageBoxOnMasterRoom {
  final String senderId;
  final String messageBoxId;
  final String lastMessage;
  final String lastTime;
  final String lastStatus;

  LastStateForMessageBoxOnMasterRoom({
    required this.senderId,
    required this.messageBoxId,
    required this.lastMessage,
    required this.lastTime,
    required this.lastStatus,
  });

  factory LastStateForMessageBoxOnMasterRoom.fromJson(
      Map<String, dynamic> json) {
    return LastStateForMessageBoxOnMasterRoom(
      senderId: json['senderId'] as String,
      messageBoxId: json['messageBoxId'] as String,
      lastMessage: json['lastMessage'] as String,
      lastTime: json['lastTime'] as String,
      lastStatus: json['lastStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'messageBoxId': messageBoxId,
      'lastMessage': lastMessage,
      'lastTime': lastTime,
      'lastStatus': lastStatus,
    };
  }
}
