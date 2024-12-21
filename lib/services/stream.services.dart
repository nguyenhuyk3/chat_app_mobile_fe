import 'dart:async';

class StreamServics {
  StreamServics._internal();

  static final StreamServics _instance = StreamServics._internal();
  factory StreamServics() => _instance;
  final _callDataController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get callDataController =>
      _callDataController.stream;

  void updateCallData(Map<String, dynamic> data) {
    _callDataController.add(data);
  }

  void dispose() {
    _callDataController.close();
  }
}
