import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_of_year/week_of_year.dart';

import '../components/chartPage.dart';
import '../components/core_toast.dart';
import '../components/widget/buttonCustom.dart';
import '../models/question.dart';

class ProFileScreen extends StatefulWidget {
  const ProFileScreen({super.key});

  @override
  State<ProFileScreen> createState() => _ProFileScreenState();
}

class _ProFileScreenState extends State<ProFileScreen> {
  List<String> listAvata = [];
  TextEditingController controller = TextEditingController();
  String link = "";
   int percentDHBC = 0,percentDHBCST = 0,percentEL = 0,percentSGH = 0,percentSTT = 0;
   List<double> listLineChart =[];
   bool ispageView = true;
  FocusNode focusNode = FocusNode();
  String point = "";
  String name= "";
  List<String> listhh = ["hh1.png","hh2.png","hh3.png","hh4.png","hh5.png","hh6.png"];
  String hh = "";
  @override
  void initState() {
    getAvata();
    getDLPieChart();
    getDLLineChart();
    super.initState();
  }
  getAvata(){
    for(int i =1 ;i<=40;i++){
      setState(() {
        listAvata.add("$i.svg");
      });
    }
  }
  Future<void> getDLPieChart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int  count =  pref.getInt("English")??0;
    int  count2 =  pref.getInt("image_dhbc")??0;
    int  count3 =  pref.getInt("dhbc")??0;
    int  count4 =  pref.getInt("STT")??0;
    int  count5 =  pref.getInt("SGH")??0;
    int total = count + count2 + count3 + count4 + count5;
    setState(() {
      if(total!=0){
        percentDHBC = ((count3/total)*100).round();
        percentDHBCST = ((count2/total)*100).round();
        percentEL = ((count/total)*100).round();
        percentSGH = ((count5/total)*100).round();
        percentSTT = ((count4/total)*100).round();
        int totalRounded = percentDHBC +
            percentDHBCST +
            percentEL +
            percentSGH +
            percentSTT;
        int difference = 100 - totalRounded;
        if(difference != 0){
          percentEL = percentEL - difference;
        }
      }else{

      }

    });

    print("English : ${count}");
    print("image_dhbc : ${(count2/total)*100}");
    print("dhbc : ${(count3/total)*100}");
    print("STT : ${(count4/total)*100}");
    print("SGH : ${(count5/total)*100}");
  }
  Future<void> getDLLineChart() async {
    // Lấy số tuần hiện tại
    int weekNumber =  DateTime.now().weekOfYear;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("week", weekNumber);
    String id =  pref.getString("id")??"";
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("users/$id");
    starCountRef.onValue.listen((DatabaseEvent event) async {
      final data = event.snapshot.value;
      print("objectdata:$data");
      if (data != null) {
        final a = jsonEncode(data);
        Map<String, dynamic> dataMap = jsonDecode(a);
        User user = User.fromJson(dataMap);
        if (DateTime.now().weekday == 1) {
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
        double  mo =  pref.getDouble("Mo")??double.parse(user.point);
        double  tu =  pref.getDouble("Tu")??double.parse(user.point);
        double  we =  pref.getDouble("We")??double.parse(user.point);
        double  th =  pref.getDouble("Th")??double.parse(user.point);
        double  fr =  pref.getDouble("Fr")??double.parse(user.point);
        double  sa =  pref.getDouble("Sa")??double.parse(user.point);
        double  su =  pref.getDouble("Su")??double.parse(user.point);
        if(mounted){
          setState(() {
            point= user.point;
            name =user.name;
            link = user.tt_image;
            if(int.parse(point)>=100){
              hh = listhh[5];
            } if(int.parse(point)>=200){
              hh = listhh[4];
            } if(int.parse(point)>=300){
              hh = listhh[3];
            } if(int.parse(point)>=400){
              hh = listhh[2];
            } if(int.parse(point)>=500){
              hh = listhh[1];
            } if(int.parse(point)>=600){
              hh = listhh[0];
            }
            print("hhh:$hh");
            listLineChart = [mo/100,tu/100,we/100,th/100,fr/100,sa/100,su/100];
            print("mo : $mo, tu :$tu, we :$we, th :$th, fr :$fr, sa :$sa, su :$su");
          });
        }
      }});
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.teal.shade50,
                      ),
                      child:link.isNotEmpty? SvgPicture.asset(
                        'assets/svg_avata/$link',
                        fit: BoxFit.cover,
                      ):Container(),
                    ),
                    SizedBox(width: 20,),
                    Container(

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User: $name",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          RichText(
                            text:  TextSpan(
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Point: ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:Colors.black
                                  ),
                                ),
                                TextSpan(
                                  text: point,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:Colors.redAccent
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ), hh.isNotEmpty?Container(
                    width: 50,
                    height: 50,
                    child: Image(image: AssetImage('assets/hh/$hh'))):Container()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:15 ),
            child: Row(
              children: [
                Expanded(
                  child: ButtonCusTom(
                    title: 'Đổi avata', onPressed: (){
                    showCustomDialog(context,true);
                  },),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: ButtonCusTom(
                    title: 'Đổi tên', onPressed: (){
                    showCustomDialog(context,false);
                  },),
                )
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                PageView(
                  onPageChanged: (index){
                    setState(() {
                      ispageView = !ispageView;
                    });
                  },
                  children: [
                    ChartPage(isLineChart: false, listDLPie: [percentDHBC.toDouble(),percentDHBCST.toDouble(),percentEL.toDouble(),percentSGH.toDouble(),percentSTT.toDouble()], listDLLine: [],),
                    ChartPage(isLineChart: true, listDLPie: [], listDLLine: listLineChart,)
                  ],
                ),
                Visibility(
                  visible: ispageView,
                  child: Positioned(
                  right: 3,
                      top: 150,
                      child: Icon(Icons.arrow_forward_ios)),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
  void showCustomDialog(BuildContext context,bool changeAvaTa) {
    bool irError = false;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(changeAvaTa?"Avata":"Đổi tên"),
          content:changeAvaTa?
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listAvata.length,
                  shrinkWrap: true,
                    itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          link = listAvata[index];
                          print("linkkk:$link");
                        });
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        String id =  pref.getString("id")??"";
                        DatabaseReference ref = FirebaseDatabase.instance.ref("users/$id");
                        await ref.update({
                          "tt_image":link,
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.teal.shade50,
                        ),
                        child: SvgPicture.asset(
                          'assets/svg_avata/${listAvata[index]}',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                    }),
              )
              :StatefulBuilder(
            builder: (BuildContext context, setStates){
              return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                onChanged: (value){
                  setStates(() {
                    irError = value.isEmpty; // Cập nhật irError khi có thay đổi trong TextField
                  });
                },
                decoration: InputDecoration(
                  errorText:!irError? null:"Tên người chơi không được để trống!",
                  labelText: 'Tên người chơi',
                  hintText: 'Vui lòng nhập tên',
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
              );
            }
          ),
          actions: changeAvaTa?null:<Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                  if(controller.text.isEmpty){
                    Toast.showLongTop("Không đươợc để trống");
                  }else{
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    String id =  pref.getString("id")??"";
                    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$id");
                    await ref.update({
                      "name":controller.text,
                    });

                    setState(() {

                    });
                    Navigator.of(context).pop(); // Đóng Dialog

                  }


              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: ()  {
                Navigator.of(context).pop();// Đóng Dialog
              },
            ),
          ],
        );
      },
    );
  }
}
