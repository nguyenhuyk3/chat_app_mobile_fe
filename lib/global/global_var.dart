class GlobalVar {
  static const String httpBaseUrl = "http://192.168.1.7:8080";
  static const String websocketBaseUrl = "ws://192.168.1.7:8080/ws";
  static const String keyJoinRoom =
      "anhiuemlove33333!@#@#@!!!****&(*&@(^&*()concak";
  static const Map<String, dynamic> webrtcConfig = {
    'iceServers': [
      {
        'urls': [
          'stun:stun.l.google.com:19302',
          'stun:stun1.l.google.com:19302'
        ]
      }
    ],
    'sdpSemantics': 'unified-plan'
  };
}
