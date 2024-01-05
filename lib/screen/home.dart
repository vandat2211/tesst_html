import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flip_card/flip_card_controller.dart';
import 'package:marquee/marquee.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tesst_html/screen/sieuGhepHinh.dart';
import 'package:firebase_database/firebase_database.dart';
import 'cau_hoi.dart';
import '../models/question.dart';
import 'package:week_of_year/week_of_year.dart';
class HomePage extends StatefulWidget {
   HomePage({super.key,});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Khai báo biến Timer
  Timer? _timer,_timer1,_timer2;
  // Khai báo FlipCardController
  final _controller = FlipCardController();
  final _controller1 = FlipCardController();
  final _controller2 = FlipCardController();
  int leverEL = 0;
  int leverDBHc = 0;
  int activeIndex=0;
  List<Question> list= [];
  List<String> listAnswers = [];
  List<String> listAnswersChoose = [];
  List<String> listImageSGH = [];
   String name ="";
  String point ="";
  List<String> listImage = [];
  List<String> listImage2 = [];
  List<String> listImage3 = [];
  List<String> listImage4 = [];
  List<String> listImage5 = [];
  @override
  void initState() {
    var random = Random();
    int randomNumber = random.nextInt(8) + 1;
    int randomNumber1 = random.nextInt(6) + 1;
    int randomNumber2 = random.nextInt(5) + 1;
    // Khởi tạo Timer với thời gian 3 giây
    _timer = Timer.periodic(Duration(seconds: randomNumber), (timer) {
      // Gọi hàm toggleCard của FlipCardController để lật thẻ
      _controller.toggleCard();
    });
    _timer1 = Timer.periodic(Duration(seconds: randomNumber1), (timer) {
      // Gọi hàm toggleCard của FlipCardController để lật thẻ
      _controller1.toggleCard();
    });
    _timer2 = Timer.periodic(Duration(seconds: randomNumber2), (timer) {
      // Gọi hàm toggleCard của FlipCardController để lật thẻ
      _controller2.toggleCard();
    });
    getLever();
    getUserInfo();
    getDataListAnsers();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer1?.cancel();
    _timer2?.cancel();
  }
  getLever() async {
    int weekNumber =  DateTime.now().weekOfYear;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("week", weekNumber);
    int randomNumber = pref.getInt("leverEL")??0;
    int leverDBHC = pref.getInt("leverDBHC")??0;
    setState(() {
      leverEL = randomNumber;
      leverDBHc = leverDBHC;
    });
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
      list = listQ;
      if(list.isNotEmpty){
        tap();
      }
      print("listlist:${list[0].type}");

    });
  }
  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    print("okoko");
    super.didUpdateWidget(oldWidget);
  }
  Future<void> getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
   String id =  pref.getString("id")??"";
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("users/$id");
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("objectdata:$data");
      if (data != null) {
        final a = jsonEncode(data);
        Map<String, dynamic> dataMap = jsonDecode(a);
        User user = User.fromJson(dataMap);
        name = user.name;
        point = user.point;
        print("aaaaaaaaaaa:${user.name}");
       }
    });
  }
  void getDataListAnsers(){
    List<String> stringList = [];
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("ListEnglish/anser1");
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("listAnser:$data");
      if (data != null) {
        List<dynamic> dataList = data as List<dynamic>;
        for (var item in dataList) {
          if (item != null) {
            stringList.add(item);
          }}
        print("stringList :${stringList}");
        setState(() {
          listAnswers = stringList;
        });
      }
    });

    List<String> listImages = [];
    DatabaseReference ref2 =
    FirebaseDatabase.instance.ref("link_image/imageDHBC");
    ref2.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("listImage:$data");
      if (data != null) {
        List<dynamic> dataList = data as List<dynamic>;
        for (var item in dataList) {
          if (item != null) {
            listImages.add(item);
          }}
        print("listImage :${listImages}");
        setState(() {
          listImage = listImages;
        });
      }
    });

    List<String> listImage2s = [];
    DatabaseReference ref3 =
    FirebaseDatabase.instance.ref("link_image/imageLearnEL");
    ref3.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("listImage:$data");
      if (data != null) {
        List<dynamic> dataList = data as List<dynamic>;
        for (var item in dataList) {
          if (item != null) {
            listImage2s.add(item);
          }}
        print("listImage :${listImage2s}");
        setState(() {
          listImage2 = listImage2s;
        });
      }
    });

    List<String> listImage3s = [];
    DatabaseReference ref3s =
    FirebaseDatabase.instance.ref("link_image/imageDHBCST");
    ref3s.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("listImage:$data");
      if (data != null) {
        List<dynamic> dataList = data as List<dynamic>;
        for (var item in dataList) {
          if (item != null) {
            listImage3s.add(item);
          }}
        print("listImage :${listImage3s}");
        setState(() {
          listImage3 = listImage3s;
        });
      }
    });

    List<String> listImage4s = [];
    DatabaseReference ref4s =
    FirebaseDatabase.instance.ref("link_image/imageSGH");
    ref4s.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("listImage:$data");
      if (data != null) {
        List<dynamic> dataList = data as List<dynamic>;
        for (var item in dataList) {
          if (item != null) {
            listImage4s.add(item);
          }}
        print("listImage :${listImage4s}");
        setState(() {
          listImage4 = listImage4s;
        });
      }
    });

    List<String> listImage5s = [];
    DatabaseReference ref5s =
    FirebaseDatabase.instance.ref("link_image/imageSTT");
    ref5s.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("listImage:$data");
      if (data != null) {
        List<dynamic> dataList = data as List<dynamic>;
        for (var item in dataList) {
          if (item != null) {
            listImage5s.add(item);
          }}
        print("listImage :${listImage5s}");
        setState(() {
          listImage5 = listImage5s;
        });
      }
    });
  }
  void getDataListImageSGH(String link,Function() tap) {
    List<String> stringList = [];
    DatabaseReference ref =
    FirebaseDatabase.instance.ref(link);
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("listimageSGH:$data");
      if (data != null) {
        List<dynamic> dataList = data as List<dynamic>;
        for (var item in dataList) {
          if (item != null) {
            stringList.add(item);
          }
        }
        print("stringList :${stringList}");
        setState(() {
          listImageSGH = stringList;
        });
        if(listImageSGH.isNotEmpty){
          tap();
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listImage.isEmpty||listImage2.isEmpty||listImage3.isEmpty||listImage4.isEmpty||listImage5.isEmpty?Center(child: CircularProgressIndicator(),): Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Xin chào $name",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.teal.shade100
                    ),
                    child: Text(point,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: slide(listImage,listImage.length,"Đuổi hình bắt chữ",() async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  int leverDHBC = pref.getInt("leverDHBC")??0;
                   getDataFromFirebase('ListQuestion/Question$leverDHBC',(){
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => CauHoi(type: 'DHBC', questions: list,point: point,title: "Đuổi hình bắt chữ",)),
                     );
                   });
                },"Bài ${leverDBHc+1}"),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: flipCard("DHBC siêu tốc",(){
                  getDataFromFirebase('ListQuestion/QuestionDHBCST/',(){
                      print("vao day3");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CauHoi(type: 'DHBCST', questions: list,point: point,title: "DHBC siêu tốc",)),
                      );
                  });
                },_controller,listImage3),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: flipCard("Siêu ghép hình",()  {
                  getDataListImageSGH('listImageSGH',(){
                    print("vao day sgh");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SieuGhepHinhScreen(point: point,title: "Siêu ghép hình", listImageSGH: listImageSGH,)),
                    );
                  });
                },_controller1,listImage4),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: flipCard("Siêu thử thách",(){
                  getDataFromFirebase('listSTT',(){
                    print("vao day3");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CauHoi(type: 'STT', questions: list,listAnswers: listAnswers,listAnswersChoose: [],point: point,title:"Siêu thử thách" ,)),
                    );
                  });
                },_controller2,listImage5),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 2,
                child: slide(listImage2, listImage2.length,"Học Englist cùng tôi",() async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  int randomNumber = pref.getInt("leverEL")??0;
                  print("randomNumbers: $randomNumber");
                  getDataFromFirebase("ListEnglish/English$randomNumber",(){
                    print("vao day3");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CauHoi(title: "Học Englist cùng tôi",type: 'EL', questions: list,point: point,listAnswers: listAnswers,listAnswersChoose: [], leverEL: randomNumber,)),
                    );
                  });
                },"Bài ${leverEL+1}"),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget slide(List<String> listImage,int length,String title,Function() tap,String subTitle){
    return GestureDetector(
      onTap: tap,
      child: GridTile(
          footer:  Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8)),
            ),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 60,
              child: GridTileBar(
                backgroundColor: Colors.black12,
                title:Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                subtitle: Text(subTitle,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
              ),
            ),
          ),
          child:   GestureDetector(
            onTap: tap,
            child: Stack(
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      autoPlayInterval: Duration(seconds: 2),
                      enlargeCenterPage: true,
                      onPageChanged:(index,reason){
                        setState(() {
                          activeIndex=index;
                        });
                      }
                  ),
                  itemCount: length,
                  itemBuilder: (context,index,realindex){
                    final urlImage=listImage[index];
                    return buildImage(urlImage,index);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedSmoothIndicator(
                      effect: ScrollingDotsEffect(dotWidth: 10,activeDotColor: Colors.blue,dotHeight:10 ),
                      activeIndex: activeIndex,
                      count: length
                  ),
                )

              ],
            ),
          )),
    );
  }
  Widget buildImage(String urlImage,int index)=>
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(urlImage),
              fit: BoxFit.cover),
          // borderRadius: BorderRadius.circular(8)
        ),
        // margin: EdgeInsets.symmetric(vertical:10,horizontal: 5),
      );
  Widget flipCard(String title,Function() tap,FlipCardController controller,List<String> listImage){
      return GestureDetector(
        onTap:tap,
        child: GridTile(
            footer:  Material(
              color: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 40,
                child: GridTileBar(
                  backgroundColor: Colors.black12,
                  title:Marquee(
                    text: title,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                    blankSpace: 100.0,
                    velocity: 50.0,
                    pauseAfterRound: Duration(seconds: 1),
                    accelerationDuration: Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
              ),
            ),
            child:   Stack(
              children: [
                FlipCard(
                  controller: controller,
                    direction: FlipDirection.HORIZONTAL, // Lật theo chiều ngang
                    front:Container(
                      decoration:  BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(listImage[0]),
                            fit: BoxFit.cover),
                        // borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                    back: Container(
                      decoration:  BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(listImage[1]),
                            fit: BoxFit.cover),
                        // borderRadius: BorderRadius.circular(8)
                      ),
                    )
                ),
                Container(
                  color: Colors.transparent,
                )
              ],
            ) ),
      );
  }
}
