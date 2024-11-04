class Information {
  final String _fullName;
  final String _dateOfBirth;
  final String _genre;

  Information({
    required String fullName,
    required String dayOfBirth,
    required String genre,
  })  : _fullName = fullName,
        _dateOfBirth = dayOfBirth,
        _genre = genre;

  String get fullName => _fullName;
  String get dateOfBirth => _dateOfBirth;
  String get genre => _genre;

  Map<String, dynamic> toJson() {
    return {
      'fullName': _fullName,
      'dayOfBirth': _dateOfBirth,
      'genre': _genre,
    };
  }

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
        fullName: json['fullName'],
        dayOfBirth: json['dayOfBirth'],
        genre: json['genre']);
  }
}
