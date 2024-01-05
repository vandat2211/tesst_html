import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../models/question.dart';

class BxhScreen extends StatefulWidget {
  const BxhScreen({super.key});

  @override
  State<BxhScreen> createState() => _BxhScreenState();
}

class _BxhScreenState extends State<BxhScreen> {
  List<User> list = [];
  bool isVisible = true;
  bool checkFuture = false;
  AutoScrollController controller = AutoScrollController();
  final _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> listhh = ["hh1.png","hh2.png","hh3.png","hh4.png","hh5.png","hh6.png"];

  @override
  void initState() {
    getDS();
    super.initState();
    controller.addListener(_onScroll);
  }
  @override
  void dispose() {
    controller.dispose();
  _searchController.clear();
    super.dispose();
  }
  Future<void> getDS() async {
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("users/");
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("objectdata:$data");
      if (data != null) {
        final a = jsonEncode(data);
        Map<String, dynamic> firebaseData = jsonDecode(a);
        // Chuyển đổi dữ liệu từ Map sang List
        List<User> userList = firebaseData.values.map((value) {
          return User.fromJson(value.cast<String, dynamic>());
        }).toList();
        // Sắp xếp userList theo trường 'point' giảm dần
        userList.sort((a, b) => int.parse(b.point).compareTo(int.parse(a.point)));
        if(mounted){
          setState(() {
            list = userList.take(50).toList();
          });
        }
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

  void _onSearch(List<User> listUser, String query) {
    List<User> listUser1 = List.from(listUser);
    List<User> listUser2 = [];
    if(query.isNotEmpty){
      for (int i = 0; i < listUser1.length; i++) {
        User element = listUser1[i];
          if (element.name.toLowerCase().contains(query.toLowerCase())) {
            listUser2.add(element);
          }
        }

    }else{
      listUser2.addAll(listUser1);
    }


    setState(() {
      list = listUser2;
    });
    print("list:$list");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            color:Colors.transparent,
            child: Stack(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    controller: controller,
                    itemCount: list.length,
                      itemBuilder: (context,index){
                        if(int.parse(list[index].point)>=100){
                          list[index].hh = listhh[5];
                        } if(int.parse(list[index].point)>=200){
                          list[index].hh = listhh[4];
                        } if(int.parse(list[index].point)>=300){
                          list[index].hh = listhh[3];
                        } if(int.parse(list[index].point)>=400){
                          list[index].hh = listhh[2];
                        } if(int.parse(list[index].point)>=500){
                          list[index].hh = listhh[1];
                        } if(int.parse(list[index].point)>=600){
                          list[index].hh = listhh[0];
                        }
                    return Container(
                      decoration: BoxDecoration(
                        color:index==0||index==1||index==2?Colors.teal.shade100:Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: Container(
                          width: 130,
                          child: Row(
                            children: [
                              Container(width:30,child: Text("${index+1}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:index == 0? Colors.redAccent:index == 1?Colors.blueAccent:index == 2?Colors.teal:Colors.black),)),
                            SizedBox(width: 10,),
                              VerticalDivider(color: Colors.teal,),
                              SizedBox(width: 5,),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:Colors.white30
                                ),
                                child:SvgPicture.asset(
                                  'assets/svg_avata/${list[index].tt_image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: Text(list[index].name,style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold) ,),
                        subtitle: Text(list[index].point,style: TextStyle(fontSize: 15,color: Colors.red,fontWeight: FontWeight.bold),),
                        trailing: Container(
                            width: 50,
                            height: 50,
                            child:list[index].hh.isNotEmpty?Image(image: AssetImage('assets/hh/${list[index].hh}')):Container()),
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
                              hintText: 'Tìm kiếm',
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
