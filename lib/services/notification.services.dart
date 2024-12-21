// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/collections/token_device.collection.dart';
import 'package:chat_app_mobile_fe/services/chat.services.dart';
import 'package:chat_app_mobile_fe/services/webrtc.services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ChatServices _chatServices = ChatServices();
  String? _userId;

  Future<void> saveTokenDevice() async {
    try {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null) {
        throw Exception('Không thể lấy FCM token.');
      }

      _userId = await SharedPreferencesHelper.getUserId();
      final tokenDevice = TokenDevice(userId: _userId!, token: fcmToken);
      const url = "${GlobalVar.httpBaseUrl}/notifications/save_token";

      SharedPreferencesHelper.saveTokenDevice(fcmToken);

      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-type': 'application/json',
          },
          body: jsonEncode(
            tokenDevice.toJson(),
          ));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Thông báo: $responseData');
      } else {
        print(
          'Lỗi từ server: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Lưu token thất bại với mã: ${response.statusCode}');
      }
    } catch (error) {
      print('Lỗi khi lưu token: $error');
    }
  }

  Future<void> deleteToken() async {
    const url = "${GlobalVar.httpBaseUrl}/notifications/delete_token";
    final String? userId = await SharedPreferencesHelper.getUserId();
    final Map<String, String> request = {"userId": userId!};
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-type': 'application/json',
          },
          body: jsonEncode(request));
      if (response.statusCode == 200) {
        print('Returned data: ${response.body}');
      } else {
        print(
            'Request post failing post with the status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurs (deleteToken): $error');
    }
  }

  Future<String?> getTokenByUserId({required String userId}) async {
    final url =
        "${GlobalVar.httpBaseUrl}/notifications/get_token_by_user_id?user_id=$userId";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData["token"];
      } else {
        print(
          'Error from server: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (error) {
      print('Error when getting token: $error');
      return null;
    }
  }

  Future<void> showCallNotification({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    required RemoteMessage message,
  }) async {
    final data = message.data;
    final callerName = data["userName"] ?? "Vô danh";
    // final avatarUrl = data["avatar_url"] ?? "";

    const androidDetails = AndroidNotificationDetails(
      'call_channel_id', //Channel ID
      'Incomming Call', // Channel Name
      // channelDescription: 'Thông báo cuộc gọi',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.call,
      ongoing: true, // Don't allow swipe to delete
      autoCancel: false, // No auto delete when pressed
      timeoutAfter: 10000,
      icon: '@mipmap/ic_launcher',
      // playSound: true,
      // sound: RawResourceAndroidNotificationSound('j97'),
      // enableLights: true,
      // enableVibration: true,
      // styleInformation: BigPictureStyleInformation(
      //   DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      // ),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('reject', 'Từ chối'),
        AndroidNotificationAction('answer', 'Trả lời'),
      ],
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'PingMe!!', // Title
      '$callerName đang gọi', // Content
      notificationDetails,
      // payload: avatarUrl,
    );

    // Automatically cancel notification after 10 seconds if no action is selected.
    await Future.delayed(const Duration(seconds: 10));
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  // void handleNotificationAction(NotificationResponse response) {
  //   final String? actionId = response.actionId;

  //   if (actionId == 'reject') {
  //   } else if (actionId == 'answer') {
  //     // Xử lý khi người dùng chọn "Trả lời"
  //     print('Cuộc gọi được chấp nhận.');
  //     // Chuyển đến màn hình cuộc gọi hoặc thực hiện các thao tác khác.
  //   }
  // }

  // void handleNotificationActionAtForeground(
  //     {required NotificationResponse response, required String actionId}) {
  //        final String? payload = response.payload;
  //         final Map<String, dynamic> data = jsonDecode(payload!);
  //   switch (actionId) {
  //     case "reject_offer":
  //     case "answer_offer":
  //         await WebrtcServices().handleOffer(
  //                     callType: data["callType"],
  //                     messageBoxId: data["messageBoxId"],
  //                     senderId: data["senderId"],
  //                     receiverId: _userId!,
  //                     token: data["token"],
  //                     offer: data["offer"],
  //                     channel: channel!,
  //                   );
  //   }
  // }
}
