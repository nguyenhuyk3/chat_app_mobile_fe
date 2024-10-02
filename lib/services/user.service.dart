import 'dart:convert';

import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class UserService {
  static void saveUserInformationIntoPref(String email) async {
    final url = "${GlobalVar.httpBaseUrl}/users/search?email=$email";
    final response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        String userId = responseBody["userId"];

        SharedPreferencesHelper.saveUserIdAndEmail(userId, email);
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  static void getSendingInvitationBox() async {
    String? sendingInvitationBoxId =
        await SharedPreferencesHelper.getReceivingInvitationBoxId();

    if (sendingInvitationBoxId == null) {
      return;
    }

    final url =
        "${GlobalVar.httpBaseUrl}/users/get_sending_invitation_box?sending_invitation_box_id=$sendingInvitationBoxId";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        print("Dữ liệu nhận được: $responseData");
      } else {
        print("Lỗi từ máy chủ: ${response.statusCode}");
      }
    } catch (error) {
      print("Đã xảy ra lỗi: $error");
    }
  }
}
