import 'package:chat_app_mobile_fe/models/from_user_infor.dart';

class FriendRequest {
  FromUserInfor _fromUserInfor;
  String _toUserEmail;
  String _status;
  DateTime _createdAt;

  FriendRequest({
    required FromUserInfor fromUserInfor, 
    required String toUserEmail,
    required String status,
    required DateTime createdAt,
  })  : _fromUserInfor = fromUserInfor,
        _toUserEmail = toUserEmail,
        _status = status,
        _createdAt = createdAt;

  FromUserInfor get fromUserInfor => _fromUserInfor;
  String get toUserEmail => _toUserEmail;
  String get status => _status;
  DateTime get createdAt => _createdAt;

  set fromUserInfor(FromUserInfor value) { 
    _fromUserInfor = value;
  }

  set toUserEmail(String value) {
    _toUserEmail = value;
  }

  set status(String value) {
    _status = value;
  }

  set createdAt(DateTime value) {
    _createdAt = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'fromUserInfor': _fromUserInfor.toJson(), 
      'toUserEmail': _toUserEmail,
      'status': _status,
      'createdAt': _createdAt.toIso8601String(), 
    };
  }

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      fromUserInfor: FromUserInfor.fromJson(json['fromUserInfor']), 
      toUserEmail: json['toUserEmail'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
