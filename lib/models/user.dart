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
  final bool state;
  final List<String> _friends;
  final List<String> _chatRooms;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUser({
    required String phoneNumber,
    required String email,
    required Infomation information,
    required this.state,
    required List<String> friends,
    required List<String> chatRooms,
    required this.createdAt,
    required this.updatedAt,
  })  : _id = generateRandomId(),
        _phoneNumber = phoneNumber,
        _email = email,
        _information = information,
        _friends = friends,
        _chatRooms = chatRooms;

  String get id => _id;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  Infomation get information => _information;
  List<String> get friends => _friends;
  List<String> get chatRooms => _chatRooms;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'phoneNumber': _phoneNumber,
      'email': _email,
      'information':
          _information.toJson(), // Assuming Infomation has a toJson() method
      'state': state,
      'friends': _friends,
      'chatRooms': _chatRooms,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
