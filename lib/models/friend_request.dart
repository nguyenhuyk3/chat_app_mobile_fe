import 'package:chat_app_mobile_fe/models/from_user_infor.dart';

class FriendRequest {
  FromUserInfor _fromUserInfor;
  String _toUserEmail;
  String _status;
  String _createdAt;

  FriendRequest({
    required FromUserInfor fromUserInfor, 
    required String toUserEmail,
    required String status,
    required String createdAt,
  })  : _fromUserInfor = fromUserInfor,
        _toUserEmail = toUserEmail,
        _status = status,
        _createdAt = createdAt;

  FromUserInfor get fromUserInfor => _fromUserInfor;
  String get toUserEmail => _toUserEmail;
  String get status => _status;
  String get createdAt => _createdAt;

  

  Map<String, dynamic> toJson() {
    return {
      'fromUserInfor': _fromUserInfor.toJson(), 
      'toUserEmail': _toUserEmail,
      'status': _status,
      'createdAt': _createdAt, 
    };
  }

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      fromUserInfor: FromUserInfor.fromJson(json['fromUserInfor']), 
      toUserEmail: json['toUserEmail'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }
}
