class Payload {
  final Type _type;
  final dynamic _payload;

  Payload({
    required Type type,
    required dynamic payload,
  })  : _type = type,
        _payload = payload;

  Type get type => _type;
  dynamic get payload => _payload;

  Map<String, dynamic> toJson() {
    return {
      'type': _type.toString(), // Assuming Type is an enum or class
      'payload': _payload,
    };
  }
}
