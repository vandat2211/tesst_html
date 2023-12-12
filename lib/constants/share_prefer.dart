import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharePreferUtils {
  static Future<String> getAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("ACCESS_TOKEN")??"";
  }

  static Future<void> saveAccessToken(String accessToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("ACCESS_TOKEN", accessToken);
  }

  static Future<void> saveFCMToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token" + "Token", token). then((value) => print("token_push 1= $value") );
    return;
  }

  static Future<String> getFCMToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String fcmToken = pref.getString("token" + "Token") ?? "";
    print("token_push 2= $fcmToken");
    return fcmToken;
  }
}
