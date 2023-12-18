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
import 'package:tesst_html/sieuGhepHinh.dart';
import 'package:firebase_database/firebase_database.dart';
import 'cau_hoi.dart';
import 'models/question.dart';
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
  int activeIndex=0;
  List<Question> list= [];
  List<String> listAnswers = [];
  List<String> listAnswersChoose = [];
   String name ="";
  String point ="";
  List<String> listImage = ["https://cdn.tgdd.vn//GameApp/-1//toan-bo-dap-an-game-bat-chu-duoi-hinh-bat-chu111-800x545-800x545.jpg",
  "https://sort.vn/upload_images/images/2022/01/10/Duoi-hinh-bat-chu-offline-640.jpg",
  "https://giasuviet.edu.vn/tro-choi-duoi-hinh-bat-chu-tren-may-tinh/imager_33993.jpg"];
  List<String> listImage2 = ["https://truonghoc247.vn/wp-content/uploads/2023/09/ung-dung-hoc-tieng-anh-0.jpg",
  "https://static.anhnguathena.vn/anhngu//img.media/2020/04/15866955817.jpg"];
  List<String> listImage3 = ["https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/Logo_%C4%90u%E1%BB%95i_h%C3%ACnh_b%E1%BA%AFt_ch%E1%BB%AF_si%C3%AAu_t%E1%BB%91c.jpg/1280px-Logo_%C4%90u%E1%BB%95i_h%C3%ACnh_b%E1%BA%AFt_ch%E1%BB%AF_si%C3%AAu_t%E1%BB%91c.jpg",
    "https://cdn-i.vtcnews.vn/resize/th/upload/2023/08/10/guoi-hinh-bat-chu-15005637.jpg"];
  List<String> listImage4 = ["https://gitiho.com/caches/p_medium_large//images/article/photos/132070/image_puz12.jpg",
    "https://mst.game24h.vn/upload/2018/2018-4/game/2018-10-10/1539183564_game-ghep-hinh-co-dien-1.JPG"];
  List<String> listImage5 = ["https://salt.tikicdn.com/cache/w400/media/catalog/product/7/_/7.u5102.d20170404.t170522.380360.jpg",
    "https://cdn.popsww.com/blog-kids/sites/3/2022/07/xem-500-phut-nhan-qua-1920x1080.jpg"];
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
              id: item['id'].toString(),
              correctAnswer: item['correctAnswer'].toString(),
              type: item['type'] !=null ?item['type'].toString():"text",
              questionText: item['questionText'].toString(),
              imageContent: item['imageContent'] != null
                  ? item['imageContent'].toString()
                  : '',
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
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
          StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: slide(listImage,listImage.length,"Đuổi hình bắt chữ",() async {
                   getDataFromFirebase('ListQuestion/Question/',(){
                     print("vao day3");
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => CauHoi(type: 'DHBC', questions: list,)),
                     );
                   });
                }),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: flipCard("DHBC siêu tốc",(){
                  getDataFromFirebase('ListQuestion/Question/',(){
                      print("vao day3");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CauHoi(type: 'DHBCST', questions: list,)),
                      );
                  });
                },_controller,listImage3),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: flipCard("Siêu ghép hình",()  {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SieuGhepHinhScreen()),
                  );
                },_controller1,listImage4),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: flipCard("Siêu thử thách",(){
                  getDataFromFirebase('ListQuestion/Question/',(){
                    print("vao day3");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CauHoi(type: 'STT', questions: list,listAnswers: listAnswers,listAnswersChoose: [],)),
                    );
                  });
                },_controller2,listImage5),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 2,
                child: slide(listImage2, listImage2.length,"Học Englist cùng tôi",(){
                  var random = Random();
                  int randomNumber = random.nextInt(4) + 1;
                  print("randomNumbers: $randomNumber");
                  getDataFromFirebase("ListEnglish/English$randomNumber",(){
                    print("vao day3");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CauHoi(type: 'DHBC', questions: list,point: point,listAnswers: listAnswers,listAnswersChoose: [],)),
                    );
                  });
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget slide(List<String> listImage,int length,String title,Function() tap){
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
              height: 40,
              child: GridTileBar(
                backgroundColor: Colors.black12,
                title:Text(title),
                subtitle: Text(""),
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
                      effect: ExpandingDotsEffect(dotWidth: 15,activeDotColor: Colors.blue),
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
        margin: EdgeInsets.symmetric(vertical:10,horizontal: 5),
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
                      margin: EdgeInsets.symmetric(vertical:10,horizontal: 5),
                    ),
                    back: Container(
                      decoration:  BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(listImage[1]),
                            fit: BoxFit.cover),
                        // borderRadius: BorderRadius.circular(8)
                      ),
                      margin: EdgeInsets.symmetric(vertical:10,horizontal: 5),
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
