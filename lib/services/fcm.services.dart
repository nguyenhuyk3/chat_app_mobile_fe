
import 'package:chat_app_mobile_fe/screens/chat/chat_displayer_sceen.dart';
import 'package:chat_app_mobile_fe/widgets/home/notification.widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMService {
  final GlobalKey<NavigatorState> _navigatorKey;

  FCMService({required GlobalKey<NavigatorState> navigatorKey})
      : _navigatorKey = navigatorKey;

  late final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _isNotificationVisible = false;
  late OverlayEntry _notificationOverlay;
  late final FCMService _fcmService;

  void setupFCM(GlobalKey<NavigatorState> navigatorKey) {
    // Foreground
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        _showNotification(
          navigatorKey,
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          senderAvatar: message.data['senderAvatar'] ?? '',
        );
      },
    );
    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });
  }

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

    Future.delayed(
      const Duration(seconds: 3),
      () {
        _notificationOverlay.remove();
        _isNotificationVisible = false;
      },
    );
  }

  void _handleNotificationTap(RemoteMessage message) async {
    final messageBoxId = message.data['messageBoxId'];
    final receiverId = message.data['receiverId'];
    final token = message.data['token'];
    final userName = message.data['userName'];

    Navigator.of(_navigatorKey.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => ChatDisplayerScreen(
          messageBoxId: messageBoxId,
          receiverId: receiverId,
          token: token,
          userName: userName,
        ),
      ),
    );
  }
}
