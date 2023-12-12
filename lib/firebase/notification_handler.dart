

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/share_prefer.dart';

class NotificationHandler {
  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static late  GlobalKey<NavigatorState> navigatorKey;

  static Future<void> initNotificataion(
      GlobalKey<NavigatorState> navigatorKeyReceived) async {
    navigatorKey = navigatorKeyReceived;
    final  initAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    final DarwinInitializationSettings initializationSettingsDarwin =
    const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:onDidReceiveLocalNotification,
    );
    final  initSelling =
        InitializationSettings(android: initAndroid, iOS: initializationSettingsDarwin);
    await  flutterLocalNotificationPlugin.initialize(initSelling,
    onDidReceiveNotificationResponse: (NotificationResponse  response) async {
      if (response.payload != null) {
        await SharePreferUtils.getAccessToken().then((value) {
          if (value.isNotEmpty) {
          print("vao lai app");
          }else{
           print("ko vào lại app");
          }
        });
      }
    });
  }

  static Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title??''),
              content: Text(body??''),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("ok"),
                  onPressed: () {
                    print("click notification");
                    //Navigator.of(context, rootNavigator: true).pop();
                  },
                )
              ],
            ));
  }
}
