import 'package:chat_app_mobile_fe/models/enum/genre.dart';

class Infomation {
  final String _fullName;
  final String _dateOfBirth;
  final Genre genre;

  Infomation({
    required String fullName,
    required String dateOfBirth,
    required this.genre,
  })  : _fullName = fullName,
        _dateOfBirth = dateOfBirth;

  String get fullName => _fullName;
  String get dateOfBirth => _dateOfBirth;

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'genre': genre.toString().split('.').last, // Chuyển enum thành chuỗi
    };
  }
}
