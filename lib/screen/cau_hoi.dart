import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesst_html/models/question.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
class CauHoi extends StatefulWidget {
   CauHoi({super.key, required this.type,required this.questions,this.point="0",this.listAnswers = const[],this.listAnswersChoose= const[], this.leverEL = 0,this.title = "",this.leverDHBC = 0});
  final String type ;
   List<Question> questions;
   List<String> listAnswers = [];
   List<String> listAnswersChoose = [];
   String point;
   int leverEL;
   int leverDHBC;
   String title ;
  @override
  State<CauHoi> createState() => _CauHoiState();
}

class _CauHoiState extends State<CauHoi> {
  FlutterTts flutterTts = FlutterTts();

  int _currentIndex = 0; // Chỉ mục của câu hỏi hiện tại
  int _correctAnswers = 0; // Số câu trả lời đúng
  bool choose_dhbc = false;
  List<int> isSelectedList = List.generate(25, (index) => 0);
  List<int> selectedIndexes = [];
  TextEditingController controller = TextEditingController();
  List<Question> questions = [];
  List<String> answers = [];
  List<String> list = [];
  List<String> list1 = [];
  late int point;
  late int _secondsRemaining; // 3 minutes = 180 seconds
  late Timer _timer;
  int leverEL = 0;
  int leverDHBC = 0;
  bool isFirstTime = true;
  List<String> options_dapan = [];
  List<String> options_SapXep = [];
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
    widget.questions.shuffle();
    leverEL = widget.leverEL;
    leverDHBC = widget.leverDHBC;
    if(widget.type == "STT"){
      _secondsRemaining = 120;
      startTimer();
      questions = widget.questions.take(5).toList();
      print("do dai list cau hỏi:");
    }else if(widget.type == "DHBCST"){
      _secondsRemaining = 180;
      startTimer();
      questions = widget.questions;
    }
      else{
      const oneSecond = Duration(seconds: 1);
      _timer = Timer.periodic(oneSecond, (timer){

      });
      questions = widget.questions;
    }
   point = int.parse(widget.point);
   initTts();
   print("do dai list cau hỏi: ${questions.length}");
    super.initState();


  }
  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if(mounted){
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer.cancel();
            if(widget.type == "DHBCST"){
              List<int> subListToCheck = [1, 2, 3, 4, 5];
              List<int> subListToCheck2 = [1, 6, 11, 16, 21];
              List<int> subListToCheck3 = [2, 7, 12, 17, 22];
              List<int> subListToCheck4 = [3, 8, 13, 18, 23];
              List<int> subListToCheck5 = [4, 9, 14, 19, 24];
              List<int> subListToCheck6 = [5, 10, 15, 20, 25];
              List<int> subListToCheck7 = [6, 7, 8, 9, 10];
              List<int> subListToCheck8 = [11, 12, 13, 14, 15];
              List<int> subListToCheck9 = [16, 17, 18, 19, 20];
              List<int> subListToCheck10 = [21, 22, 23, 24, 25];
              List<int> subListToCheck11 = [1, 7, 13, 19, 25];
              List<int> subListToCheck12 = [5, 9, 13, 17, 21];
              if( checkSubList(selectedIndexes, subListToCheck)||
                  checkSubList(selectedIndexes, subListToCheck2)||
                  checkSubList(selectedIndexes, subListToCheck3)||
                  checkSubList(selectedIndexes, subListToCheck4)||
                  checkSubList(selectedIndexes, subListToCheck5)||
                  checkSubList(selectedIndexes, subListToCheck6)||
                  checkSubList(selectedIndexes, subListToCheck7)||
                  checkSubList(selectedIndexes, subListToCheck8)||
                  checkSubList(selectedIndexes, subListToCheck9)||
                  checkSubList(selectedIndexes, subListToCheck10)||
                  checkSubList(selectedIndexes, subListToCheck11)||
                  checkSubList(selectedIndexes, subListToCheck12))
              {
                print("okoko");
                point = point + 100;
                _showDialog(context, true);
              }else{
                print("ko");
                _showDialog(context, false);
              }
            }else if(widget.type == "STT"){
              if((point-int.parse(widget.point))>=200){
                _showDialog(context, true);
              }else{
                _showDialog(context, false);
              }
            }


          }
        });
      }
    });
  }
  bool checkSubList(List<int> mainList, List<int> subList) {
    for (int i = 0; i <= mainList.length - subList.length; i++) {
      bool found = true;
      for (int j = 0; j < subList.length; j++) {
        if (mainList[i + j] != subList[j]) {
          found = false;
          break;
        }
      }
      if (found) {
        return true;
      }
    }
    return false;
  }
  @override
  void dispose() {
    _timer.cancel(); // Cancel timer when the screen is disposed
    super.dispose();
  }
  String getTimerString() {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr = (seconds < 10) ? '0$seconds' : '$seconds';
    return '$minutesStr:$secondsStr';
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
        return StatefulBuilder(
          builder: (BuildContext context, setStates){
            return AlertDialog(
              title: Text("Thông báo"),
              content: Text(pass
                  ? "Chúc mừng bạn đã trả lời đúng hết các câu hỏi.\nBan co muốn chơi tiếp không?"
                  : "Bạn đã trả lời sai, bạn có muốn chơi lại không?"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    String id =  pref.getString("id")??"";
                    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$id");
                    await ref.update({
                      "point":"$point",
                    });
                    if(pass && widget.type == "EL"){
                      leverEL = leverEL + 1;
                      pref.setInt("leverEL",leverEL);
                      int randomNumber = pref.getInt("leverEL")??0;
                      print("randomNumbers: $randomNumber");
                       getDataFromFirebase("ListEnglish/English$randomNumber",(){
                         setState(() {
                           print("questions.lengh: ${questions.length}");
                         });
                      });
                    }else if(pass && widget.type == "DHBC"){
                      leverDHBC = leverDHBC + 1;
                      pref.setInt("leverDHBC",leverDHBC);
                      int randomNumber = pref.getInt("leverDHBC")??0;
                      print("randomNumbers: $randomNumber");
                      getDataFromFirebase("ListQuestion/Question$randomNumber",(){
                        setState(() {
                          print("questions.lengh: ${questions.length}");
                        });
                      });
                    }
                    else if(widget.type == "STT"){
                      _secondsRemaining = 120;
                      widget.questions.shuffle();
                      startTimer();
                      questions = widget.questions.take(5).toList();
                    }else if(widget.type == "DHBCST"){
                      _secondsRemaining = 180;
                      startTimer();
                    }
                    setState(() {
                      _currentIndex = 0;
                      _correctAnswers = 0;
                      questions.shuffle();
                      choose_dhbc = false;
                      isSelectedList = List.generate(25, (index) => 0);
                      selectedIndexes.clear();
                    });
                    Navigator.of(context).pop(); // Đóng Dialog
                  },
                ),
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    String id =  pref.getString("id")??"";
                    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$id");
                    await ref.update({
                      "point":"$point",
                    });
                    if(pass && widget.type == "EL"){
                      leverEL = leverEL + 1;
                      pref.setInt("leverEL",leverEL);
                      print("leverEL :${pref.getInt("leverEL")??0}");
                    }
                    setState(() {
                      _currentIndex = 0;
                      _correctAnswers = 0;
                      questions.shuffle();
                      choose_dhbc = false;
                      isSelectedList = List.generate(25, (index) => 0);
                      selectedIndexes.clear();
                    });
                    // Thực hiện hành động khi người dùng chọn Cancel
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();// Đóng Dialog
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _showDialogExist(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông báo"),
          content: Text(
              "Bạn sẽ chỉ nhận được một nửa điểm số vòng này vì chưa hoàn thành bộ câu hỏi.\nBan vẫn muốn thoát?"
            ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                if(point ==1){
                  point = 0;
                }else{
                  point = (point/2).round();
                }
                SharedPreferences pref = await SharedPreferences.getInstance();
                String id =  pref.getString("id")??"";
                DatabaseReference ref = FirebaseDatabase.instance.ref("users/$id");
                await ref.update({
                  "point":"$point",
                });
                Navigator.of(context).pop(); // Đóng Dialog
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () async {
                Navigator.of(context).pop();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            print("point:${point}");
            print("pointa:${widget.point}");
            if(point>int.parse(widget.point)){
              _showDialogExist(context);
            }else  {
              Navigator.of(context).pop();
            }
          },
        ),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: ()async{
          if(point>int.parse(widget.point)){
            _showDialogExist(context);
          }else{
            Navigator.of(context).pop();
          }
          return false;
        },
        child:questions.isEmpty?Center(child: CircularProgressIndicator(),): Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if(widget.type == "DHBCST"||widget.type == "STT")Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      getTimerString(),
                      style: TextStyle(fontSize: 20,color:Colors.red,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SimpleAnimationProgressBar(
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
                    ),
                    SizedBox(width: 10,),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal.shade100
                        ),
                        child: Text("$point",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _currentIndex == questions.length
                    ?Container()
                    :
                widget.type == "DHBCST"
                ?
                  choose_dhbc
                      ?
                      Column(
                        children: [
                          Text(
                            questions[_currentIndex].questionText,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          questions[_currentIndex].imageContent != ""?Container(
                            color: Colors.transparent,
                            width:
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * 0.5,
                            child: Image.network(
                              questions[_currentIndex]
                                  .imageContent ?? "",fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(child: CircularProgressIndicator()); // Hoặc indicator tải trong quá trình
                                }
                              },
                            ),
                          ):Container(),
                          SizedBox(height: 20),
                          if (questions[_currentIndex].type == "sort")
                            _generateOptions_sort(widget.type),
                          if (questions[_currentIndex].type == "choose")
                            _generateOptions_choose(widget.type),
                          if (questions[_currentIndex].type == "text" ||
                              questions[_currentIndex].type == "image")
                            ..._generateOptions(
                                questions[_currentIndex].correctAnswer,widget.type),
                          if (questions[_currentIndex].type == "sound")
                            _generateOptions_sound(widget.type),
                          if (questions[_currentIndex].type == "image_dhbc")
                            _generateOptions_choose_word(widget.type),
                        ],
                      )
                      :dhbcst()
                :widget.type == "STT"
                ?choose_dhbc
                    ?
                Column(
                      children: [
                        Text(
                 questions[_currentIndex].questionText,
                 style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        questions[_currentIndex].imageContent != ""?Container(
                          color: Colors.transparent,
                          width:
                          MediaQuery
                              .of(context)
                              .size
                              .width * 0.8,
                          height: MediaQuery
                              .of(context)
                              .size
                              .width * 0.5,
                          child: Image.network(
                            questions[_currentIndex]
                                .imageContent ?? "",fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(child: CircularProgressIndicator()); // Hoặc indicator tải trong quá trình
                              }
                            },
                          ),
                        ):Container(),
                        SizedBox(height: 20),
                        if (questions[_currentIndex].type == "sort")
                 _generateOptions_sort(widget.type),
                        if (questions[_currentIndex].type == "choose")
                 _generateOptions_choose(widget.type),
                        if (questions[_currentIndex].type == "text" ||
                   questions[_currentIndex].type == "image")
                 ..._generateOptions(
                     questions[_currentIndex].correctAnswer,widget.type),
                        if (questions[_currentIndex].type == "sound")
                 _generateOptions_sound(widget.type),
                        if (questions[_currentIndex].type == "image_dhbc")
                 _generateOptions_choose_word(widget.type),
                      ],
                    )
                    :Stt()
              :Column(
               children: [
                 Text(
                   questions[_currentIndex].questionText,
                   style: TextStyle(fontSize: 18),
                 ),
                 SizedBox(height: 20),
                 questions[_currentIndex].imageContent != ""?Container(
                   color: Colors.transparent,
                   width:
                   MediaQuery
                       .of(context)
                       .size
                       .width * 0.8,
                   height: MediaQuery
                       .of(context)
                       .size
                       .width * 0.5,
                   child: Image.network(
                       questions[_currentIndex]
                           .imageContent ?? "",fit: BoxFit.cover,
                     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                       if (loadingProgress == null) {
                         return child;
                       } else {
                         return Center(child: CircularProgressIndicator()); // Hoặc indicator tải trong quá trình
                       }
                     },
                   ),
                 ):Container(),
                 SizedBox(height: 20),
                 if (questions[_currentIndex].type == "sort")
                   _generateOptions_sort(widget.type),
                 if (questions[_currentIndex].type == "choose")
                   _generateOptions_choose(widget.type),
                 if (questions[_currentIndex].type == "text" ||
                     questions[_currentIndex].type == "image" )
                   ..._generateOptions(
                       questions[_currentIndex].correctAnswer,widget.type),
                 if (questions[_currentIndex].type == "sound")
                   _generateOptions_sound(widget.type),
                 if (questions[_currentIndex].type == "image_dhbc")
                   _generateOptions_choose_word(widget.type),
               ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// câu hỏi chọn đấp án đúng
  List<Widget> _generateOptions(String correctAnswer,String type) {
    if(type =="STT"){
      if(isFirstTime){
        options_dapan = [questions[_currentIndex].correctAnswer];
        if(questions[_currentIndex].options.isNotEmpty){
          options_dapan.addAll(questions[_currentIndex].options);
        }else{
          options_dapan.addAll(_getRandomAnswers(3));
        }
        options_dapan.shuffle();
        isFirstTime = false;
      }
    }else{
      options_dapan = [questions[_currentIndex].correctAnswer];
      if(questions[_currentIndex].options.isNotEmpty){
        options_dapan.addAll(questions[_currentIndex].options);
      }else{
        options_dapan.addAll(_getRandomAnswers(3));
      }
      options_dapan.shuffle();
    }





    return options_dapan.map((option) {
      return ElevatedButton(
        onPressed: () async {
          // Xử lý khi người dùng chọn câu trả lời
          if (option == questions[_currentIndex].correctAnswer) {
            setState(() {
              _correctAnswers++;
              answers.addAll(widget.listAnswers.isNotEmpty?widget.listAnswers:_answers);
              _currentIndex++;
              choose_dhbc = false;

            });
            SharedPreferences pref = await SharedPreferences.getInstance();
           if(type=="STT" ){
             int pointSTT = pref.getInt("pointSTT")??0;
             setState(() {
               point = point + pointSTT;
             });
            int  id =  pref.getInt("STT")??0;
            id = id + 1;
            await pref.setInt("STT", id);
          }else{
             setState(() {
               point = point + 10;
             });
             int  id =  pref.getInt("English")??0;
             id = id + 1;
             await pref.setInt("English", id);
             if(type=="EL" && _currentIndex==questions.length){
               _showDialog(context, true);
             }
           }

          } else {
            setState(() {
              if(point ==1){
                point = 0;
              }else{
                point = (point/2).round();
              }
            });
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
    answers.addAll(widget.listAnswers.isNotEmpty?widget.listAnswers:_answers);
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
  Widget _generateOptions_choose(String type) {
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
              onPressed: () async {
                  list.add(option);
                  list1.remove(option);
                  String combinedWords = list.join(" ");
                  print("combinedWords:${combinedWords}");
                  if (combinedWords ==
                      questions[_currentIndex].correctAnswer) {
                    setState(() {
                      _correctAnswers++;
                      _currentIndex++;
                      list1.clear();
                      list.clear();
                      choose_dhbc = false;

                    });
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    if(type=="STT" ){
                      int pointSTT = pref.getInt("pointSTT")??0;
                      setState(() {
                        point = point + pointSTT;
                      });
                      int  id =  pref.getInt("STT")??0;
                      id = id + 1;
                      await pref.setInt("STT", id);
                    }else{
                      setState(() {
                        point = point + 10;
                      });
                      int  id =  pref.getInt("English")??0;
                      id = id + 1;
                      await pref.setInt("English", id);
                      if(type=="EL" && _currentIndex==questions.length){
                        _showDialog(context, true);
                      }
                    }
                  } else if (combinedWords.length >
                      questions[_currentIndex].correctAnswer.length) {
                    setState(() {
                      if(point ==1){
                        point = 0;
                      }else{
                        point = (point/2).round();
                      }
                    });
                    _showDialog(context, false);
                    list1.clear();
                    list.clear();
                  }
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
    answers.addAll(widget.listAnswersChoose.isNotEmpty?widget.listAnswersChoose:_answers_choose);
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
  Widget _generateOptions_choose_word(String type) {
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
              onPressed: () async {
                setState(() {
                  list.add(option);
                  print("list: $list");
                  list1.remove(option);
                });
                String combinedWords = list.join();
                print("combinedWords:${combinedWords}");
                  if (combinedWords == answer) {
                    setState(() {
                      _correctAnswers++;
                      _currentIndex++;
                      list1.clear();
                      list.clear();
                      choose_dhbc = false;

                    });
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    if(type=="DHBC"){
                      setState(() {
                        point = point + 10;
                      });
                      int  id =  pref.getInt("dhbc")??0;
                      id = id + 1;
                      await pref.setInt("dhbc", id);
                      if(_currentIndex==questions.length){
                        _showDialog(context, true);
                      }
                    }else if(type=="DHBCST"){
                      setState(() {
                        point = point + 10;
                      });
                      int  id =  pref.getInt("image_dhbc")??0;
                      id = id + 1;
                      await pref.setInt("image_dhbc", id);
                    }else if(type=="STT" ){
                      int pointSTT = pref.getInt("pointSTT")??0;
                      setState(() {
                        point = point + pointSTT;
                      });
                      int  id =  pref.getInt("STT")??0;
                      id = id + 1;
                      await pref.setInt("STT", id);
                    }

                  } else if (combinedWords.length >=
                      answer.length) {
                    setState(() {
                      if(point ==1){
                        point = 0;
                      }else{
                        point = (point/2).round();
                      }
                    });
                    _showDialog(context, false);
                    list1.clear();
                    list.clear();
                  }
              },
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  // cau hỏi sắp xếp
  Widget _generateOptions_sort(String type) {
    if(type == "STT"){
      if(isFirstTime){
        options_SapXep = questions[_currentIndex].correctAnswer.split(' ');
        options_SapXep.shuffle();
          isFirstTime = false;
      }
    }else{
      options_SapXep = questions[_currentIndex].correctAnswer.split(' ');
      options_SapXep.shuffle();
    }
    return Column(
      children: [
        Wrap(
          spacing: 8.0, // Khoảng cách giữa các nút theo chiều ngang
          runSpacing: 8.0, // Khoảng cách giữa các dòng nút theo chiều dọc
          children: options_SapXep.map((option) {
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
          onSubmitted: (text) async {
            if (text == questions[_currentIndex].correctAnswer) {
              setState(() {
                controller.clear();
                _correctAnswers++;
                _currentIndex++;
                choose_dhbc = false;
              });
              SharedPreferences pref = await SharedPreferences.getInstance();
              if(type=="STT" ){
                int pointSTT = pref.getInt("pointSTT")??0;
                setState(() {
                  point = point + pointSTT;
                });
                int  id =  pref.getInt("STT")??0;
                id = id + 1;
                await pref.setInt("STT", id);
              }else{
                setState(() {
                  point = point + 10;
                });
                int  id =  pref.getInt("English")??0;
                id = id + 1;
                await pref.setInt("English", id);
                if(type=="EL" && _currentIndex==questions.length){
                  _showDialog(context, true);
                }
              }


            } else if (text.isNotEmpty) {
              setState(() {
                if(point ==1){
                  point = 0;
                }else{
                  point = (point/2).round();
                }
              });
              controller.clear();
              _showDialog(context, false);
            }
          },
        )
      ],
    );
  }

// câu hỏi âm thanh
  Widget _generateOptions_sound(String type) {
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
          onSubmitted: (text) async {
            if (text.toLowerCase() ==
                questions[_currentIndex].correctAnswer.toLowerCase()) {
              setState(() {
                controller.clear();
                _correctAnswers++;
                _currentIndex++;
                choose_dhbc = false;

              });
              SharedPreferences pref = await SharedPreferences.getInstance();
              if(type=="STT" ){
                int pointSTT = pref.getInt("pointSTT")??0;
                setState(() {
                  point = point + pointSTT;
                });
                int  id =  pref.getInt("STT")??0;
                id = id + 1;
                await pref.setInt("STT", id);
              }else{
                setState(() {
                  point = point + 10;
                });
                int  id =  pref.getInt("English")??0;
                id = id + 1;
                await pref.setInt("English", id);
                if(type=="EL" && _currentIndex==questions.length){
                  _showDialog(context, true);
                }
              }

            } else if (text.isNotEmpty) {
              setState(() {
                if(point ==1){
                  point = 0;
                }else{
                  point = (point/2).round();
                }
              });
              controller.clear();
              _showDialog(context, false);
            }
          },
        )
      ],
    );
  }

  Widget dhbcst() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
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
                    selectedIndexes.add(index+1);
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
          }),
    );
  }
  Widget Stt(){
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 30.0,
        ),
            itemCount: 4, // Số lượng ô trong GridView
            itemBuilder: (BuildContext context, int index) {
              int randomNumber = Random().nextInt(5) + 0;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,),
                child: FlipCard(
                    onFlipDone: (a) async {
                      if(a){
                       setState(() {
                         choose_dhbc = true;
                       });
                       SharedPreferences pref = await SharedPreferences.getInstance();
                       await pref.setInt("pointSTT", randomNumber*10);
                       print("pointSTT :${pref.getInt("pointSTT")??0}");
                      }
                    },
                    direction: FlipDirection.HORIZONTAL, // Lật theo chiều ngang
                    front:Container(
                      decoration:  const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/img.jpg"),
                            fit: BoxFit.cover),
                        // borderRadius: BorderRadius.circular(8)
                      ),
                      // margin: EdgeInsets.symmetric(vertical:10,horizontal: 5),
                    ),
                    back: Container(
                      color: Colors.grey[400],
                      child: Center(child: Text("${randomNumber*10}")),
                    )
                ),
              );
        }
        ),
      ),
    );
  }
  Future<void> getDataFromFirebase( String link,Function() tap) async {
    List<Question> listQ = [];
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref(link);
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("objessssctdata:$data");
      if (data != null) {
        List<dynamic> dataList = data as List<dynamic>;
        for (var item in dataList) {
          if (item != null) {
            // Tạo một đối tượng Question từ dữ liệu Firebase và thêm vào danh sách
            Question question = Question(
                id: item['id']!=null?item['id'].toString():"",
                correctAnswer: item['correctAnswer']!=null?item['correctAnswer'].toString():"",
                type: item['type'] !=null ?item['type'].toString():"text",
                questionText: item['questionText']!=null?item['questionText'].toString():"",
                imageContent: item['imageContent'] != null ? item['imageContent'].toString() : '',
                options: item['options'] != null ? List<String>.from(item['options'] ?? []):[]
            );
            listQ.add(question);
          }}}
      questions = listQ;
    });
    if(questions.isNotEmpty) {
      tap();
    }
  }
}
