class TokenDevice {
  final String _userId;
  final String _token;

  TokenDevice({required String userId, required String token})
      : _userId = userId,
        _token = token;

  String get userId => _userId;
  String get token => _token;

  factory TokenDevice.fromJson(Map<String, dynamic> json) {
    return TokenDevice(
      userId: json['userId'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': _userId,
      'token': _token,
    };
  }
}
