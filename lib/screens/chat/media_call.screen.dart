import 'dart:async';
import 'package:chat_app_mobile_fe/services/chat.services.dart';
import 'package:chat_app_mobile_fe/services/stream.services.dart';
import 'package:chat_app_mobile_fe/services/webrtc.services.dart';
import 'package:chat_app_mobile_fe/utils/check_date.util.dart';
import 'package:chat_app_mobile_fe/utils/log.utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MediaCallScreen extends StatefulWidget {
  final RTCPeerConnection? peerConnection;
  final WebSocketChannel? channel;
  final String? callType;
  final String messageBoxId;
  final String? realSenderId;
  final String senderId;
  final String receiverId;
  final String receiverName;
  final String? token;
  final String? receiverAvatarUrl;
  final bool isDialing;
  final bool isAtForeground;

  const MediaCallScreen({
    super.key,
    required this.peerConnection,
    required this.channel,
    this.callType,
    required this.messageBoxId,
    this.realSenderId,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.token,
    this.receiverAvatarUrl,
    this.isDialing = true,
    required this.isAtForeground,
  });

  @override
  State<MediaCallScreen> createState() => _MediaCallScreenState();
}

class _MediaCallScreenState extends State<MediaCallScreen> {
  final _streamServices = StreamServics();
  StreamSubscription? _streamSubscription;
  Timer? _timerForCallTime;
  int _secondsElapsed = 0;
  Timer? _timerForMissedCall;
  int _missedCallTime = 0;
  late RTCVideoRenderer _localRenderer;
  late RTCVideoRenderer _remoteRenderer;
  bool _isDialing = true;
  bool _isMicOn = true;
  bool _isLocalCameraOn = true;
  bool _isRemoteCameraOn = false;
  bool _isReceiver = false;
  bool _isRun = false;
  final Logger logger = Logger(printer: CustomPrinter());

  @override
  void initState() {
    super.initState();

    logger.w("==================================");
    logger.i("initState");
    logger.i(_isDialing);
    logger.w("==================================");

    _streamSubscription = _streamServices.callDataController.listen((data) {
      logger.w("==================================");
      logger.i("initState");
      logger.i(data);
      logger.w("==================================");
      setState(() {
        if (data.containsKey("content")) {
          _isRemoteCameraOn = !_isRemoteCameraOn;
        } else if (data["type"] == "completed-media-call-signal") {
          Navigator.pop(context);
          if (_isReceiver && !widget.isAtForeground) {
            Navigator.pop(context);
          }
          dispose();
        } else if (data["type"] == "declined-media-call-signal") {
          Navigator.pop(context);
        }
      });
    });

    if (widget.realSenderId != null) {
      _startTimerForMissedCall();
    }
    _initializeRenderers();
  }

  void _startTimer() {
    _timerForCallTime = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
        logger.e(_secondsElapsed);
      });
    });
  }

  Future<void> _sendMissMediaCall({required String type}) async {
    late final String content;
    if (type == "missed-media-call-signal") {
      content = "Đã bỏ lỡ cuộc gọi";
    } else if (type == "missed-media-call") {
      content = "Đã bỏ lỡ cuộc gọi";
    }

    ChatServices.sendMessage(
      senderId: widget.senderId,
      receiverId: widget.receiverId,
      token: widget.token,
      messageBoxId: widget.messageBoxId,
      content: content,
      type: type,
      channel: widget.channel!,
    );
  }

  void _startTimerForMissedCall() {
    _timerForMissedCall = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_missedCallTime == 10) {
        setState(() {
          _sendMissMediaCall(type: "missed-media-call-signal").then((_) => {
                _sendMissMediaCall(type: "missed-media-call"),
                WebrtcServices().closePeerConnection(),
                Navigator.pop(context),
              });
          return;
        });
      }
      if (_missedCallTime < 10 && !_isDialing) {
        _timerForMissedCall?.cancel();
        return;
      }
      _missedCallTime++;
    });
  }

  Future<void> _initializeRenderers() async {
    _localRenderer = RTCVideoRenderer();
    _remoteRenderer = RTCVideoRenderer();

    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    final localStream = WebrtcServices().localStream;

    setState(() {
      _localRenderer.srcObject = localStream;
    });

    // logger.w("==================================");
    // logger.i("_initializeRenderers");
    // logger.i(WebrtcServices().peerConnection.hashCode);
    // logger.w("==================================");

    // This case will be performed at receiver
    logger.e(WebrtcServices().remoteTracks.isNotEmpty);
    if (WebrtcServices().remoteTracks.isNotEmpty) {
      _isReceiver = true;
      _isDialing = false;
      _startTimer();

      for (var track in WebrtcServices().remoteTracks) {
        if (track.track.kind == 'video') {
          _isRemoteCameraOn = !_isRemoteCameraOn;
        }

        setState(() {
          _remoteRenderer.srcObject = track.streams[0];
          // logger.w("==================================");
          // logger.i("(remote) (receiver) _initializeRenderers");
          // logger.i(track.track.kind);
          // logger.w("==================================");
        });
      }
    }
    // This case will be performed at caller
    else {
      widget.peerConnection?.onTrack = (event) {
        if (event.track.kind == "video" || event.track.kind == "audio") {
          _isDialing = false;

          if (!_isRun) {
            _startTimer();
            _isRun = !_isRun;
          }
          if (event.track.kind == "video") {
            _isRemoteCameraOn = !_isRemoteCameraOn;
          }

          setState(() {
            _remoteRenderer.srcObject = event.streams[0];
            // logger.w("==================================");
            // logger.i("(remote) (caller) _initializeRenderers");
            // logger.i(event.track.kind);
            // logger.w("==================================");
          });
        }
      };
    }
  }

  void _toggleMic() async {
    setState(() {
      _isMicOn = !_isMicOn;

      final audio = _localRenderer.srcObject?.getAudioTracks()[0];
      if (audio != null) {
        audio.enabled = _isMicOn;
      }
    });
  }

  Future<void> _sendToggleAction({required String content}) async {
    ChatServices.sendMessage(
      senderId: widget.senderId,
      receiverId: widget.receiverId,
      token: widget.token,
      messageBoxId: widget.messageBoxId,
      content: content,
      type: "toggle-action",
      channel: widget.channel!,
    );
  }

  void _toggleCamera({required String content}) async {
    await _sendToggleAction(content: content);
    setState(() {
      _isLocalCameraOn = !_isLocalCameraOn;

      final camera = _localRenderer.srcObject?.getVideoTracks()[0];
      if (camera != null) {
        camera.enabled = _isLocalCameraOn;
      }
    });
  }

  Future<void> _sendCompletedMediaCall(
      {required String type, required String senderId}) async {
    late final String content;
    if (type == "completed-media-call-signal") {
      content = "Cuộc gọi đã kết thúc";
    } else if (type == "completed-media-call") {
      content =
          "Cuộc gọi đã kéo dài ${CheckDate.formatDuration(_secondsElapsed)}";
    }

    ChatServices.sendMessage(
      senderId: senderId,
      receiverId: widget.receiverId,
      token: widget.token,
      messageBoxId: widget.messageBoxId,
      content: content,
      type: type,
      channel: widget.channel!,
    );
  }

  @override
  void dispose() {
    _isDialing = true;
    _isMicOn = true;
    _isLocalCameraOn = true;
    _isRemoteCameraOn = false;
    _isReceiver = false;
    _isRun = false;
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _streamSubscription?.cancel();
    _timerForCallTime?.cancel();
    _timerForMissedCall?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isRemoteCameraOn)
            // Remote video (full screen)
            Positioned.fill(
              child: RTCVideoView(
                _remoteRenderer,
                mirror: true,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            )
          else
            Container(
              color: const Color(0xFF303841),
              child: Positioned(
                top: 200,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        backgroundImage: widget.receiverAvatarUrl != null
                            ? NetworkImage(
                                widget.receiverAvatarUrl!,
                              )
                            : null,
                        child: widget.receiverAvatarUrl == null
                            ? const Icon(
                                Icons.account_circle,
                                size: 100,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.receiverName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isDialing
                            ? "Đang gọi..."
                            : CheckDate.formatDuration(_secondsElapsed),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_isLocalCameraOn && widget.callType == "both")
            // Local video (small overlay at the top-right corner)
            Positioned(
              top: 50,
              right: 30,
              width: 120,
              height: 160,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 0.4),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: RTCVideoView(
                  _localRenderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
          // Bottom controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Video
                  if (widget.callType == "both")
                    _buildControlButton(
                      icon: _isLocalCameraOn
                          ? Icons.videocam_sharp
                          : Icons.videocam_off_sharp,
                      onPressed: () async {
                        _toggleCamera(content: "toggle-camera");
                      },
                    ),
                  // Mirco
                  _buildControlButton(
                    icon: _isMicOn
                        ? Icons.mic_none_outlined
                        : Icons.mic_off_outlined,
                    onPressed: _toggleMic,
                  ),
                  if (_isLocalCameraOn)
                    _buildControlButton(
                      icon: Icons.switch_camera,
                      onPressed: WebrtcServices().switchCamera,
                    )
                  else
                    _buildControlButton(
                      icon: Icons.switch_camera,
                      onPressed: null,
                      color: Colors.grey,
                    ),
                  _buildControlButton(
                    icon: Icons.call_end,
                    onPressed: () {
                      _sendCompletedMediaCall(
                              type: "completed-media-call-signal",
                              senderId: widget.senderId)
                          .then((_) => {
                                if (widget.realSenderId == null)
                                  {
                                    _sendCompletedMediaCall(
                                      type: "completed-media-call",
                                      senderId: widget.receiverId,
                                    ),
                                  }
                                else
                                  {
                                    _sendCompletedMediaCall(
                                      type: "completed-media-call",
                                      senderId: widget.realSenderId!,
                                    ),
                                  },
                                WebrtcServices().closePeerConnection(),
                                Navigator.pop(context),
                                if (_isReceiver && !widget.isAtForeground)
                                  {
                                    Navigator.pop(context),
                                  },
                              });
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      {required IconData icon,
      required VoidCallback? onPressed,
      Color color = Colors.white}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.2),
        ),
        child: Icon(
          icon,
          color: color,
          size: 32,
        ),
      ),
    );
  }
}
