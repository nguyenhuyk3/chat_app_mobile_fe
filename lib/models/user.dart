import 'package:chat_app_mobile_fe/models/enum/state.dart';
import 'package:chat_app_mobile_fe/models/information.dart';

class User {
  final String _id;
  final String _phoneNumber;
  final String _email;
  final String hashPassword;
  final Infomation _information;
  final State state;
  final List<String> _friends;
  final List<String> _chatRooms;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required String id,
    required String phoneNumber,
    required String email,
    required this.hashPassword,
    required Infomation information,
    required this.state,
    required List<String> friends,
    required List<String> chatRooms,
    required this.createdAt,
    required this.updatedAt,
  })  : _id = id,
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
}
