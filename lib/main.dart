
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'components/core_toast.dart';
import 'firebase/notification_handler.dart';
import 'models/question.dart';
import 'screen/input_name.dart';
import 'screen/menu.dart';
import 'package:workmanager/workmanager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
@pragma('vm:entry-point')

Future<void> fcmBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  dynamic data = message.data;
  print("onBackgroundMessage");
  showNotification(data['title'], data['body']);
  return Future<void>.value();
}
void showNotification(title, body) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "com.example.tesst_html", "channel",
      channelDescription: "My Channel Description",
      importance: Importance.max, priority: Priority.high);

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics);

  await NotificationHandler.flutterLocalNotificationPlugin
      .show(0, title, body, platformChannelSpecifics, payload: "My payload");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(fcmBackgroundMessageHandler);
  SharedPreferences pref = await SharedPreferences.getInstance();
  String id =  pref.getString("id")??"";
    runApp( MyApp(check:id.isNotEmpty?true:false ,));
  // Initialize the workmanager plugin
  Workmanager().initialize(
    // Define a callback function to handle the periodic task
    callbackDispatcher,
    // Set the isInDebugMode to true for testing
    isInDebugMode: true,
  );
  // Register a periodic task to run every 24 hours
  Workmanager().registerPeriodicTask(
    // Give the task a unique name
    'sendNotificationTask',
    // Give the task a unique tag
    'sendNotificationTag',
    // Set the frequency to 24 hours
    frequency: Duration(hours: 24),
    // Set the initial delay to 8 hours
    initialDelay: Duration(hours: 10),
    // Set the constraints for the task
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}
void callbackDispatcher() {
  // Create a Workmanager object
  Workmanager().executeTask((task, inputData) {
    // Call the sendNotification function
    sendNotification();
    // Return true to indicate the task is successful
    return Future.value(true);
  });
}
void sendNotification() async {
  // Get the server key from Firebase console
  String serverKey = 'AAAAblVqaiE:APA91bFW9mRx80KMG-LoXDShBFdLpV2ySyaSQzm-yO-tPdZsU4tbhAzOligccmgaTaBgOIIhdMDIg7ls8LQl6BcovRD7SQ1XleYNIs1ovx1MPbdfswyIncWQZQwypddN7T5XgLxPlVXH';

  // Get the device token from FirebaseMessaging
  List<String> deviceTokens = [];
  DatabaseReference ref =
  FirebaseDatabase.instance.ref("tokens/");
  ref.onValue.listen((DatabaseEvent event) async {
    final data = event.snapshot.value;
    print("listdeviceTokens:$data");
    if (data != null) {
      final a = jsonEncode(data);
      Map<String, dynamic> firebaseData = jsonDecode(a);
      // Chuyển đổi dữ liệu từ Map sang List
      List<Token> tokenList = firebaseData.values.map((value) {
        return Token.fromJson(value.cast<String, dynamic>());
      }).toList();
      tokenList.forEach((element) {
        deviceTokens.add(element.token);
      });
      for (String deviceToken in deviceTokens){
        // Create the request body
        Map<String, dynamic> body = {
          'notification': {
            'title': 'Chúc bạn ngày mới tốt lành.',
            'body': 'Hôm nay bạn đã vượt qua bn câu hỏi.Nếu chưa hãy mở app lên và trải nhiệm.',
          },
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': deviceToken,
        };

        // Send the request
        http.Response response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: json.encode(body),
        );
        // Print the response
        print(response.body);
      }
    }

  });




}
class MyApp extends StatefulWidget {
   MyApp({super.key,required this.check});
   bool check;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Create a ConnectivityPlus object
  Connectivity connectivity = Connectivity();
  String status = 'Unknown';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
    // Listen to connectivity changes
    connectivity.onConnectivityChanged.listen((result) {
      if(result==ConnectivityResult.none){
        Toast.showLongTop("không có kết nối internet!");
      }
      // Update the status and wifi name variables
      setState(() {
        status = result.toString();
        print("status_internet:${status}");
      });
    });
  }
  void checkConnectivity() async {
    // Get the connectivity result
    final connectivityResult = await (Connectivity().checkConnectivity());

    // Update the status and wifi name variables
    setState(() {
      status = connectivityResult.toString();
    });
    if(connectivityResult == ConnectivityResult.none){
      Toast.showLongTop("không có kết nối internet!");
      print("vao dây");
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
      // ChartPage()
      // APiBook()
       widget.check?MenuScreen():InputName(),
    );
  }
}

// class APiBook extends StatefulWidget {
//   const APiBook({super.key});
//
//   @override
//   State<APiBook> createState() => _APiBookState();
// }
//
// class _APiBookState extends State<APiBook> {
//   FirebaseNotifications firebaseNotifications = new FirebaseNotifications();
//   final GlobalKey<NavigatorState> navigatorKey =
//   new GlobalKey<NavigatorState>();
//   String texts = "";
//   bool isClick = true;
//   TextEditingController _searchController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     firebaseNotifications.setupFirebase(navigatorKey);
//   }
//   Future<void> _onSearchPressed() async {
//     String searchTerm = _searchController.text;
//     if(searchTerm.isNotEmpty){
//       texts = await getApi(searchTerm);
//       setState(() {
//        if(texts.isNotEmpty) isClick = true;
//       });
//     }
//   }
//   Future<String> getApi(String key) async {
//     setState(() {
//       isClick = false;
//     });
//     // Tạo đối tượng API
//     final booksApi = GoogleBooksApi();
//
//     // Tìm kiếm sách
//     final results = await booksApi.searchBooks(key);
//
//     // Lấy văn bản toàn văn của cuốn sách đầu tiên
//     final book = results.first;
//     final text = await booksApi.getBookById(book.id);
//     return text.volumeInfo.description;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Tìm kiếm...',
//                   suffixIcon: InkWell(
//                       onTap: _onSearchPressed,
//                       child: Icon(Icons.search)),
//                 ),
//               ),
//               Flexible(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   child:isClick?Container(child: Text(texts),):CircularProgressIndicator(),
//                 ),
//               )
//             ],
//           ),
//         )
//       ),
//     );
//   }
// }
//
//
