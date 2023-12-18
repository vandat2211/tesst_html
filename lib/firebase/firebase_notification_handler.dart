
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/share_prefer.dart';
import '../models/question.dart';
import 'notification_handler.dart';
class FirebaseNotifications {
   FirebaseMessaging _messaging =FirebaseMessaging.instance  ;

  bool isLogin =false;

  void setupFirebase(GlobalKey<NavigatorState> navigatorKey) async {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotificataion(navigatorKey);
    firebaseCloudMessagingListener(navigatorKey);
  }

  void firebaseCloudMessagingListener(GlobalKey<NavigatorState> navigatorKey) {
    _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    _messaging.onTokenRefresh.listen((token) {
      print('Token refreshed: $token');
    });

    _messaging.getToken().then((value) async {
      if (value != null) {
        await SharePreferUtils.saveFCMToken(value);
        print("Token :" + value);
      }
    });
    _messaging
        .subscribeToTopic("demo")
        .whenComplete(() => print("Subcribe ok"));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      FBroadcast.instance().broadcast("FLUTTER_NOTIFICATION_CLICK");
      print("onMessage: ${message.data['body']}");
      showNotification(message.notification?.title, message.notification?.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      String id =  pref.getString("id")??"";
      String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/$id/listTB/$timestamp");
      await ref.set({
        'idTB':"$timestamp",
        "title":message.notification?.title,
        "body":message.notification?.body,
        "time":formattedDate,
        "timeSeen":"",
        "isSeen":false
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await SharePreferUtils.getAccessToken().then((value) {
        print("mở lại app");
      });
    });
  }
  Future<void> fcmBackgroundMessageHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    dynamic data = message.data;
    print("onBackgroundMessage");
    showNotification(data['title'], data['body']);
    return Future<void>.value();
  }

  static void showNotification(title, body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "com.etax.icanhan", "channel",
        channelDescription: "My Channel Description",
        importance: Importance.max, priority: Priority.high);

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics);

    await NotificationHandler.flutterLocalNotificationPlugin
        .show(0, title, body, platformChannelSpecifics, payload: "My payload");
  }
}
