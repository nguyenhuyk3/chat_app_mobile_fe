import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('isLoggedIn', true);
  }

  static Future<void> saveSendingInvitationBoxId(String id) async {
    if (id == "") {
      return;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("sendingInvitationBoxId", id);
  }

  static Future<void> saveReceivingInvitationBoxId(String id) async {
    if (id == "") {
      return;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("receivingInvitationBoxId", id);
  }

  static Future<void> saveUserIdAndEmail(String id, String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString("userId", id);
    await pref.setString("userEmail", email);
  }

  static Future<void> saveTokenDevice(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("tokenDevice", token);
  }

  static Future<String?> getReceivingInvitationBoxId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? id = pref.getString("receivingInvitationBoxId");

    return id;
  }

  static Future<String?> getSendingInvitationBoxId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? id = pref.getString("sendingInvitationBoxId");

    return id;
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? email = pref.getString("userEmail");

    return email;
  }

  static Future<String?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? id = pref.getString("userId");

    return id;
  }

  static Future<String?> getTokenDevice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString("tokenDevice");

    return token;
  }

  static Future<void> clearAllSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
