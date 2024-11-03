// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:chat_app_mobile_fe/global/global_var.dart';
import 'package:chat_app_mobile_fe/helpers/shared_preferences_helper.dart';
import 'package:chat_app_mobile_fe/models/friend_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

        print("Data received (getSendingInvitationBox): $responseData");
      } else {
        print(
            "Error from server (getSendingInvitationBox): ${response.statusCode}");
      }
    } catch (error) {
      print("An error occurred (getSendingInvitationBox): $error");
    }
  }

  static Future<void> saveAllIdsIntoSP(String email) async {
    final url = "${GlobalVar.httpBaseUrl}/users/get_sub_ids?email=$email";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        String userId = responseData["userId"];
        String receivingInvitationId = responseData["receivingInvitationId"];
        String sendingInvitationId = responseData["sendingInvitationId"];

        await Future.wait([
          SharedPreferencesHelper.saveUserIdAndEmail(userId, email),
          SharedPreferencesHelper.saveReceivingInvitationBoxId(
              receivingInvitationId),
          SharedPreferencesHelper.saveSendingInvitationBoxId(
              sendingInvitationId),
        ]);
      } else {
        print("Lỗi từ máy chủ: ${response.statusCode}");
      }
    } catch (error) {
      print("Đã xảy ra lỗi: $error");
    }
  }

  static Future<List<FriendRequest>> getAllInvitations(String boxType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    late final String type;
    late String? invitationBoxId;

    switch (boxType) {
      case "receiving_invitation_box":
        type = "get_receiving_invitation_box";
        invitationBoxId = prefs.getString("receivingInvitationBoxId");
      case "sending_invitation_box":
        type = "get_sending_invitation_box";
        invitationBoxId = prefs.getString("sendingInvitationBoxId");
      default:
        throw Exception("Invalid box type provided");
    }

    if (invitationBoxId == null) {
      throw Exception("Invitation box ID not found in SharedPreferences");
    }

    String url =
        "${GlobalVar.httpBaseUrl}/users/$type?$boxType=$invitationBoxId";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['makeFriendRequests']['friendRequests'] != null) {
          List<dynamic> friendRequestsJson =
              responseBody['makeFriendRequests']['friendRequests'];
          List<FriendRequest> friendRequests = friendRequestsJson
              .map((json) => FriendRequest.fromJson(json))
              .toList();

          return friendRequests;
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to fetch invitations: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("An error occurred: $error");
    }
  }

  static Future<void> deleteSendingInvitation(String toUserEmail) async {
    String? fromUserEmail = await SharedPreferencesHelper.getUserEmail();
    String? sendingInvitationBoxId =
        await SharedPreferencesHelper.getSendingInvitationBoxId();
    String url =
        "${GlobalVar.httpBaseUrl}/users/delete_friend_request_for_sending";
    Map<String, String> request = {
      "invitationBoxId": sendingInvitationBoxId!,
      "fromUserEmail": fromUserEmail!,
      "toUserEmail": toUserEmail,
    };

    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-type': 'application/json',
          },
          body: jsonEncode(request));

      if (response.statusCode == 200) {
        print('Dữ liệu trả về: ${response.body}');
      } else {
        print(
            'Yêu cầu POST thất bại với mã trạng thái: ${response.statusCode}');
      }
    } catch (error) {
      print('Đã xảy ra lỗi: $error');
    }
  }

  static Future<void> deleteReceivingInvitation(String toUserEmail) async {
    String? fromUserEmail = await SharedPreferencesHelper.getUserEmail();
    String? receivingInvitationBoxId =
        await SharedPreferencesHelper.getReceivingInvitationBoxId();
    String url =
        "${GlobalVar.httpBaseUrl}/users/delete_friend_request_for_receiving";
    Map<String, String> request = {
      "invitationBoxId": receivingInvitationBoxId!,
      "fromUserEmail": fromUserEmail!,
      "toUserEmail": toUserEmail,
    };

    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-type': 'application/json',
          },
          body: jsonEncode(request));

      if (response.statusCode == 200) {
        print('Dữ liệu trả về: ${response.body}');
      } else {
        print(
            'Yêu cầu POST thất bại với mã trạng thái: ${response.statusCode}');
      }
    } catch (error) {
      print('Đã xảy ra lỗi: $error');
    }
  }

  static Future<void> acceptInvitation(String fromUserEmail) async {
    String? toUserEmail = await SharedPreferencesHelper.getUserEmail();
    const String url = "${GlobalVar.httpBaseUrl}/ws/accept_friend";
    final Map<String, String> request = {
      "fromUserEmail": fromUserEmail,
      "fromUserName": "Nguyen Quoc Huy_1",
      "toUserEmail": toUserEmail!,
      "toUserName": "Nguyen Quoc Huy_2"
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        print('Return data: ${response.body}');
      } else {
        print('POST request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  static Future<void> updateMessageBySendedId(
      {required String messageBoxId,
      required String sendedId,
      required String content}) async {
    const url = "${GlobalVar.httpBaseUrl}/users/update_message_by_sended_id";
    final Map<String, String> request = {
      "messageBoxId": messageBoxId,
      "sendedId": sendedId,
      "content": content
    };
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        print('Return data: ${response.body}');
      } else {
        print('POST request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  static Future<List<String>> loadAllFriendEmails(String userId) async {
    final String url =
        "${GlobalVar.httpBaseUrl}/users/get_all_friend_email_by_id?user_id=$userId";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        List<dynamic> friendEmailsJson = responseBody['friendEmails'];
        List<String> friendEmails =
            friendEmailsJson.map((email) => email.toString()).toList();

        return friendEmails;
      } else {
        return [];
      }
    } catch (error) {
      print('An error occurred (loadAllFriendEmails): $error');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getInformationByEmail(
      String email) async {
    final String url =
        "${GlobalVar.httpBaseUrl}/users/get_information_by_email?email=$email";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final information = data['information'] as Map<String, dynamic>?;
        if (information != null) {
          return {
            'email': information['email'] ?? '',
            'fullName': information['fullName'] ?? ''
          };
        }
      } else {
        return null;
      }
    } catch (error) {
      print('An error occurred (loadAllFriendEmails): $error');
      return null;
    }
  }

  static Future<List<String>?> getEmailsFromInvitationBox(
      String invitationBoxType, String invitationBoxId) async {
    final String url =
        "${GlobalVar.httpBaseUrl}/users/get_emails_from_invitation_box?invitation_box_type=$invitationBoxType&invitation_box_id=$invitationBoxId";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        List<dynamic> friendEmailsJson = responseBody['emails'];
        List<String> emails =
            friendEmailsJson.map((email) => email.toString()).toList();

        print("cọndflkja");
        print(emails);

        return emails;
      } else {
        return null;
      }
    } catch (error) {
      print('An error occurred (loadAllFriendEmails): $error');
      return null;
    }
  }

  static Future<bool> addFriend(
      {required String fromUserEmail,
      required String userId,
      required String toUserEmail}) async {
    final String getFullNameUrl =
        "${GlobalVar.httpBaseUrl}/users/get_full_name_by_id?user_id=$userId";
    try {
      final response = await http.get(Uri.parse(getFullNameUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String fullName = responseBody["fullName"];
        const makeFriendUrl = "${GlobalVar.httpBaseUrl}/users/make_friend";
        final requestBody = {
          "fromUserInfor": {
            "fromUserEmail": fromUserEmail,
            "fromUserName": fullName
          },
          "toUserEmail": toUserEmail,
          "status": "pending"
        };
        final makeFriendResponse = await http.post(
          Uri.parse(makeFriendUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestBody),
        );

        if (makeFriendResponse.statusCode == 200) {
          print("Friend request sent successfully!");
          return true;
        } else {
          print(
              'Failed to send friend request. Status code: ${makeFriendResponse.statusCode}');
          return false;
        }
      } else {
        print('Failed to get full name. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('An error occurred (addFriend): $error');
      return false;
    }
  }
}
