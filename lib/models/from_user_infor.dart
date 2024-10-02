class FromUserInfor {
  String _fromUserEmail;
  String _fromUserName;

  FromUserInfor({
    required String fromUserEmail,
    required String fromUserName,
  })  : _fromUserEmail = fromUserEmail,
        _fromUserName = fromUserName;

  String get fromUserEmail => _fromUserEmail;
  String get fromUserName => _fromUserName;

  set fromUserEmail(String value) {
    _fromUserEmail = value;
  }

  set fromUserName(String value) {
    _fromUserName = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'fromUserEmail': _fromUserEmail,
      'fromUserName': _fromUserName,
    };
  }

  factory FromUserInfor.fromJson(Map<String, dynamic> json) {
    return FromUserInfor(
      fromUserEmail: json['fromUserEmail'],
      fromUserName: json['fromUserName'],
    );
  }
}
