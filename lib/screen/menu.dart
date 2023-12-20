import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesst_html/screen/notifityPage.dart';
import 'package:tesst_html/screen/profile.dart';
import 'package:week_of_year/date_week_extensions.dart';
import '/utils/rive_utils.dart';
import '/components/animated_bar.dart';
import '/models/rive_asset.dart';
import 'bxh.dart';
import '../firebase/firebase_notification_handler.dart';
import 'home.dart';
import '../models/question.dart';


class MenuScreen extends StatefulWidget {
   MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _EntryPointState();
}

class _EntryPointState extends State<MenuScreen> {
  FirebaseNotifications firebaseNotifications = new FirebaseNotifications();
  final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();
  RiveAsset selectedBottomNav = bottomNavItems.first;
  int selectedIndex = 0;
  int count =0 ;
   List<Widget> pages = [
     HomePage(),
     BxhScreen(), // Widget cho mục 2
     NotifityPage(),
     ProFileScreen(),// Widget cho mục 3
  ];
   @override
  void initState() {
     getData();
     getNotifity();
    super.initState();
     firebaseNotifications.setupFirebase(navigatorKey);
  }
  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String id =  pref.getString("id")??"";
    DateTime now = DateTime.now();
    // Lấy số tuần hiện tại
    int weekNumber = DateTime.now().weekOfYear;
    int week =  pref.getInt("week")??0;
    print("week :$week");
    print("weekNumber :$weekNumber");
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("users/$id");
    starCountRef.onValue.listen((DatabaseEvent event) async {
      final data = event.snapshot.value;
      print("objectdata:$data");
      if (data != null) {
        final a = jsonEncode(data);
        Map<String, dynamic> dataMap = jsonDecode(a);
        User user = User.fromJson(dataMap);
        if(weekNumber>week){
          await pref.remove('Mo');
          await pref.remove('Tu');
          await pref.remove('We');
          await pref.remove('Th');
          await pref.remove('Fr');
          await pref.remove('Sa');
          await pref.remove('Su');

          await pref.remove('English');
          await pref.remove('image_dhbc');
          await pref.remove('dhbc');
          await pref.remove('STT');
          await pref.remove('SGH');
        }
        else if (DateTime.now().weekday == 1) {
          await pref.setDouble("Mo", double.parse(user.point));
        }else if(DateTime.now().weekday == 2){
          await pref.setDouble("Tu", double.parse(user.point));
        }else if(DateTime.now().weekday == 3){
          await pref.setDouble("We", double.parse(user.point));
        }else if(DateTime.now().weekday == 4){
          await pref.setDouble("Th", double.parse(user.point));
        }else if(DateTime.now().weekday == 5){
          await pref.setDouble("Fr", double.parse(user.point));
        }else if(DateTime.now().weekday == 6){
          await pref.setDouble("Sa", double.parse(user.point));
        }else if(DateTime.now().weekday == 7){
          await pref.setDouble("Su", double.parse(user.point));
        }


      }});
  }
  Future<void> getNotifity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String id =  pref.getString("id")??"";
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("users/$id/listTB");
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("lisstTB:$data");
      if (data != null) {
        final a = jsonEncode(data);
        Map<String, dynamic> firebaseData = jsonDecode(a);
        // Chuyển đổi dữ liệu từ Map sang List
        List<Mes> listTB = firebaseData.values.map((value) {
          return Mes.fromJson(value.cast<String, dynamic>());
        }).toList();
        int countt = listTB.where((element) => element.isSeen == false).length;
        setState(() {
          count = countt;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        extendBody: true,
        body: pages[selectedIndex],
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24,vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNavItems.length,
                      (index) => GestureDetector(
                    onTap: () {
                      bottomNavItems[index].input?.change(true);
                      if (bottomNavItems[index] != selectedBottomNav) {
                        setState(() {
                          selectedBottomNav = bottomNavItems[index];
                          selectedIndex = index;
                        });
                      }
                      // Time of animation running
                      Future.delayed(const Duration(seconds: 10), () {
                        bottomNavItems[index].input?.change(false);
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBar(isActive: bottomNavItems[index] == selectedBottomNav),
                        Stack(
                          children: [
                            SizedBox(
                              height: 36,
                              width: 36,
                              child: Opacity(
                                opacity: bottomNavItems[index] == selectedBottomNav ? 1 : 0.5,
                                child: RiveAnimation.asset(
                                  bottomNavItems.first.src,
                                  artboard: bottomNavItems[index].artBoard,
                                  onInit: (artBoard) {
                                    StateMachineController controller = RiveUtils.getRiveController(
                                      artBoard,
                                      stateMachineName: bottomNavItems[index].stateMachineName,
                                    );
                                      bottomNavItems[index].input = controller.findSMI("active");

                                  },
                                ),
                              ),
                            ),
                            index==2 && count>0?Positioned(
                              right: 0,
                              child: Container(
                                alignment: Alignment.center,
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child: Text("$count",style: TextStyle(color: Colors.white)),
                              ),
                            ):Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
