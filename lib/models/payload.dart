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
}
