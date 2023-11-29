
import 'dart:math';
import 'package:page_flip/page_flip.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tesst_html/app_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tesst_html/firebase/firebase_notification_handler.dart';
import 'package:tesst_html/screen_B.dart';
import 'package:google_books_api/google_books_api.dart';
import 'firebase/notification_handler.dart';
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
      // ChartPage()
      // MyHomePage(title: '',)
      APiBook()
      ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterTts flutterTts = FlutterTts();

  int _currentIndex = 0; // Chỉ mục của câu hỏi hiện tại
  int _correctAnswers = 0; // Số câu trả lời đúng
  TextEditingController controller = TextEditingController();
  final List<Question> _questions = [
    Question(
      questionText: 'What is 2 + 2?',
      correctAnswer: '4',
    ),
    Question(
      questionText: 'What is the capital of France?',
      correctAnswer: 'Paris',
    ),
    Question(
      questionText: 'Chon dap an phu hop voi hinh anh',
      type: "image",
      imageContent: "ic_vneid_v.png",
      correctAnswer: 'app VneID',
    ),
    Question(
      questionText: 'anh ay la mot bac si',
      type: "choose",
      correctAnswer: 'He is a doctor',
    ),
    Question(
      questionText: 'Sắp xếp lại câu cho đúng',
      type: "sort",
      correctAnswer: 'He is a doctor',
    ),
    Question(
      questionText: 'Sắp xếp lại câu cho đúng',
      type: "sort",
      correctAnswer: 'Where are you from?',
    ),
    Question(
      questionText: 'The _ is the king of the jungle',
      type: 'sound',
      correctAnswer: 'lion',
    ),
    Question(
      questionText: 'a convenient mode of transportation',
      type: 'sound',
      correctAnswer: 'The bus',
    ),
    Question(
      questionText: 'Sắp xếp lại câu cho đúng',
      type: "sort",
      correctAnswer: 'Can you recommend a good restaurant?',
    ),
    Question(
      questionText: 'Sắp xếp lại câu cho đúng',
      type: "sort",
      correctAnswer: 'The lion is the king of the jungle',
    ),
    Question(
      questionText: 'Cá heo nổi tiếng với trí thông minh của chúng',
      type: "choose",
      correctAnswer: 'Dolphins are known for their intelligence',
    ),
    Question(
      questionText: 'Cú là loài chim về đêm',
      type: "choose",
      correctAnswer: 'Owls are nocturnal birds',
    ),
    Question(
      questionText: 'Tôi đi xe đạp đi làm mỗi ngày',
      type: "choose",
      correctAnswer: 'I ride a bicycle to work everyday',
    ),
    Question(
      questionText: 'a convenient mode of transportation',
      correctAnswer: 'The bus',
    ),
    Question(
      questionText: 'The _ is the king of the jungle',
      correctAnswer: 'lion ',
    ),
    // Thêm các câu hỏi khác vào đây
  ];
  List<String> answers = [];
  List<String> list = [];
  List<String> list1 = [];
  final List<String> _answers = [
    '4',
    'Paris',
    'London',
    'New York',
    'Berlin',
    'Tokyo',
    "cat",
    "dog",
    "elephant",
    "fox",
    "giraffe",
    "horse",
    "iguana",
    "jaguar",
    "kangaroo",
    "lion",
    "monkey",
    "newt",
    "octopus",
    "penguin",
    "quokka",
    "rhinoceros",
    "squirrel",
    "tiger",
    "unicorn",
    "vulture",
    "walrus",
    "x-ray fish",
    "yak",
    "zebra",
    "Eat",
    "Drink",
    "Sleep",
    "Wake up",
    "Brush teeth",
    "Take a shower",
  ];
  final List<String> _answers_choose = [
    'He',
    'she',
    'is',
    'are',
    'doctor',
    'teacher',
    'they',
    'window',
    'dog',
    'a',
    'an',
    'my',
    'on',
    'go',
    'do',
    'work',
    'home',
    'watch',
    "apple",
    "banana",
    "cherry",
    "date",
    "elderberry",
    "fig",
    "grape",
    "honeydew",
    "kiwi",
    "lemon",
    "mango",
    "orange",
    "pear",
    "quince",
    "raspberry",
    "strawberry",
    "tangerine",
    "uva",
    "watermelon",
    "cat",
    "dog",
    "elephant",
    "fox",
    "giraffe",
    "horse",
    "iguana",
    "jaguar",
    "kangaroo",
    "lion",
    "monkey",
    "newt",
    "octopus",
    "penguin",
    "quokka",
    "rhinoceros",
    "squirrel",
    "tiger",
    "unicorn",
    "vulture",
    "walrus",
    "x-ray fish",
    "yak",
    "zebra",
    "Eat",
    "Drink",
    "Sleep",
    "Wake up",
    "Brush teeth",
    "Take a shower",
    "Get dressed",
    "Go to work",
    "Come home",
    "Cook",
    "Clean",
    "Shop",
    "Exercise",
    "Watch TV",
    "Read",
    "Study",
    "Drive",
    "Walk",
    "Talk",
    "Listen",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTts();
    _questions.shuffle();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage(
        'en-US'); // Đặt ngôn ngữ là tiếng Anh (hoặc ngôn ngữ bạn muốn sử dụng)
    await flutterTts
        .setSpeechRate(1.0); // Tốc độ phát âm (1.0 là tốc độ bình thường)
    await flutterTts.setVolume(1.0); // Âm lượng (1.0 là âm lượng tối đa)
    await flutterTts
        .setPitch(1.0); // Tông giọng (1.0 là tông giọng bình thường)

    // // Lấy danh sách các giọng phát âm có sẵn trên thiết bị
    // List<dynamic> voices = await flutterTts.getVoices;
    //
    //
    // // Kiểm tra xem danh sách có phần tử không
    // if (voices.isNotEmpty) {
    //   // Chọn một giọng phát âm cụ thể từ danh sách (ví dụ, giọng đầu tiên)
    //   Map<String, String> selectedVoice = {
    //     "name": voices[0]["name"].toString(),
    //     // Trích xuất tên giọng và chuyển đổi sang String
    //     "locale": voices[0]["locale"].toString()
    //     // Trích xuất locale và chuyển đổi sang String
    //   };
    //   print("map :$selectedVoice");
    //   // Đặt giọng phát âm bằng Map đã chọn
    //   await flutterTts.setVoice(selectedVoice);
    // }
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text); // Phát âm từ vừa nhận được
  }

  void _showDialog(BuildContext context, bool pass) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông báo"),
          content: Text(pass
              ? "Chúc mừng bạn đã trả lời đúng hết các câu hỏi.\nBan co muốn chơi lại không?"
              : "Bạn đã trả lời sai, bạn có muốn chơi lại không?"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                  _correctAnswers = 0;
                  _questions.shuffle();
                });
                Navigator.of(context).pop(); // Đóng Dialog
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                  _correctAnswers = 0;
                  _questions.shuffle();
                });
                // Thực hiện hành động khi người dùng chọn Cancel
                Navigator.of(context).pop(); // Đóng Dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:
          /* PageFlipWidget(
        backgroundColor: Colors.white,
        lastPage: const Center(child: Text('Last Page!')),
        children: <Widget>[
        Container(child: Text("import 'package:flutter/material.dart'; import 'package:page_flip/page_flip.dart'; void main() { runApp(MyApp()); } class MyApp extends StatelessWidget { @override Widget build(BuildContext context) { return MaterialApp( home: MyPageFlip(), ); } } class MyPageFlip extends StatefulWidget { @override _MyPageFlipState createState() => _MyPageFlipState(); } class _MyPageFlipState extends State<MyPageFlip> { late final PageFlipController _pageFlipController; @override void initState() { super.initState(); _pageFlipController = PageFlipController(); } @override void dispose() { _pageFlipController.dispose(); super.dispose(); } @override Widget build(BuildContext context) { return Scaffold( appBar: AppBar( title: Text('Hiệu ứng lật trang sách'), ), body: PageFlip( controller: _pageFlipController, items: <Widget>[ Container( color: Colors.blue, alignment: Alignment.center, child: Text('Trang 1', style: TextStyle(fontSize: 24, color: Colors.white)), ), Container( color: Colors.green, alignment: Alignment.center, child: Text('Trang 2', style: TextStyle(fontSize: 24, color: Colors.white)), ), Container( color: Colors.orange, alignment: Alignment.center, child: Text('Trang 3', style: TextStyle(fontSize: 24, color: Colors.white)), ), ], ), ); } }"),),
          Container(child: Text("1. HKD chưa được đồng bộ thông tin từ TPS (không có bản ghi nào trong bảng địa chỉ HKD) 2. Nhấn xem bản đồ của HKD 3. Tạo mới tọa độ HKD thành công 4. Kiểm tra thông tin tọa độ của HKD không có trong CSDL1. HKD chưa được đồng bộ thông tin từ TPS (không có bản ghi nào trong bảng địa chỉ HKD) 2. Nhấn xem bản đồ của HKD 3. Tạo mới tọa độ HKD thành công 4. Kiểm tra thông tin tọa độ của HKD không có trong CSDL1. HKD chưa được đồng bộ thông tin từ TPS (không có bản ghi nào trong bảng địa chỉ HKD) 2. Nhấn xem bản đồ của HKD 3. Tạo mới tọa độ HKD thành công 4. Kiểm tra thông tin tọa độ của HKD không có trong CSDL1. HKD chưa được đồng bộ thông tin từ TPS (không có bản ghi nào trong bảng địa chỉ HKD) 2. Nhấn xem bản đồ của HKD 3. Tạo mới tọa độ HKD thành công 4. Kiểm tra thông tin tọa độ của HKD không có trong CSDL1. HKD chưa được đồng bộ thông tin từ TPS (không có bản ghi nào trong bảng địa chỉ HKD) 2. Nhấn xem bản đồ của HKD 3. Tạo mới tọa độ HKD thành công 4. Kiểm tra thông tin tọa độ của HKD không có trong CSDL1. HKD chưa được đồng bộ thông tin từ TPS (không có bản ghi nào trong bảng địa chỉ HKD) 2. Nhấn xem bản đồ của HKD 3. Tạo mới tọa độ HKD thành công 4. Kiểm tra thông tin tọa độ của HKD không có trong CSDL1. HKD chưa được đồng bộ thông tin từ TPS (không có bản ghi nào trong bảng địa chỉ HKD) 2. Nhấn xem bản đồ của HKD 3. Tạo mới tọa độ HKD thành công 4. Kiểm tra thông tin tọa độ của HKD không có trong CSDL1. HKD chưa được đồng bộ thông tin từ TPS (không có bản ghi nào trong bảng địa chỉ HKD) 2. Nhấn xem bản đồ của HKD 3. Tạo mới tọa độ HKD thành công 4. Kiểm tra thông tin tọa độ của HKD không có trong CSDL1. HKD chưa được đồng bộ thông tin từ TPS (không có bản ghi nào trong bảng địa chỉ HKD) 2. Nhấn xem bản đồ của HKD 3. Tạo mới tọa độ HKD thành công 4. Kiểm tra thông tin tọa độ của HKD không có trong CSDL"),),
          Container(child: Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),)
        ],
      )*/
          Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SimpleAnimationProgressBar(
              height: 30,
              width: 300,
              backgroundColor: Colors.grey.shade800,
              foregrondColor: Colors.purple,
              ratio: _correctAnswers * 6 / 5 / _questions.length,
              direction: Axis.horizontal,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 3),
              borderRadius: BorderRadius.circular(10),
              gradientColor:
                  const LinearGradient(colors: [Colors.pink, Colors.purple]),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _currentIndex == _questions.length
                      ? Text(
                          'Quiz completed! You got $_correctAnswers out of ${_questions.length} correct.',
                          style: TextStyle(fontSize: 18),
                        )
                      : Column(
                          children: [
                            Text(
                              _questions[_currentIndex].questionText,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            _questions[_currentIndex].imageContent != ""
                                ? Container(
                                    padding: const EdgeInsets.all(10),
                                    color: Colors.yellow,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 100,
                                    child: Image.asset(
                                        "assets/images/${_questions[_currentIndex].imageContent ?? ""}"),
                                  )
                                : Container(),
                            SizedBox(height: 20),
                            if (_questions[_currentIndex].type == "sort")
                              _generateOptions_sort(),
                            if (_questions[_currentIndex].type == "choose")
                              _generateOptions_choose(),
                            if (_questions[_currentIndex].type == "text" ||
                                _questions[_currentIndex].type == "image")
                              ..._generateOptions(
                                  _questions[_currentIndex].correctAnswer),
                            if (_questions[_currentIndex].type == "sound")
                              _generateOptions_sound()
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateOptions(String correctAnswer) {
    List<String> options = [_questions[_currentIndex].correctAnswer];
    options.addAll(_getRandomAnswers(3));

    // Sắp xếp ngẫu nhiên lại các đáp án
    options.shuffle();

    return options.map((option) {
      return ElevatedButton(
        onPressed: () {
          // Xử lý khi người dùng chọn câu trả lời
          if (option == _questions[_currentIndex].correctAnswer) {
            setState(() {
              _correctAnswers++;
              answers.addAll(_answers);
              _currentIndex++;
            });
          } else {
            _showDialog(context, false);
          }
          // Chuyển sang câu hỏi tiếp theo
        },
        child: Text(option),
      );
    }).toList();
  }

  Widget _generateOptions_choose() {
    List<String> options = _questions[_currentIndex].correctAnswer.split(' ');
    if (list.isEmpty && list1.isEmpty) {
      options.addAll(_getRandomAnswers_choose(5));

      // Sắp xếp ngẫu nhiên lại các đáp án
      options.shuffle();
      list1.addAll(options);
    }

    print("options:${options}");
    return Column(
      children: [
        list.isNotEmpty
            ? Wrap(
                spacing: 8.0, // Khoảng cách giữa các nút theo chiều ngang
                runSpacing: 8.0, // Khoảng cách giữa các dòng nút theo chiều dọc
                children: list.map((option) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        list1.add(option);
                        list.remove(option);
                      });
                    },
                    child: Text(option),
                  );
                }).toList(),
              )
            : Container(),
        SizedBox(
          height: 50,
        ),
        Wrap(
          spacing: 8.0, // Khoảng cách giữa các nút theo chiều ngang
          runSpacing: 8.0, // Khoảng cách giữa các dòng nút theo chiều dọc
          children: list1.map((option) {
            bool isSelected = list1.contains(option);
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  list.add(option);
                  list1.remove(option);
                  String combinedWords = list.join(" ");
                  print("combinedWords:${combinedWords}");
                  if (combinedWords ==
                      _questions[_currentIndex].correctAnswer) {
                    _correctAnswers++;
                    _currentIndex++;
                    list1.clear();
                    list.clear();
                  } else if (combinedWords.length >
                      _questions[_currentIndex].correctAnswer.length) {
                    _showDialog(context, false);
                    list1.clear();
                    list.clear();
                  }
                });
              },
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _generateOptions_sort() {
    List<String> options = _questions[_currentIndex].correctAnswer.split(' ');
    options.shuffle();
    return Column(
      children: [
        Wrap(
          spacing: 8.0, // Khoảng cách giữa các nút theo chiều ngang
          runSpacing: 8.0, // Khoảng cách giữa các dòng nút theo chiều dọc
          children: options.map((option) {
            return Text(
              "$option /",
              style: TextStyle(fontSize: 18),
            );
          }).toList(),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: controller,
          onSubmitted: (text) {
            if (text == _questions[_currentIndex].correctAnswer) {
              setState(() {
                controller.clear();
                _correctAnswers++;
                _currentIndex++;
              });
            } else if (text.isNotEmpty) {
              controller.clear();
              _showDialog(context, false);
            }
          },
        )
      ],
    );
  }

  Widget _generateOptions_sound() {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            speak(_questions[_currentIndex].correctAnswer);
          },
          icon: const Icon(
            Icons.speaker,
            size: 30,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: controller,
          onSubmitted: (text) {
            if (text.toLowerCase() ==
                _questions[_currentIndex].correctAnswer.toLowerCase()) {
              setState(() {
                controller.clear();
                _correctAnswers++;
                _currentIndex++;
              });
            } else if (text.isNotEmpty) {
              controller.clear();
              _showDialog(context, false);
            }
          },
        )
      ],
    );
  }

  List<String> _getRandomAnswers(int count) {
    List<String> randomAnswers = [];
    Random random = Random();
    answers.clear();
    answers.addAll(_answers);
    for (int i = 0; i < answers.length; i++) {
      if (_questions[_currentIndex].correctAnswer == answers[i]) {
        answers.remove(answers[i]);
      }
    }
    print("_ansers:${answers}");
    while (randomAnswers.length < count) {
      String answer = answers[random.nextInt(answers.length)];
      if (!randomAnswers.contains(answer)) {
        randomAnswers.add(answer);
      }
    }

    return randomAnswers;
  }

  List<String> _getRandomAnswers_choose(int count) {
    List<String> randomAnswers = [];
    Random random = Random();
    answers.clear();
    answers.addAll(_answers_choose);
    for (int i = 0; i < answers.length; i++) {
      if (_questions[_currentIndex].correctAnswer.contains(answers[i])) {
        answers.remove(answers[i]);
      }
    }
    print("_ansers:${answers}");
    while (randomAnswers.length < count) {
      String answer = answers[random.nextInt(answers.length)];
      if (!randomAnswers.contains(answer)) {
        randomAnswers.add(answer);
      }
    }

    return randomAnswers;
  }
}

class Question {
  final String questionText;
  final String correctAnswer;
  String? imageContent;
  String? type;
  final List<String> options;

  Question({
    required this.questionText,
    required this.correctAnswer,
    this.imageContent = "",
    this.type = "text",
    this.options = const [],
  });
}
///
class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:AppBar(
        centerTitle: true,
        title: Text("ok"),
      ),
      body: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
          ),
          SizedBox(
            width: 60,
            height: 34,
            child: TextButton(
              onPressed: () {
                // setState(() {
                //   showAvg = !showAvg;
                // });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        // ScreenB(items: ["a","b","c","d","e","f","g","h"]),
                    ParabolicAnimation(),
                  ),
                );
              },
              child: Text(
                'avg',
                style: TextStyle(
                  fontSize: 12,
                  color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white54,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color:
      Colors.white54,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class APiBook extends StatefulWidget {
  const APiBook({super.key});

  @override
  State<APiBook> createState() => _APiBookState();
}

class _APiBookState extends State<APiBook> {
  FirebaseNotifications firebaseNotifications = new FirebaseNotifications();
  final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();
  String texts = "";
  bool isClick = true;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    firebaseNotifications.setupFirebase(navigatorKey);
  }
  Future<void> _onSearchPressed() async {
    String searchTerm = _searchController.text;
    if(searchTerm.isNotEmpty){
      texts = await getApi(searchTerm);
      setState(() {
       if(texts.isNotEmpty) isClick = true;
      });
    }
  }
  Future<String> getApi(String key) async {
    setState(() {
      isClick = false;
    });
    // Tạo đối tượng API
    final booksApi = GoogleBooksApi();

    // Tìm kiếm sách
    final results = await booksApi.searchBooks(key);

    // Lấy văn bản toàn văn của cuốn sách đầu tiên
    final book = results.first;
    final text = await booksApi.getBookById(book.id);
    return text.volumeInfo.description;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  suffixIcon: InkWell(
                      onTap: _onSearchPressed,
                      child: Icon(Icons.search)),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child:isClick?Container(child: Text(texts),):CircularProgressIndicator(),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}


