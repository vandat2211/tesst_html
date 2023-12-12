import 'dart:math';
import 'package:marquee/marquee.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tesst_html/sieuGhepHinh.dart';
import 'package:firebase_database/firebase_database.dart';
import 'cau_hoi.dart';
import 'models/question.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeIndex=0;
  bool visibleThuThach = false;
  List<Question> list= [];
  List<String> listImage = ["https://images.viblo.asia/5f7c8c9d-cdea-478b-9672-0d1d67cc4331.png",
  "https://images.viblo.asia/5f7c8c9d-cdea-478b-9672-0d1d67cc4331.png",
  "https://images.viblo.asia/5f7c8c9d-cdea-478b-9672-0d1d67cc4331.png"];
  List<String> listImage2 = ["https://fullstackstation.com/wp-content/uploads/2019/06/flutter.png",
  "https://fullstackstation.com/wp-content/uploads/2019/06/flutter.png"];
  @override
  void initState() {
    super.initState();
  }
  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    print("okoko");
    super.didUpdateWidget(oldWidget);
  }
  Future<void> getDataFromFirebase( String link,Function() tap) async {
    List<Question> listQ = [];
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref(link);
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null) {
        List<dynamic> dataList = data as List<dynamic>;
        for (var item in dataList) {
          if (item != null) {
            // Tạo một đối tượng Question từ dữ liệu Firebase và thêm vào danh sách
            Question question = Question(
              id: item['id'].toString(),
              correctAnswer: item['correctAnswer'].toString(),
              type: item['type'].toString(),
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
      print("listlist:${list.length}");

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  StaggeredGrid.count(
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
                    MaterialPageRoute(builder: (context) => CauHoi(type: 'DHBCST', questions: list,choose_dhbc: false,)),
                  );
              });
            }),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: flipCard("Siêu ghép hình",()  {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SieuGhepHinhScreen()),
              );
            }),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: flipCard("thử tài kiến thức",(){
              getDataFromFirebase('ListQuestion/Question/',(){
                print("vao day3");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CauHoi(type: 'DHBC', questions: list,)),
                );
              });
            }),
          ),
          if(!visibleThuThach)StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 2,
            child: slide(listImage2, listImage2.length,"Học Englist cùng tôi",(){
              getDataFromFirebase("ListEnglish/English1",(){
                print("vao day3");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CauHoi(type: 'DHBC', questions: list,)),
                );
              });
            }),
          ),
          if(visibleThuThach)StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: slide(listImage2, listImage2.length,"Học Englist cùng tôi",(){
              getDataFromFirebase("ListEnglish/English1",(){
                print("vao day3");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CauHoi(type: 'DHBC', questions: list,)),
                );
              });
            }),
          ),
          if(visibleThuThach)StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: slide(listImage2, listImage2.length,"Siêu thử thách",(){
              getDataFromFirebase('ListQuestion/Question/',(){
                print("vao day3");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CauHoi(type: 'DHBC', questions: list,)),
                );
              });
            }),
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
  Widget flipCard(String title,Function() tap){
    var random = Random();
    int randomNumber = random.nextInt(10) + 1;
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
            child:   FlipCard(
                autoFlipDuration:Duration(seconds: randomNumber),
                onFlipDone: (a){
                    if(!a && mounted) tap();
                },
                direction: FlipDirection.HORIZONTAL, // Lật theo chiều ngang
                front:Container(
                  color: Colors.grey[300],
                  child: Center(child: Text('Front of Card')),
                ),
                back: Container(
                  color: Colors.grey[400],
                  child: Center(child: Text('Back of Card')),
                )
            ) ),
      );
  }
}
