import 'package:chat_app_mobile_fe/models/enum/genre.dart';

class Infomation {
  final String _fullName;
  final String _dateOfBirth;
  final Genre _genre;

  Infomation({
    required String fullName,
    required String dateOfBirth,
    required Genre genre,
  })  : _fullName = fullName,
        _dateOfBirth = dateOfBirth,
        _genre = genre;

  String get fullName => _fullName;
  String get dateOfBirth => _dateOfBirth;
  Genre get genre => _genre;

  Map<String, dynamic> toJson() {
    return {
      'fullName': _fullName,
      'dateOfBirth': _dateOfBirth,
      'genre': genre.toString(),
    };
  }

  factory Infomation.fromJson(Map<String, dynamic> json) {
    return Infomation(
      fullName: json['fullName'],
      dateOfBirth: json['dateOfBirth'],
      genre: Genre.values.firstWhere((e) => e.toString() == json['genre']),
    );
  }
}
