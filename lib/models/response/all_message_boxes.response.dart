import 'package:chat_app_mobile_fe/models/message.dart';

class UserInfor {
  final String id;
  final String email;
  final String fullName;
  final String avatar;

  UserInfor({
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatar,
  });

  factory UserInfor.fromJson(Map<String, dynamic> json) {
    return UserInfor(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'avatar': avatar,
    };
  }
}

class LastStateMessage {
  final String userId;
  final String lastMessage;
  final String lastTime;
  final String lastStatus;

  LastStateMessage(
      {required this.userId,
      required this.lastMessage,
      required this.lastTime,
      required this.lastStatus});

  factory LastStateMessage.fromJson(Map<String, dynamic> json) {
    return LastStateMessage(
        userId: json['userId'] ?? '',
        lastMessage: json['lastMessage'] ?? '',
        lastTime: json['lastTime'] ?? '',
        lastStatus: json['lastStatus'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'lastMessage': lastMessage,
      'lastTime': lastTime,
      'lastStatus': lastStatus,
    };
  }
}

class MessageBoxResponse {
  late String messageBoxId;
  late UserInfor firstInforUser;
  late UserInfor secondInforUser;
  late LastStateMessage lastStateMessageForFirstUser;
  late LastStateMessage lastStateMessageForSecondUser;
  late List<Message> messages;
  late String createdAt;

  MessageBoxResponse.fromJson(Map<String, dynamic> json) {
    messageBoxId = json['messageBoxId'];
    firstInforUser = UserInfor.fromJson(json['firstInforUser']);
    secondInforUser = UserInfor.fromJson(json['secondInforUser']);
    lastStateMessageForFirstUser =
        LastStateMessage.fromJson(json['lastStateMessageForFirstUser']);
    lastStateMessageForSecondUser =
        LastStateMessage.fromJson(json['lastStateMessageForSecondUser']);
    messages = (json['messages'] as List?)
            ?.map((messageJson) => Message.fromJson(messageJson))
            .toList() ??
        [];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'messageBoxId': messageBoxId,
      'firstInforUser': firstInforUser.toJson(),
      'secondInforUser': secondInforUser.toJson(),
      'lastStateMessageForFirstUser': lastStateMessageForFirstUser.toJson(),
      'lastStateMessageForSecondUser': lastStateMessageForSecondUser.toJson(),
      'messages': messages.map((message) => message.toJson()).toList(),
      'createdAt': createdAt,
    };
  }

  static List<MessageBoxResponse> parseJsonDataToList(
      Map<String, dynamic> jsonData) {
    if (jsonData['messageBoxesReponse'] != null) {
      List<dynamic> messageBoxList = jsonData['messageBoxesReponse'];
      List<MessageBoxResponse> messageBoxes = messageBoxList
          .map(
            (messageBoxJson) => MessageBoxResponse.fromJson(
                messageBoxJson as Map<String, dynamic>),
          )
          .toList();

      return messageBoxes;
    }

    return [];
  }
}
