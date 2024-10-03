class Infomation {
  final String _fullName;
  final String _dateOfBirth;
  final String _genre;

  Infomation({
    required String fullName,
    required String dateOfBirth,
    required String genre,
  })  : _fullName = fullName,
        _dateOfBirth = dateOfBirth,
        _genre = genre;

  String get fullName => _fullName;
  String get dateOfBirth => _dateOfBirth;
  String get genre => _genre;

  Map<String, dynamic> toJson() {
    return {
      'fullName': _fullName,
      'dateOfBirth': _dateOfBirth,
      'genre': _genre,
    };
  }

  factory Infomation.fromJson(Map<String, dynamic> json) {
    return Infomation(
        fullName: json['fullName'],
        dateOfBirth: json['dateOfBirth'],
        genre: json['genre']);
  }
}
