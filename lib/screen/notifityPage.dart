import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesst_html/models/question.dart';

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
  bool isNoTi = false;
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
          if(id=="1703303369561"){
            isNoTi = true;
          }
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body:  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: GestureDetector(
      onTap: (){
      FocusScope.of(context).unfocus();
      },
        child:list.isEmpty? Stack(
          children: [
            Center(child: Text("không có thông báo",style: TextStyle(fontSize: 20),),),
            isNoTi ?Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                onPressed: ()  {
                  sendNotification();
                }, child: Text("gửi thông báo"),),
            ):Container()
          ],
        ): Container(
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
              isNoTi?Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  onPressed: ()  {
                    sendNotification();
                  }, child: Text("gửi thông báo"),),
              ):Container()
            ],
          ),
        ),
      ),
    )));
  }
}
