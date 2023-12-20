import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  List<String> listAvata = ["ic_vneid_v.png","flutter.png"];
  TextEditingController controller = TextEditingController();
  String link = "ic_vneid_v.png";
   int percentDHBC = 0,percentDHBCST = 0,percentEL = 0,percentSGH = 0,percentSTT = 0;
   List<double> listLineChart =[];
   bool ispageView = true;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    getDLPieChart();
    getDLLineChart();
    super.initState();
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
            listLineChart = [mo/100,tu/100,we/100,th/100,fr/100,sa/100,su/100];
            print("mo : $mo, tu :$tu, we :$we, th :$th, fr :$fr, sa :$sa, su :$su");
          });
        }
      }});
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40, // Đường kính của hình tròn
                      backgroundImage: AssetImage("assets/images/$link"),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("dat",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text("1000",style: TextStyle(fontSize: 15,color: Colors.redAccent),)
                        ],
                      ),
                    )
                  ],
                ), Container(
                  width: 30,
                    height: 30,
                    child: Image(image: AssetImage('assets/images/flutter.png')))
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
          title: Text("Thông báo"),
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
                      onTap: (){
                        setState(() {
                          link = listAvata[index];
                          print("linkkk:$link");
                        });
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 40, // Đường kính của hình tròn
                        backgroundImage: AssetImage("assets/images/${listAvata[index]}"),
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
                  errorText:!irError? null:"ok",
                  labelText: 'Enter your text',
                  hintText: 'Type something...',
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
