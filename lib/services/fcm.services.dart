import 'package:chat_app_mobile_fe/main.dart';
import 'package:chat_app_mobile_fe/screens/chat/chat_displayer_sceen.dart';
import 'package:chat_app_mobile_fe/utils/log.utils.dart';
import 'package:chat_app_mobile_fe/widgets/home/notification.widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

class FCMService {
  final logger = Logger(printer: CustomPrinter());
  final GlobalKey<NavigatorState> _navigatorKey;

  FCMService({required GlobalKey<NavigatorState> navigatorKey})
      : _navigatorKey = navigatorKey;

  // final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _isNotificationVisible = false;
  late OverlayEntry _notificationOverlay;
  // late final FCMService _fcmService;

  OverlayEntry _createOverlayEntry(
    String title,
    String body,
    String senderAvatar,
  ) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 10,
        right: 10,
        child: AnimatedOpacity(
          opacity: _isNotificationVisible ? 1.0 : 0.0,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
          child: NotificationWidget(
            title: title,
            body: body,
            senderAvatar: senderAvatar,
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(RemoteMessage message) async {
    final messageBoxId = message.data['messageBoxId'];
    final receiverId = message.data['receiverId'];
    final token = message.data['token'];
    final userName = message.data['userName'];

    Navigator.of(_navigatorKey.currentContext!).push(MaterialPageRoute(
      builder: (context) => ChatDisplayerScreen(
        messageBoxId: messageBoxId,
        receiverId: receiverId,
        token: token,
        userName: userName,
        isCallAtForeground: false,
      ),
    ));
  }

  void _showNotification(
    GlobalKey<NavigatorState> navigatorKey, {
    required String title,
    required String body,
    required String senderAvatar,
  }) {
    if (_isNotificationVisible) {
      return;
    }

    _isNotificationVisible = true;
    _notificationOverlay = _createOverlayEntry(title, body, senderAvatar);

    final overlay = navigatorKey.currentState?.overlay;

    if (overlay != null) {
      overlay.insert(_notificationOverlay);
    }

    Future.delayed(const Duration(seconds: 3), () {
      _notificationOverlay.remove();
      _isNotificationVisible = false;
    });
  }

  static Future<void> _showCallNotification(RemoteMessage message) async {
    final data = message.data;
    final callerName = data['caller_name'] ?? 'Unknown Caller';
    final avatarUrl = data['avatar_url'] ?? '';

    const androidDetails = AndroidNotificationDetails(
      'call_channel', // ID kênh
      'Call Notifications', // Tên kênh
      channelDescription: 'Thông báo cuộc gọi',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      styleInformation: BigPictureStyleInformation(
        DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      ),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'accept_call', // ID nút
          'Accept',
          icon: DrawableResourceAndroidBitmap('accept'),
        ),
        AndroidNotificationAction(
          'decline_call',
          'Decline',
          icon: DrawableResourceAndroidBitmap('cancel'),
        ),
      ],
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // ID thông báo
      'Incoming Call', // Tiêu đề
      '$callerName is calling...', // Nội dung
      notificationDetails,
      payload: avatarUrl,
    );
  }

  void setupFCM(GlobalKey<NavigatorState> navigatorKey) {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(
        navigatorKey,
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        senderAvatar: message.data['senderAvatar'] ?? '',
      );
    });
    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data["type"] == "") {
        _handleNotificationTap(message);
      }
    });
  }
}
