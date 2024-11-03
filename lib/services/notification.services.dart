// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/collections/token_device.collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> saveTokenDevice() async {
    try {
      await _firebaseMessaging.requestPermission();

      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null) {
        throw Exception('Không thể lấy FCM token.');
      }

      final String? userId = await SharedPreferencesHelper.getUserId();
      final tokenDevice = TokenDevice(userId: userId!, token: fcmToken);
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
}
