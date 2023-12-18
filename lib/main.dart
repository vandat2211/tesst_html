
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core_toast.dart';
import 'firebase/notification_handler.dart';
import 'input_name.dart';
import 'menu.dart';
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
    print("status_internet:${status}");
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
