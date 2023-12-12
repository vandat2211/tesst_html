import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tesst_html/constants/app_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tesst_html/firebase/firebase_notification_handler.dart';
import 'package:google_books_api/google_books_api.dart';
import 'firebase/notification_handler.dart';
import 'menu.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

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
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      const MenuScreen(),
    );
  }
}
// ///
// class ChartPage extends StatefulWidget {
//   const ChartPage({super.key});
//
//   @override
//   State<ChartPage> createState() => _ChartPageState();
// }
//
// class _ChartPageState extends State<ChartPage> {
//   List<Color> gradientColors = [
//     AppColors.contentColorCyan,
//     AppColors.contentColorBlue,
//   ];
//
//   bool showAvg = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar:AppBar(
//         centerTitle: true,
//         title: Text("ok"),
//       ),
//       body: Stack(
//         children: <Widget>[
//           AspectRatio(
//             aspectRatio: 1.70,
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 right: 18,
//                 left: 12,
//                 top: 24,
//                 bottom: 12,
//               ),
//               child: LineChart(
//                 showAvg ? avgData() : mainData(),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 60,
//             height: 34,
//             child: TextButton(
//               onPressed: () {
//                 setState(() {
//                   showAvg = !showAvg;
//                 });
//               },
//               child: Text(
//                 'avg',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Colors.white54,
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     );
//     Widget text;
//     switch (value.toInt()) {
//       case 2:
//         text = const Text('MAR', style: style);
//         break;
//       case 5:
//         text = const Text('JUN', style: style);
//         break;
//       case 8:
//         text = const Text('SEP', style: style);
//         break;
//       default:
//         text = const Text('', style: style);
//         break;
//     }
//
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: text,
//     );
//   }
//
//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color:
//       Colors.white54,
//       fontWeight: FontWeight.bold,
//       fontSize: 15,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 1:
//         text = '10K';
//         break;
//       case 3:
//         text = '30k';
//         break;
//       case 5:
//         text = '50k';
//         break;
//       default:
//         return Container();
//     }
//
//     return Text(text, style: style, textAlign: TextAlign.left);
//   }
//
//   LineChartData mainData() {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         horizontalInterval: 1,
//         verticalInterval: 1,
//         getDrawingHorizontalLine: (value) {
//           return const FlLine(
//             color: AppColors.mainGridLineColor,
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return const FlLine(
//             color: AppColors.mainGridLineColor,
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 1,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 1,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: const Color(0xff37434d)),
//       ),
//       minX: 0,
//       maxX: 11,
//       minY: 0,
//       maxY: 6,
//       lineBarsData: [
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 3),
//             FlSpot(2.6, 2),
//             FlSpot(4.9, 5),
//             FlSpot(6.8, 3.1),
//             FlSpot(8, 4),
//             FlSpot(9.5, 3),
//             FlSpot(11, 4),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   LineChartData avgData() {
//     return LineChartData(
//       lineTouchData: const LineTouchData(enabled: false),
//       gridData: FlGridData(
//         show: true,
//         drawHorizontalLine: true,
//         verticalInterval: 1,
//         horizontalInterval: 1,
//         getDrawingVerticalLine: (value) {
//           return const FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//         getDrawingHorizontalLine: (value) {
//           return const FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             getTitlesWidget: bottomTitleWidgets,
//             interval: 1,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//             interval: 1,
//           ),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: const Color(0xff37434d)),
//       ),
//       minX: 0,
//       maxX: 11,
//       minY: 0,
//       maxY: 6,
//       lineBarsData: [
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 3.44),
//             FlSpot(2.6, 3.44),
//             FlSpot(4.9, 3.44),
//             FlSpot(6.8, 3.44),
//             FlSpot(8, 3.44),
//             FlSpot(9.5, 3.44),
//             FlSpot(11, 3.44),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: [
//               ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   .lerp(0.2)!,
//               ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   .lerp(0.2)!,
//             ],
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [
//                 ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                     .lerp(0.2)!
//                     .withOpacity(0.1),
//                 ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                     .lerp(0.2)!
//                     .withOpacity(0.1),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
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
