import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesst_html/components/widget/buttonCustom.dart';
import 'package:tesst_html/models/question.dart';

import '../components/core_toast.dart';
import 'detailTBPage.dart';

class NotifityPage extends StatefulWidget {
  const NotifityPage({super.key});

  @override
  State<NotifityPage> createState() => _NotifityPageState();
}

class _NotifityPageState extends State<NotifityPage> {
  List<Mes> list = [];
  bool isVisible = true;
  bool checkFuture = false;
  AutoScrollController controller = AutoScrollController();
  final _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  TextEditingController controllerKey = TextEditingController();
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerContent = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool irError = false;
  bool _isBottomSheetVisible = false;
  bool visibleInputNoTi = false;
  @override
  void initState() {
    getDS();
    controller.addListener(_onScroll);
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    _searchController.clear();
    super.dispose();
  }
  Future<void> getDS() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String id =  pref.getString("id")??"";
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("users/$id/listTB");
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("lisstTB:$data");
      if (data != null) {
        final a = jsonEncode(data);
        Map<String, dynamic> firebaseData = jsonDecode(a);
        // Chuyển đổi dữ liệu từ Map sang List
        List<Mes> listTB = firebaseData.values.map((value) {
          return Mes.fromJson(value.cast<String, dynamic>());
        }).toList();
        // Sắp xếp danh sách theo trường timestamp
        listTB.sort((a, b) => b.idTB.compareTo(a.idTB));
        setState(() {
          list = listTB;
        });

      }
    });
  }
  void _onScroll() {
    ScrollDirection direction = controller.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      if(mounted){
        setState(() {
          isVisible = false;
        });
      }
    } else if(direction == ScrollDirection.forward) {
      if(mounted ){
        setState(() {
          isVisible = true;
        });
      }
    }
    if(!isVisible && !checkFuture ){
      checkFuture = true;
      final future = Future.delayed(Duration(seconds: 10), () {
        if (!_focusNode.hasFocus && mounted){
          setState(() {
            isVisible = true;
          });
        }
      });
      future.whenComplete(() => checkFuture=false);
    }

  }

  void _onSearch(List<Mes> list, String query) {
    List<Mes> list1 = List.from(list);
    List<Mes> list2 = [];
    if(query.isNotEmpty){
      for (int i = 0; i < list1.length; i++) {
        Mes element = list1[i];
        if (element.title.toLowerCase().contains(query.toLowerCase())) {
          list2.add(element);
        }
      }

    }else{
      list2.addAll(list1);
    }


    setState(() {
      list = list2;
    });
    print("list:$list");
  }
  void sendNotification(String title,String content) async {
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
              'title': title,
              'body': content,
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
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context,setStates){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thông báo',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                            borderRadius:  BorderRadius.circular(30),
                            onTap:(){
                              Navigator.pop(context);
                            },child: Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.close)))
                      ],
                    ),
                    !visibleInputNoTi?Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: controllerKey,
                        focusNode: focusNode,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          errorText:!irError? null:"Nếu bạn là quản trị viên thì vui lòng nhập mã đã được cấp!",
                          labelText: 'Mã thông báo',
                          hintText: 'Vui lòng mã',
                          errorStyle: TextStyle(overflow: TextOverflow.clip),
                          labelStyle: TextStyle(
                            color: Colors.blue, // Màu chữ cho label
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey, // Màu chữ cho hint text
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue, // Màu viền khi focus vào TextField
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey, // Màu viền khi không focus
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white, // Màu nền cho TextField
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                        ),
                      ),
                    ):Container(),
                    visibleInputNoTi?TextField(
                      controller: controllerTitle,
                      decoration: InputDecoration(
                        labelText: 'Tên thông báo',
                        hintText: 'Vui lòng nhập tên thông báo',
                        labelStyle: TextStyle(
                          color: Colors.blue, // Màu chữ cho label
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey, // Màu chữ cho hint text
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue, // Màu viền khi focus vào TextField
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Màu viền khi không focus
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white, // Màu nền cho TextField
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                      ),
                    ):Container(),
                    visibleInputNoTi?Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: controllerContent,
                        decoration: InputDecoration(
                          labelText: 'Nội dung thông báo',
                          hintText: 'Vui lòng nội dung',
                          labelStyle: TextStyle(
                            color: Colors.blue, // Màu chữ cho label
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey, // Màu chữ cho hint text
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue, // Màu viền khi focus vào TextField
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey, // Màu viền khi không focus
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white, // Màu nền cho TextField
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                        ),
                      ),
                    ):Container(),
                    SizedBox(height: 16.0),
                    ButtonCusTom(
                      title: visibleInputNoTi?"Gửi thông báo":"Tiếp tục",
                      onPressed: () async {
                        if(!visibleInputNoTi){
                          if(controllerKey.text == "221120"){
                            setStates(() {
                              visibleInputNoTi = true;
                            });
                          }else{
                            setStates(() {
                              irError = true;
                            });
                          }
                        }else{
                          if(controllerTitle.text.isNotEmpty && controllerContent.text.isNotEmpty){
                            sendNotification(controllerTitle.text,controllerContent.text);
                            Navigator.pop(context);
                          }else{
                            setStates(() {
                              Toast.showLongTop("Bạn phải nhập đầy đủ tên, nội dung thông báo");
                            });
                          }
                        }

                      },
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      _isBottomSheetVisible = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      body:Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        onDoubleTap: (){
          setState(() {
            visibleInputNoTi = false;
            _isBottomSheetVisible = true;
            irError  = false;
            controllerKey.clear();
            controllerTitle.clear();
            controllerContent.clear();
          });
          if(_isBottomSheetVisible){
            _showBottomSheet(context);
          }

        },
        child:list.isEmpty? Center(child: Text("không có thông báo",style: TextStyle(fontSize: 20),),): Container(
          height: MediaQuery.of(context).size.height,
          color:Colors.transparent,
          child: Stack(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  controller: controller,
                  itemCount: list.length,
                  itemBuilder: (context,index){
                    return Container(
                      decoration: BoxDecoration(
                          color:list[index].isSeen?Colors.teal.shade50:Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailTBPage(mes: list[index],)),
                          );
                          String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          String id =  pref.getString("id")??"";
                          DatabaseReference ref = FirebaseDatabase.instance.ref("users/$id/listTB/${list[index].idTB}");
                          await ref.update({
                            "timeSeen":formattedDate,
                            "isSeen":true
                          });
                        },
                        title: Text(list[index].title,style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold) ,),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            list[index].isSeen?
                            Text(list[index].timeSeen,style: TextStyle(fontSize: 15,color: Colors.black45,fontWeight: FontWeight.bold),):
                            Text(list[index].time,style: TextStyle(fontSize: 15,color: Colors.black45,fontWeight: FontWeight.bold),),
                            list[index].isSeen?
                            const Icon(Icons.remove_red_eye_rounded,color: Colors.red,):
                            const Icon(Icons.check_circle_rounded,color: Colors.grey,),
                          ],
                        ),
                      ),
                    );
                  }),
              AnimatedContainer(
                margin: EdgeInsets.all(8),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: !isVisible ? MediaQuery.of(context).size.width : 0.0,
                height:  !isVisible ? 50 : 0.0,
                decoration: BoxDecoration(
                  color:Color(0x15FFFFFF),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: !isVisible
                    ? SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(-1, 0),
                    end: Offset(0, 0),
                  ).animate(CurvedAnimation(
                    parent: ModalRoute.of(context)!.animation!,
                    curve: Curves.easeInOut,
                  )),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color:isVisible?Color(0x15FFFFFF): Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                          hintText: 'Tìm kiếm thông báo',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          suffixIcon:_searchController.text.isNotEmpty? IconButton(onPressed: () {
                            setState(() {
                              isVisible = true;
                              _searchController.clear();
                            });
                          }, icon: Icon(Icons.clear),):null
                      ),
                      onChanged: (text){
                        _onSearch(list, text);
                      },
                    ),
                  ),
                )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    ),
    ));
  }
}
