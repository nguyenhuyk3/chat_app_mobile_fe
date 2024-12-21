import 'dart:convert';
import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/utils/log.utils.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';

class WebrtcServices {
  final List<Map<String, dynamic>> _pendingCallerIceCandidates = [];
  final List<Map<String, dynamic>> _pendingReceiverIceCandidates = [];
  final List<RTCTrackEvent> _remoteTracks = [];
  bool _isSetRemoteDescriptionForCaller = false;
  bool _isSetRemoteDescriptionForReceiver = false;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final logger = Logger(printer: CustomPrinter());

  WebrtcServices._privateConstructor();

  static final WebrtcServices _instance = WebrtcServices._privateConstructor();

  factory WebrtcServices() {
    return _instance;
  }

  RTCPeerConnection? get peerConnection => _peerConnection;
  MediaStream? get localStream => _localStream;
  List<RTCTrackEvent> get remoteTracks => _remoteTracks;

  Future<void> closeMediaStream(MediaStream stream) async {
    await stream.dispose();
  }

  Future<void> closePeerConnection() async {
    await _peerConnection?.close();
    await _peerConnection?.dispose();
    await _localStream?.dispose();

    _localStream?.getTracks().forEach((track) {
      track.dispose();
    });
    _pendingCallerIceCandidates.clear();
    _pendingReceiverIceCandidates.clear();
    _remoteTracks.clear();
    _isSetRemoteDescriptionForCaller = false;
    _isSetRemoteDescriptionForReceiver = false;
    _peerConnection = null;
    _localStream = null;
  }

  Future<void> _createNewPeerConnection() async {
    _peerConnection = await createPeerConnection(GlobalVar.webrtcConfig);
    _peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      logger.i("ICE connection state (createNewPeerConnection): $state");
      if (state == RTCIceConnectionState.RTCIceConnectionStateClosed ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        logger.i("ICE gathering state (createNewPeerConnection): $state");

        closePeerConnection();
      }
    };
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.microphone,
      Permission.camera,
    ];
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    if (statuses[Permission.microphone]!.isDenied ||
        statuses[Permission.camera]!.isDenied) {
      logger.w("==================================");
      logger.i("_requestPermissions");
      logger.i("User denied permission");
      logger.w("==================================");

      throw Exception(
          "You need to grant permission to continue using this feature");
    }

    if (statuses[Permission.microphone]!.isPermanentlyDenied ||
        statuses[Permission.camera]!.isPermanentlyDenied) {
      logger.w("==================================");
      logger.i("_requestPermissions");
      logger.i("Permanently denied");
      logger.w("==================================");

      await openAppSettings();
      throw Exception(
          "Permission denied. Please enable permissions in settings");
    }

    logger.w("==================================");
    logger.i("_requestPermissions");
    logger.i("All rights reserved");
    logger.w("==================================");
  }

  Future<MediaStream> _getAudioMedia() async {
    final MediaStream stream = await navigator.mediaDevices.getUserMedia({
      'video': false,
      'audio': true,
    });
    return stream;
  }

  Future<MediaStream> _getVideoMedia() async {
    final MediaStream stream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': false,
    });
    return stream;
  }

  Future<MediaStream> _getUserMedia() async {
    final MediaStream stream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': {
        'facingMode': 'user',
      },
    });
    return stream;
  }

  void _sendCandidateToReceiver(
      {required String messageBoxId,
      required String senderId,
      required String receiverId,
      required RTCIceCandidate candidate,
      required String? token,
      required WebSocketChannel channel}) {
    final candidateData = jsonEncode({
      "messageBoxId": messageBoxId,
      "senderId": senderId,
      "receiverId": receiverId,
      if (token != null) "token": token,
      "type": "ice-candidate",
      "candidate": candidate.toMap()
    });

    channel.sink.add(candidateData);
  }

  void _sendOfferToReceiver(
      {required String messageBoxId,
      required String receiverId,
      required String senderId,
      required RTCSessionDescription offer,
      required String? token,
      required String callType,
      required WebSocketChannel channel}) {
    final offerData = jsonEncode(
      {
        "messageBoxId": messageBoxId,
        "senderId": senderId,
        "receiverId": receiverId,
        if (token != null) "token": token,
        "callType": callType,
        "type": "offer",
        "sdp": offer.toMap()
      },
    );

    logger.w("==================================");
    logger.i("_sendOfferToReceiver");
    logger.i(offerData);
    logger.w("==================================");

    channel.sink.add(offerData);
  }

  Future<void> _getMedia({required String callType}) async {
    if (callType == "audio") {
      _localStream = await _getAudioMedia();
    } else if (callType == "video") {
      _localStream = await _getVideoMedia();
    } else {
      _localStream = await _getUserMedia();
    }
  }

  Future<void> switchCamera() async {
    final videoTrack = _localStream?.getVideoTracks().first;
    await videoTrack?.switchCamera();
  }

  Future<void> createOffer(
      {required String callType,
      required String messageBoxId,
      required String senderId,
      required String receiverId,
      required String? token,
      required WebSocketChannel channel}) async {
    await _requestPermissions();
    await Future.wait([
      _createNewPeerConnection(),
      _getMedia(callType: callType),
    ]);

    _isSetRemoteDescriptionForCaller = true;

    localStream?.getTracks().forEach(
      (track) {
        logger.w("==================================");
        logger.i("createOffer");
        logger.i(track);
        logger.w("==================================");
        logger.i("caller");
        logger.i(_peerConnection.hashCode);

        _peerConnection!.addTrack(track, localStream!);
        logger.w("==================================");
      },
    );
    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      // logger.w("==================================");
      // logger.i("sending ice-candidate (createOffer)");
      // logger.w("==================================");

      _sendCandidateToReceiver(
        messageBoxId: messageBoxId,
        senderId: senderId,
        receiverId: receiverId,
        candidate: candidate,
        token: token,
        channel: channel,
      );
    };

    final mediaConstraints = {
      'audio': callType == 'audio' || callType == 'both',
      'video': callType == 'video' || callType == 'both',
    };

    try {
      final offer = await _peerConnection?.createOffer(mediaConstraints);
      await _peerConnection?.setLocalDescription(offer!);

      logger.w("==================================");
      logger.i("sending offer to receiver (createOffer)");
      logger.w("==================================");

      _sendOfferToReceiver(
        messageBoxId: messageBoxId,
        senderId: senderId,
        receiverId: receiverId,
        token: token,
        callType: callType,
        offer: offer!,
        channel: channel,
      );
    } catch (e) {
      logger.e("Error creating offer (createOffer): $e");
    }
  }

  void _sendAnswerToReceiver(
      {required String messageBoxId,
      required String senderId,
      required String receiverId,
      required RTCSessionDescription answer,
      required String? token,
      required WebSocketChannel channel}) {
    final answerData = jsonEncode(
      {
        "messageBoxId": messageBoxId,
        "senderId": senderId,
        "receiverId": receiverId,
        if (token != null) "token": token,
        "type": "answer",
        "sdp": answer.toMap(),
      },
    );
    logger.w("==================================");
    logger.i("sending answer to receiver (_sendAnswerToReceiver)");
    logger.i(answerData);
    logger.w("==================================");

    channel.sink.add(answerData);
  }

  Future<void> handleOffer(
      {required String callType,
      required String messageBoxId,
      required String senderId,
      required String receiverId,
      required String? token,
      required RTCSessionDescription offer,
      required WebSocketChannel channel}) async {
    try {
      if (peerConnection == null) {
        await _createNewPeerConnection();
      }
      _peerConnection?.onTrack = (event) {
        if (event.track.kind == 'video' || event.track.kind == 'audio') {
          logger.w("==================================");
          logger.i("(remote) handleOffer");
          logger.i(event.track.kind);
          logger.w("==================================");

          _remoteTracks.add(event);
        }
      };
      await _getMedia(callType: callType);

      localStream?.getTracks().forEach((track) {
        logger.w("==================================");
        logger.i("handleOffer");
        logger.i(track);
        logger.w("==================================");
        logger.i("receiver");
        logger.i(_peerConnection.hashCode);

        _peerConnection!.addTrack(track, localStream!);

        logger.w("==================================");
      });
      _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        _sendCandidateToReceiver(
            messageBoxId: messageBoxId,
            senderId: senderId,
            receiverId: receiverId,
            candidate: candidate,
            token: token,
            channel: channel);
      };

      await _peerConnection
          ?.setRemoteDescription(RTCSessionDescription(offer.sdp, "offer"));
      _isSetRemoteDescriptionForReceiver = true;

      final answer = await _peerConnection?.createAnswer();
      await _peerConnection?.setLocalDescription(answer!);

      _sendAnswerToReceiver(
        messageBoxId: messageBoxId,
        senderId: senderId,
        receiverId: receiverId,
        token: token,
        answer: answer!,
        channel: channel,
      );

      // int count = 0;
      for (final candidateData in _pendingReceiverIceCandidates) {
        final candidate = RTCIceCandidate(
          candidateData['candidate'],
          candidateData['sdpMid'] ?? '',
          candidateData['sdpMLineIndex'] ?? 0,
        );
        logger.i("(handleOffer) Add candidate");
        await _peerConnection?.addCandidate(candidate);
        // count++;
      }
      // logger.i("count:  $count");
      _pendingReceiverIceCandidates.clear();
    } catch (e) {
      logger.e("Error handling offer (handleOffer): $e");
    }
  }

  Future<void> handleAnswer(
      {required Map<String, dynamic> answerData,
      required RTCPeerConnection? peerConnection}) async {
    try {
      final answer = RTCSessionDescription(
        answerData['sdp'],
        answerData['type'],
      );
      await peerConnection?.setRemoteDescription(answer);

      Future.delayed(const Duration(seconds: 1), () async {
        if (_isSetRemoteDescriptionForCaller) {
          // int count = 0;
          for (final candidateData in _pendingCallerIceCandidates) {
            final candidate = RTCIceCandidate(
              candidateData['candidate'],
              candidateData['sdpMid'] ?? '',
              candidateData['sdpMLineIndex'] ?? 0,
            );
            logger.i("(handleAnswer) Add candidate");
            await _peerConnection?.addCandidate(candidate);
            // count++;
          }
          // logger.i("count:  $count");
          _pendingCallerIceCandidates.clear();
        }
      });
    } catch (e) {
      logger.e("Error handling answer (handleAnswer): $e");
    }
  }

  Future<void> handleNewICECandidate(
      {required Map<String, dynamic> candidateData}) async {
    try {
      if (_peerConnection == null) {
        await _createNewPeerConnection();
      }
      // final candidate = RTCIceCandidate(
      //   candidateData['candidate'],
      //   candidateData['sdpMid'] ?? '',
      //   candidateData['sdpMLineIndex'] ?? 0,
      // );
      if (_isSetRemoteDescriptionForReceiver == false) {
        _pendingReceiverIceCandidates.add(candidateData);
      }
      if (_isSetRemoteDescriptionForCaller == true) {
        _pendingCallerIceCandidates.add(candidateData);
      }
    } catch (e) {
      // _pendingIceCandidates.add(candidateData);
      logger.e("Error handling ICE Candidate (handleNewICECandidate): $e");
    }
  }
}
