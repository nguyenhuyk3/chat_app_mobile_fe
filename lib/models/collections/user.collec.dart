import 'package:chat_app_mobile_fe/models/information.dart';

class AppUser {
  final String _phoneNumber;
  final String _email;
  final Infomation _information;
  final bool _state;
  final String _sendingInvitationBoxId;
  final String _receivingInvitationBoxId;
  final List<String> _friends;
  final List<String> _chatRooms;
  final String _createdAt;
  final String _updatedAt;

  AppUser({
    required String phoneNumber,
    required String email,
    required Infomation information,
    required bool state,
    required String sendingInvitationBoxId,
    required String receivingInvitationBoxId,
    required List<String> friends,
    required List<String> chatRooms,
    required String createdAt,
    required String updatedAt,
  })  : _phoneNumber = phoneNumber,
        _email = email,
        _information = information,
        _state = state,
        _sendingInvitationBoxId = sendingInvitationBoxId,
        _receivingInvitationBoxId = receivingInvitationBoxId,
        _friends = friends,
        _chatRooms = chatRooms,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  String get phoneNumber => _phoneNumber;
  String get email => _email;
  Infomation get information => _information;
  bool get state => _state;
  String get sendingInvitationBoxId => _sendingInvitationBoxId;
  String get receivingInvitationBoxId => _receivingInvitationBoxId;
  List<String> get friends => _friends;
  List<String> get chatRooms => _chatRooms;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': _phoneNumber,
      'email': _email,
      'information': _information.toJson(),
      'state': _state,
      'sendingInvitationBoxId': _sendingInvitationBoxId,
      'receivingInvitationBoxId': _receivingInvitationBoxId,
      'friends': _friends,
      'chatRooms': _chatRooms,
      'createdAt': _createdAt,
      'updatedAt': _updatedAt,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      information: Infomation.fromJson(
        json['information'],
      ),
      state: json['state'],
      sendingInvitationBoxId: json['sendingInvitationBoxId'],
      receivingInvitationBoxId: json['receivingInvitationBoxId'],
      friends: List<String>.from(json['friends']),
      chatRooms: List<String>.from(json['chatRooms']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
  
}
