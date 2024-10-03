import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static void saveLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setBool('isLoggedIn', true);
  }

  static void saveSendingInvitationBoxId(String id) async {
    if (id == "") {
      return;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
  
    await pref.setString("sendingInvitationBoxId", id);
  }

  static void saveReceivingInvitationBoxId(String id) async {
    if (id == "") {
      return;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString("receivingInvitationBoxId", id);
  }

  static void saveUserIdAndEmail(String id, String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString("userId", id);
    await pref.setString("userEmail", email);
  }

  static Future<String?> getReceivingInvitationBoxId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? id = pref.getString("receivingInvitationBoxId");

    return id;
  }
}