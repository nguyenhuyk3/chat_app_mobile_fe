import 'dart:math';
import 'package:chat_app_mobile_fe/models/information.dart';

String generateRandomId() {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(
      8, (index) => characters[random.nextInt(characters.length)]).join();
}

class AppUser {
  final String _id;
  final String _phoneNumber;
  final String _email;
  final Infomation _information;
  final bool _state;
  final String _sendingInvitationBoxId;
  final String _receivingInvitationBoxId;
  final List<String> _friends;
  final List<String> _chatRooms;
  final DateTime _createdAt;
  final DateTime _updatedAt;

  AppUser({
    required String phoneNumber,
    required String email,
    required Infomation information,
    required bool state,
    required String sendingInvitationBoxId,
    required String receivingInvitationBoxId,
    required List<String> friends,
    required List<String> chatRooms,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : _id = generateRandomId(),
        _phoneNumber = phoneNumber,
        _email = email,
        _information = information,
        _state = state,
        _sendingInvitationBoxId = sendingInvitationBoxId,
        _receivingInvitationBoxId = receivingInvitationBoxId,
        _friends = friends,
        _chatRooms = chatRooms,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  String get id => _id;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  Infomation get information => _information;
  bool get state => _state;
  String get sendingInvitationBoxId => _sendingInvitationBoxId;
  String get receivingInvitationBoxId => _receivingInvitationBoxId;
  List<String> get friends => _friends;
  List<String> get chatRooms => _chatRooms;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'phoneNumber': _phoneNumber,
      'email': _email,
      'information': _information.toJson(),
      'state': _state,
      'sendingInvitationBoxId': _sendingInvitationBoxId,
      'receivingInvitationBoxId': _receivingInvitationBoxId,
      'friends': _friends,
      'chatRooms': _chatRooms,
      'createdAt': _createdAt.toIso8601String(), 
      'updatedAt': _updatedAt.toIso8601String(), 
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      information: Infomation.fromJson(
          json['information']), 
      state: json['state'],
      sendingInvitationBoxId: json['sendingInvitationBoxId'],
      receivingInvitationBoxId: json['receivingInvitationBoxId'],
      friends: List<String>.from(json['friends']),
      chatRooms: List<String>.from(json['chatRooms']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
