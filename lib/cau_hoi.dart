import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tesst_html/models/question.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
class CauHoi extends StatefulWidget {
   CauHoi({super.key, required this.type,required this.questions,this.choose_dhbc =true});
  final String type ;
   List<Question> questions;
   bool choose_dhbc ;
  @override
  State<CauHoi> createState() => _CauHoiState();
}

class _CauHoiState extends State<CauHoi> {
  FlutterTts flutterTts = FlutterTts();

  int _currentIndex = 0; // Chỉ mục của câu hỏi hiện tại
  int _correctAnswers = 0; // Số câu trả lời đúng
  bool choose_dhbc = true;
  List<int> isSelectedList = List.generate(25, (index) => 0);
  List<int> selectedIndexes = [];
  TextEditingController controller = TextEditingController();
  List<Question> questions = [];
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
   questions = widget.questions;
   choose_dhbc = widget.choose_dhbc;
    super.initState();
    initTts();
    // questions.shuffle();
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
      barrierDismissible: false,
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
                  // questions.shuffle();
                  choose_dhbc = false;
                  isSelectedList = List.generate(25, (index) => 0);
                  selectedIndexes.clear();
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
                  // questions.shuffle();
                  choose_dhbc = false;
                  isSelectedList = List.generate(25, (index) => 0);
                  selectedIndexes.clear();
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
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SimpleAnimationProgressBar(
              height: 30,
              width: 300,
              backgroundColor: Colors.grey.shade800,
              foregrondColor: Colors.purple,
              ratio: _correctAnswers * 6 / 5 / questions.length,
              direction: Axis.horizontal,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 3),
              borderRadius: BorderRadius.circular(10),
              gradientColor:
              const LinearGradient(colors: [Colors.pink, Colors.purple]),
            ),
            SizedBox(height: 20),
            choose_dhbc?
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _currentIndex == questions.length
                      ? Text(
                    'Quiz completed! You got $_correctAnswers out of ${questions
                        .length} correct.',
                    style: TextStyle(fontSize: 18),
                  )
                      : Column(
                    children: [
                      Text(
                        questions[_currentIndex].questionText,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      questions[_currentIndex].imageContent != ""
                          ? Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.yellow,
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width * 0.5,
                        height: 100,
                        child: Image.asset(
                            "assets/images/${questions[_currentIndex]
                                .imageContent ?? ""}"),
                      )
                          : Container(),
                      SizedBox(height: 20),
                      if (questions[_currentIndex].type == "sort")
                        _generateOptions_sort(),
                      if (questions[_currentIndex].type == "choose")
                        _generateOptions_choose(),
                      if (questions[_currentIndex].type == "text" ||
                          questions[_currentIndex].type == "image")
                        ..._generateOptions(
                            questions[_currentIndex].correctAnswer),
                      if (questions[_currentIndex].type == "sound")
                        _generateOptions_sound(),
                      if (questions[_currentIndex].type == "image_dhbc")
                        _generateOptions_choose_word(),
                    ],
                  )
                ],
              ),
            ):Expanded(child: dhbcst()),
          ],
        ),
      ),
    );
  }

// câu hỏi chọn đấp án đúng
  List<Widget> _generateOptions(String correctAnswer) {
    List<String> options = [questions[_currentIndex].correctAnswer];
    options.addAll(_getRandomAnswers(3));

    // Sắp xếp ngẫu nhiên lại các đáp án
    options.shuffle();

    return options.map((option) {
      return ElevatedButton(
        onPressed: () {
          // Xử lý khi người dùng chọn câu trả lời
          if (option == questions[_currentIndex].correctAnswer) {
            setState(() {
              _correctAnswers++;
              answers.addAll(_answers);
              _currentIndex++;
              choose_dhbc = false;
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

  List<String> _getRandomAnswers(int count) {
    List<String> randomAnswers = [];
    Random random = Random();
    answers.clear();
    answers.addAll(_answers);
    for (int i = 0; i < answers.length; i++) {
      if (questions[_currentIndex].correctAnswer == answers[i]) {
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

// câu hỏi chon từ ghep thanh cau cho đúng
  Widget _generateOptions_choose() {
    List<String> options = questions[_currentIndex].correctAnswer.split(' ');
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
                      questions[_currentIndex].correctAnswer) {
                    _correctAnswers++;
                    _currentIndex++;
                    list1.clear();
                    list.clear();
                    choose_dhbc = false;
                  } else if (combinedWords.length >
                      questions[_currentIndex].correctAnswer.length) {
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

  List<String> _getRandomAnswers_choose(int count) {
    List<String> randomAnswers = [];
    Random random = Random();
    answers.clear();
    answers.addAll(_answers_choose);
    for (int i = 0; i < answers.length; i++) {
      if (questions[_currentIndex].correctAnswer.contains(answers[i])) {
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

  // câu hỏi duổi hình bắt chữ
  Widget _generateOptions_choose_word() {
    List<String> listOptions = questions[_currentIndex].correctAnswer
        .replaceAll(' ', '').split("");
    List<String> options = listOptions.map((char) => char.toUpperCase())
        .toList();
    List<String> emptyList = List.filled(options.length-list.length, '');
    if (list1.isEmpty) {
      // Thêm 5 ký tự hoa ngẫu nhiên từ 'A' đến 'Z' vào danh sách ban đầu
      for (int i = 0; i < 5; i++) {
        int randomNumber = Random().nextInt(26); // Số ngẫu nhiên từ 0 đến 25
        String randomChar = String.fromCharCode(
            'A'.codeUnitAt(0) + randomNumber);
        options.add(randomChar);
      }
      // Sắp xếp ngẫu nhiên lại từ trong chuỗi
      options.shuffle();
      list1.addAll(options);
    }
    return Column(
      children: [
        Wrap(
          spacing: 8.0, // Khoảng cách giữa các nút theo chiều ngang
          runSpacing: 8.0, // Khoảng cách giữa các dòng nút theo chiều dọc
          children: [...list.map((option) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  list1.add(option);
                  list.remove(option);
                });
              },
              child: Text(option),
            );
          }).toList(), ...emptyList.map((option) {
            return ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn vào các ô rỗng (nếu cần)
              },
              child: Text(option),
            );
          }).toList()],
        ),
        SizedBox(
          height: 50,
        ),
        Wrap(
          spacing: 8.0, // Khoảng cách giữa các nút theo chiều ngang
          runSpacing: 8.0, // Khoảng cách giữa các dòng nút theo chiều dọc
          children: list1.map((option) {
            List<String> listOptions = questions[_currentIndex].correctAnswer
                .replaceAll(' ', '').split("");
            List<String> options = listOptions.map((char) => char.toUpperCase())
                .toList();
            String answer = options.join();
            print("answer:${answer}");
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  list.add(option);
                  print("list: $list");
                  list1.remove(option);
                  String combinedWords = list.join();
                  print("combinedWords:${combinedWords}");
                  if (combinedWords == answer) {
                    _correctAnswers++;
                    _currentIndex++;
                    list1.clear();
                    list.clear();
                    choose_dhbc = false;
                  } else if (combinedWords.length >=
                      answer.length) {
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

  // cau hỏi sắp xếp
  Widget _generateOptions_sort() {
    List<String> options = questions[_currentIndex].correctAnswer.split(' ');
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
            if (text == questions[_currentIndex].correctAnswer) {
              setState(() {
                controller.clear();
                _correctAnswers++;
                _currentIndex++;
                choose_dhbc = false;
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

// câu hỏi âm thanh
  Widget _generateOptions_sound() {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            speak(questions[_currentIndex].correctAnswer);
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
                questions[_currentIndex].correctAnswer.toLowerCase()) {
              setState(() {
                controller.clear();
                _correctAnswers++;
                _currentIndex++;
                choose_dhbc = false;
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

  Widget dhbcst() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // Số cột trong GridView
        ),
        itemCount: 25, // Số lượng ô trong GridView
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              if((isSelectedList[index]==0)){
                setState(() {
                  choose_dhbc = true;
                  isSelectedList[index] = 1;
                  selectedIndexes.add(index);
                });
              }
            },
            child: Container(
              margin: EdgeInsets.all(8),
              color:isSelectedList[index]==1 ?Colors.green:isSelectedList[index]==2?Colors.red:Colors.blue, // Màu sắc của ô
              child: Center(
                child: Text(
                  '${index+1}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        });
  }
}
