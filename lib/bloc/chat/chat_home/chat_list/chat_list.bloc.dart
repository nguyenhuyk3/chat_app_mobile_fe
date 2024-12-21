// ignore_for_file: avoid_print

import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.event.dart';
import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.state.dart';
import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/main.dart';
import 'package:chat_app_mobile_fe/models/response/all_message_boxes.response.dart';
import 'package:chat_app_mobile_fe/models/response/last_state_for_message_box_on_master_room.response.dart';
import 'package:chat_app_mobile_fe/services/chat.services.dart';
import 'package:chat_app_mobile_fe/services/webrtc.services.dart';
import 'package:chat_app_mobile_fe/utils/log.utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final Logger logger = Logger(printer: CustomPrinter());
  late WebSocketChannel _channel;
  late String? _userId;

  String? get userId => _userId;
  WebSocketChannel? get channel => _channel;

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
      // Handle background actions
      // onDidReceiveBackgroundNotificationResponse:
      //     _onBackgroundNotificationResponse,
    );
  }

  void refreshChatList() {
    add(LoadMessageBoxes());
  }

  Future<void> _initUserId() async {
    _userId = await SharedPreferencesHelper.getUserId();
  }

  ChatListBloc() : super(ChatInitial()) {
    Future.wait([
      _initializeNotifications(),
      _initUserId(),
    ]).then((_) => add(LoadMessageBoxes()));

    on<LoadMessageBoxes>(_onLoadMessageBoxes);
    on<UpdateOnlineFriends>(_onUpdateOnlineFriends);
    on<UpdateFriendStatus>(_onUpdateFriendStatus);
    on<UpdateLastStateForMessageBox>(_onUpdateLastStateForMessageBox);
    on<MarkMessageAsRead>(_onMarkMessageAsRead);
    on<IncommingOffer>(_onIncommingOffer);
    on<HandleNotificationAction>(_onHandleNotificationAction);
    on<NavigateToCallScreen>(_onNavigateToCallScreen);

    @override
    Future<void> close() async {
      _channel.sink.close();
      await super.close();
    }
  }

  void _initializeWebSocket() {
    String url =
        "${GlobalVar.websocketBaseUrl}/join_master_room?user_id=$_userId";

    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    _channel.stream.listen((dynamic data) {
      if (isClosed) return;

      final jsonData = jsonDecode(data);

      logger.w("==================================");
      logger.i("_initializeWebSocket");
      logger.i(jsonData);
      logger.w("==================================");

      if (jsonData["type"] == "onlineFriends") {
        add(UpdateOnlineFriends(
          friends: List<String>.from(jsonData["friends"]),
        ));
      } else if (jsonData["isOnline"] != null) {
        add(UpdateFriendStatus(
          userId: jsonData["userId"],
          isOnline: jsonData["isOnline"],
          tokenDevice: jsonData["tokenDevice"],
        ));
      } else if (jsonData["isLastStateStruct"] != null) {
        add(UpdateLastStateForMessageBox(
          lastStateForMessageBoxOnMasterRoom:
              LastStateForMessageBoxOnMasterRoom.fromJson(jsonData),
        ));
      } else if (jsonData["fromUserEmail"] != null &&
          jsonData["fromUserName"] != null) {
        add(LoadMessageBoxes());
      } else if (jsonData["type"] == "offer") {
        final sdp = jsonData["sdp"];
        final offer = RTCSessionDescription(sdp["sdp"], sdp["type"]);
        add(IncommingOffer(
          messageBoxId: jsonData["messageBoxId"],
          senderId: jsonData["senderId"],
          offer: offer,
          callType: jsonData["callType"],
          token: jsonData["token"],
          senderName: jsonData["senderName"],
        ));
      } else if (jsonData["type"] == "ice-candidate") {
        WebrtcServices().handleNewICECandidate(
          candidateData: jsonData["candidate"],
        );
      }
    });
  }

  // * This function will sort the message boxes
  // * based on last tine in "Last State" in every message box
  void _sortMessageBox({
    required List<MessageBoxResponse> messageBoxes,
    required String userId,
  }) {
    // print(
    //     "Before sorting: ${messageBoxes.map((box) => userId == box.lastStateMessageForFirstUser.userId ? box.lastStateMessageForFirstUser.toJson() : box.lastStateMessageForSecondUser.toJson())}");
    messageBoxes.sort((a, b) {
      DateTime getLastTime(MessageBoxResponse box) {
        final lastState = box.lastStateMessageForFirstUser.userId == userId
            ? box.lastStateMessageForFirstUser
            : box.lastStateMessageForSecondUser;
        return DateTime.parse(lastState.lastTime);
      }

      return getLastTime(b).compareTo(getLastTime(a));
    });
    // print(
    //     "After sorting: ${messageBoxes.map((box) => userId == box.lastStateMessageForFirstUser.userId ? box.lastStateMessageForFirstUser.toJson() : box.lastStateMessageForSecondUser.toJson())}");
  }

  Future<void> _onLoadMessageBoxes(
      LoadMessageBoxes event, Emitter<ChatListState> emit) async {
    final String url =
        "${GlobalVar.httpBaseUrl}/users/get_all_message_boxes?user_id=$_userId";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final List<MessageBoxResponse> messageBoxes =
            MessageBoxResponse.parseJsonDataToList(jsonData);

        _sortMessageBox(messageBoxes: messageBoxes, userId: _userId!);
        print("Emitting ChatLoaded state");
        emit(ChatLoaded(messageBoxes: messageBoxes, onlineFriendIds: {}));
        _initializeWebSocket();
      }
    } catch (error) {
      logger.e("Error fetching message boxes (_onLoadMessageBoxes): $error");
    }
  }

  void _onUpdateOnlineFriends(
      UpdateOnlineFriends event, Emitter<ChatListState> emit) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(
        ChatLoaded(
            messageBoxes: currentState.messageBoxes,
            onlineFriendIds: event.friends.toSet()),
      );
    }
  }

  void _onUpdateFriendStatus(
      UpdateFriendStatus event, Emitter<ChatListState> emit) {
    final currentState = state;

    if (currentState is ChatLoaded) {
      final updatedFriends = Set<String>.from(currentState.onlineFriendIds);
      if (event.isOnline) {
        updatedFriends.add(event.userId);
      } else {
        updatedFriends.remove(event.userId);
      }
      emit(ChatLoaded(
          messageBoxes: currentState.messageBoxes,
          onlineFriendIds: updatedFriends,
          onlineUserId: event.userId));
    }
  }

 void _onUpdateLastStateForMessageBox(
    UpdateLastStateForMessageBox event, Emitter<ChatListState> emit) {
  final currentState = state;

  if (currentState is ChatLoaded) {
    final String messageBoxId =
        event.lastStateForMessageBoxOnMasterRoom.messageBoxId;
    final lastState = event.lastStateForMessageBoxOnMasterRoom;

    // Create a new list of message boxes
    final updatedMessageBoxes = currentState.messageBoxes.map((messageBox) {
      if (messageBox.messageBoxId == messageBoxId) {
        // Create copies of the message box and its nested objects
        final updatedMessageBox = messageBox.copyWith(
          lastStateMessageForFirstUser: messageBox.lastStateMessageForFirstUser.userId == _userId
              ? messageBox.lastStateMessageForFirstUser.copyWith(
                  lastMessage: lastState.lastMessage,
                  lastTime: lastState.lastTime,
                  lastStatus: lastState.lastStatus,
                )
              : messageBox.lastStateMessageForFirstUser,
          lastStateMessageForSecondUser: messageBox.lastStateMessageForSecondUser.userId == _userId
              ? messageBox.lastStateMessageForSecondUser.copyWith(
                  lastMessage: lastState.lastMessage,
                  lastTime: lastState.lastTime,
                  lastStatus: lastState.lastStatus,
                )
              : messageBox.lastStateMessageForSecondUser,
        );
        return updatedMessageBox;
      } else {
        return messageBox;
      }
    }).toList();

    _sortMessageBox(messageBoxes: updatedMessageBoxes, userId: _userId!);

    emit(ChatLoaded(
      messageBoxes: updatedMessageBoxes,
      onlineFriendIds: currentState.onlineFriendIds,
    ));
  }
}


  void _onMarkMessageAsRead(
      MarkMessageAsRead event, Emitter<ChatListState> emit) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      String messageBoxId = event.messageBoxId;
      for (var messageBox in currentState.messageBoxes) {
        if (messageBox.messageBoxId == messageBoxId) {
          final String firstUserId =
              messageBox.lastStateMessageForFirstUser.userId;
          final targetUser = firstUserId == event.userId
              ? messageBox.lastStateMessageForFirstUser
              : messageBox.lastStateMessageForSecondUser;
          targetUser.lastStatus = "đã đọc";

          break;
        }
      }
    }
  }

  Future<void> _showIncomingOfferNotification(IncommingOffer event) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'offer_channel_id',
      'Offer Notifications',
      // channelDescription: 'Thông báo khi có cuộc gọi đến',
      importance: Importance.max,
      priority: Priority.high,
      // ticker: 'ticker',
      fullScreenIntent: true,
      category: AndroidNotificationCategory.call,
      // Don't allow swipe to delete
      ongoing: true,
      // No auto delete when pressed
      autoCancel: false,
      timeoutAfter: 10000,
      icon: '@mipmap/ic_launcher',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('reject_offer', 'Từ chối',
            showsUserInterface: true),
        AndroidNotificationAction("answer_offer", 'Trả lời',
            showsUserInterface: true),
      ],
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      // Message ID (can use messageBoxId)
      event.messageBoxId.hashCode,
      'Cuộc gọi từ ${event.senderName}',
      event.callType == "both" ? "Cuộc gọi video đến" : "Cuộc gọi thoại đến",
      platformChannelSpecifics,
      payload: jsonEncode({
        "messageBoxId": event.messageBoxId,
        "senderId": event.senderId,
        "callType": event.callType,
        "token": event.token,
        "senderName": event.senderName,
        "senderAvartarUrl": event.senderAvartarUrl ?? "",
        "sdp": {
          "type": event.offer.type,
          "sdp": event.offer.sdp,
        },
      }),
    );
  }

  Future<void> _onIncommingOffer(
      IncommingOffer event, Emitter<ChatListState> emit) async {
    // Show notification
    await _showIncomingOfferNotification(event);
  }

  Future<void> _sendDeclinedMessage(
      {required Map<String, dynamic> data, required String type}) async {
    ChatServices.sendMessage(
      senderId: data["senderId"],
      receiverId: userId!,
      token: data["token"],
      messageBoxId: data["messageBoxId"],
      content: "Cuộc gọi đã bị từ chối",
      type: type,
      channel: channel!,
    );
  }

  Future<void> _onNotificationResponse(NotificationResponse response) async {
    final String? actionId = response.actionId;
    final String? payload = response.payload;
    final Map<String, dynamic> data = jsonDecode(payload!);

    logger.e(actionId);
    logger.e(data);

    switch (actionId) {
      case "reject_offer":
        _sendDeclinedMessage(data: data, type: "declined-media-call-signal")
            .then((_) => {
                  _sendDeclinedMessage(
                      data: data, type: "declined-media-call-at-foreground"),
                });
      case "answer_offer":
        final sdp = data["sdp"];
        final offer = RTCSessionDescription(sdp["sdp"], sdp["type"]);
        await WebrtcServices().handleOffer(
          callType: data["callType"],
          messageBoxId: data["messageBoxId"],
          senderId: _userId!,
          receiverId: data["senderId"],
          token: data["token"],
          offer: offer,
          channel: _channel,
        );
        // ignore: invalid_use_of_visible_for_testing_member
        emit(CallInitiated(
          peerConnection: WebrtcServices().peerConnection!,
          channel: _channel,
          messageBoxId: data["messageBoxId"],
          senderId: data["senderId"],
          receiverId: _userId!,
          receiverName: data["senderName"],
          token: data["token"],
        ));
        break;
    }
  }

  Future<void> _onHandleNotificationAction(
      HandleNotificationAction event, Emitter<ChatListState> emit) async {
    if (event.action == 'reject') {
      // Xử lý từ chối cuộc gọi
      await _rejectCall(event.messageBoxId, event.senderId, event.callType);
    } else if (event.action == 'answer') {
      // Xử lý trả lời cuộc gọi
      await _answerCall(event.messageBoxId, event.senderId, event.callType);
    }
  }

  Future<void> _rejectCall(
      String messageBoxId, String senderId, String callType) async {
    // Gửi yêu cầu từ chối cuộc gọi đến server
    try {
      final response = await http.post(
        Uri.parse('${GlobalVar.httpBaseUrl}/call/reject'),
        body: {
          'messageBoxId': messageBoxId,
          'senderId': senderId,
          // Thêm các thông tin cần thiết khác
        },
      );

      if (response.statusCode == 200) {
        // Thành công, có thể cập nhật state hoặc thông báo cho người dùng
        logger.i('Đã từ chối cuộc gọi thành công.');
      } else {
        // Xử lý lỗi
        logger.e('Lỗi khi từ chối cuộc gọi: ${response.body}');
      }
    } catch (e) {
      logger.e('Exception khi từ chối cuộc gọi: $e');
    }
  }

  Future<void> _answerCall(
      String messageBoxId, String senderId, String callType) async {
    // Gửi yêu cầu trả lời cuộc gọi hoặc mở giao diện cuộc gọi
    try {
      final response = await http.post(
        Uri.parse('${GlobalVar.httpBaseUrl}/call/answer'),
        body: {
          'messageBoxId': messageBoxId,
          'senderId': senderId,
          'callType': callType,
          // Thêm các thông tin cần thiết khác
        },
      );

      if (response.statusCode == 200) {
        // Thành công, mở giao diện cuộc gọi hoặc cập nhật state
        logger.i('Đã trả lời cuộc gọi thành công.');
        // Ví dụ: Điều hướng tới màn hình cuộc gọi
        // Tuy nhiên, trong Bloc bạn không nên điều hướng trực tiếp.
        // Bạn có thể sử dụng một cơ chế khác như gọi callback hoặc sử dụng một thư viện để điều hướng từ Bloc.
      } else {
        // Xử lý lỗi
        logger.e('Lỗi khi trả lời cuộc gọi: ${response.body}');
      }
    } catch (e) {
      logger.e('Exception khi trả lời cuộc gọi: $e');
    }
  }

  @pragma('vm:entry-point') // Đảm bảo hàm này có thể gọi được từ nền
  void _onBackgroundNotificationResponse(NotificationResponse response) {
    // Vì Bloc không tồn tại khi ứng dụng đang nền hoặc bị đóng,
    // bạn cần triển khai một cách để xử lý hành động, có thể gọi API trực tiếp.

    final String? actionId = response.actionId;
    final String? payload = response.payload;

    if (payload == null) return;

    final Map<String, dynamic> data = jsonDecode(payload);

    final String messageBoxId = data['messageBoxId'];
    final String senderId = data['senderId'];
    final String callType = data['callType'];

    if (actionId == 'reject') {
      // Gọi API từ chối cuộc gọi
      // Vì không có quyền truy cập Bloc ở nền, bạn có thể sử dụng một thư viện như `workmanager` hoặc `flutter_background` để thực hiện.
    } else if (actionId == 'answer') {
      // Gọi API trả lời cuộc gọi hoặc mở giao diện cuộc gọi
      // Tương tự như trên
    }
  }

  Future<void> _onNavigateToCallScreen(
      NavigateToCallScreen event, Emitter<ChatListState> emit) async {
    // Gửi thông báo hoặc cập nhật state để UI điều hướng
    // Ví dụ: emit một state mới hoặc sử dụng một Stream để giao tiếp
  }
}
