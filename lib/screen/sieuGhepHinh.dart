import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as image;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class SieuGhepHinhScreen extends StatefulWidget {
  const SieuGhepHinhScreen({super.key});

  @override
  State<SieuGhepHinhScreen> createState() => _SieuGhepHinhScreenState();
}

class _SieuGhepHinhScreenState extends State<SieuGhepHinhScreen> {
  Duration _duration = Duration(seconds: 1);
  int valueSlider=2;
  bool isSlider=false;
  GlobalKey<_SlidePuzzleWidgetState> globalKey=GlobalKey();
  List<String> listImage = ["https://images.viblo.asia/5f7c8c9d-cdea-478b-9672-0d1d67cc4331.png"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 5),
              child: Text(
                "Slide Puzzle ${valueSlider}x$valueSlider",
                style: TextStyle(color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),),
            ),
            Slider(
              activeColor: Colors.green[100],
              min: 2,
              max: 6,
              divisions: 4,
              label: "${valueSlider.toString()}",
              value: valueSlider.toDouble(),
              onChanged: (value) {
                setState(() {
                  valueSlider = value.toInt();
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0), // Đổi giá trị để điều chỉnh độ cong của viền
                      border: Border.all(
                        color: Colors.grey, // Màu sắc của viền
                        width: 1.0, // Độ dày của viền
                      ),
                    ),
                    child: ClipRRect(borderRadius: BorderRadius.circular(10),
                      child: listImage.isEmpty ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ) : Image.network(listImage[0], fit: BoxFit.fill,
                        height: 100,
                        width: 180,),),
                  ),
                  InkWell(child: Icon(Icons.cached,color: Colors.black,),onTap: (){
                    // context.read<DogBloc>().add(FetchDogEvent());
                  },)
                ],
              ),),
            listImage.isEmpty ?
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  border: Border.all(
                      width: 1, color: Color(0xFFCE587D)
                  )
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return Container(
                  width: constraints.biggest.width,
                  height: constraints.biggest.width,
                  child: Center(
                    child: CircularProgressIndicator(),),
                );
              }),
            ) : Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  border: Border.all(
                      width: 1, color: Color(0xFFCE587D)
                  )
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return Container(
                  width: constraints.biggest.width,
                  // height: constraints.biggest.width,
                  child: SlidePuzzleWidget(
                      voidCallback: (){
                        setState(() {
                          valueSlider=valueSlider+1;
                          isSlider=true;
                        });
                      },isSlider: isSlider,
                      key: globalKey,
                      size: constraints.biggest,
                      imgUrl: listImage[0],
                      sizePuzzle: valueSlider,
                      imageBackGround: Image(
                        image: NetworkImage(listImage[0]),
                        fit: BoxFit.cover,)),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
class SlidePuzzleWidget extends StatefulWidget {
  SlidePuzzleWidget({Key? key,required this.size,this.innerPadding=5,required this.imageBackGround,required this.sizePuzzle,required this.voidCallback,required this.isSlider,required this.imgUrl}) : super(key: key);
  Size size;
  double innerPadding;
  Image imageBackGround;
  int sizePuzzle;
  VoidCallback voidCallback;
  bool isSlider;
  String imgUrl;
  @override
  State<SlidePuzzleWidget> createState() => _SlidePuzzleWidgetState();
}

class _SlidePuzzleWidgetState extends State<SlidePuzzleWidget> {
  GlobalKey _globalKey=GlobalKey();
  Size? size;
  List<SlideObject>? slideObjects;
  image.Image? fullImage;
  bool success=false;
  bool startSlide = true;
  List<int>? process;
  bool finishSwap = false;
  @override
  Widget build(BuildContext context) {
    size=Size(widget.size.width - widget.innerPadding*2, widget.size.width-widget.innerPadding);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
          width: widget.size.width,
          height: widget.size.width,
          padding: EdgeInsets.all(widget.innerPadding),
          child: Stack(
            children: [
              if(widget.imageBackGround!=null&&slideObjects==null)...[
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    color: Colors.green[100],
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: widget.imageBackGround,
                  ),
                )
              ],
              if(slideObjects!=null)...slideObjects!.where((slideObjects) => slideObjects.empty).map((slideObjects) {
                return Positioned(
                    left: slideObjects.posCurrent?.dx,
                    top: slideObjects.posCurrent?.dy,
                    child: SizedBox(
                      width: slideObjects.size?.width,
                      height: slideObjects.size?.height,
                      child: Container(
                        alignment: Alignment.center,
                        margin: widget.sizePuzzle>4?EdgeInsets.all(0.5): EdgeInsets.all(1),
                        color: Colors.white24,
                        child: Stack(
                          children: [
                            if(slideObjects.image!=null)...[
                              Opacity(
                                opacity: success ? 1 : 0.2,
                                child: slideObjects.image,
                              )
                            ]
                          ],
                        ),
                      ),));
              }).toList(),
              if(slideObjects!=null)...slideObjects!.where((slideObjects) => !slideObjects.empty).map((slideObjects) {
                return AnimatedPositioned(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                    left: slideObjects.posCurrent?.dx,
                    top: slideObjects.posCurrent?.dy,
                    child: GestureDetector(
                      onTap:   success ? null : () =>changePos(slideObjects.indexCurrent!,true),
                      child: SizedBox(
                        width: slideObjects.size?.width,
                        height: slideObjects.size?.height,
                        child: Container(
                          margin:widget.sizePuzzle>4?EdgeInsets.all(0.5): EdgeInsets.all(1),
                          color: Colors.blue,
                          child: Stack(
                            children: [
                              if(slideObjects.image!=null)...[
                                slideObjects.image!
                              ]
                            ],
                          ),
                        ),),
                    ));
              }).toList()

            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: ()=>generatePuzzle(),
                  child: Text("Generate"),
                ),
              ),
              Padding(padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: startSlide ? null : () => reversePuzzle(),
                  child: Text("Reverse"),
                ),
              ),
              Padding(padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () => clearPuzzle(),
                  child: Text("Clear"),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Future<image.Image> decodeImageFromAsset() async {
    final response = await http.get(Uri.parse(widget.imgUrl));
    final Uint8List bytes = response.bodyBytes;
    final image.Image img = image.decodeImage(bytes)!;
    return image.copyResize(img, width: size?.width.toInt(), height: size?.height.toInt());
  }
  generatePuzzle()async{
    finishSwap=false;
    setState(() {});
    this.fullImage=await decodeImageFromAsset();
    Size sizeBox=Size(size!.width/widget.sizePuzzle, size!.width/widget.sizePuzzle);
    slideObjects=List.generate(widget.sizePuzzle*widget.sizePuzzle, (index) {
      Offset offsetTemp=Offset(
          index % widget.sizePuzzle * sizeBox.width,
          index ~/ widget.sizePuzzle * sizeBox.height
      );
      image.Image? tempCrop;
      if (widget.imageBackGround != null && this.fullImage != null)
        tempCrop = image.copyCrop(
          fullImage!,
          x: offsetTemp.dx.round(),
          y: offsetTemp.dy.round(),
          width: sizeBox.width.round(),
          height: sizeBox.height.round(),
        );

      return SlideObject(size: sizeBox,posCurrent: offsetTemp,posDefault: offsetTemp,indexCurrent: index,indexDefault: index+1,image: tempCrop==null?null:Image.memory(image.encodePng(tempCrop),fit: BoxFit.contain,));
    });
    slideObjects?.last.empty=true;
    bool swap=true;
    process=[];
    for(var i=0;i<widget.sizePuzzle*20;i++){
      for(var j=0;j<widget.sizePuzzle/2;j++){
        SlideObject slideObject=getEmptyObject();
        int emptyIndex=slideObject.indexCurrent!;
        process?.add(emptyIndex);
        int randKey;
        if(swap){
          int row=emptyIndex ~/ widget.sizePuzzle;
          randKey=(row*widget.sizePuzzle + new Random().nextInt(widget.sizePuzzle));
        }else{
          int col=emptyIndex % widget.sizePuzzle;
          randKey =widget.sizePuzzle *new Random().nextInt(widget.sizePuzzle)+col;
        }
        changePos(randKey,true);
        // ops forgot to swap
        // hmm bug.. :).. let move 1st with click..check whther bug on swap or change pos
        swap = !swap;

      }
    }
    startSlide = false;
    finishSwap = true;
    setState(() {});
  }
  // get empty slide object from list
  SlideObject getEmptyObject() {
    return slideObjects!.firstWhere((element) => element.empty);
  }
  changePos(int indexCurrent,bool isReversePuzzle) async {
// problem here i think..
    SlideObject slideObjectEmpty = getEmptyObject();

    // get index of empty slide object
    int emptyIndex = slideObjectEmpty.indexCurrent!;

    // min & max index based on vertical or horizontal

    int minIndex = min(indexCurrent, emptyIndex);
    int maxIndex = max(indexCurrent, emptyIndex);

    // temp list moves involves
    List<SlideObject> rangeMoves = [];

    // check if index current from vertical / horizontal line
    if (indexCurrent % widget.sizePuzzle == emptyIndex % widget.sizePuzzle) {
      // same vertical line
      rangeMoves = slideObjects
          !.where((element) =>
      element.indexCurrent! % widget.sizePuzzle ==
          indexCurrent % widget.sizePuzzle)
          .toList();
    } else if (indexCurrent ~/ widget.sizePuzzle ==
        emptyIndex ~/ widget.sizePuzzle) {
      rangeMoves = slideObjects!;
    } else {
      rangeMoves = [];
    }

    rangeMoves = rangeMoves
        .where((puzzle) =>
    puzzle.indexCurrent! >= minIndex &&
        puzzle.indexCurrent! <= maxIndex &&
        puzzle.indexCurrent != emptyIndex)
        .toList();

    // check empty index under or above current touch
    if (emptyIndex < indexCurrent)
      rangeMoves.sort((a, b) => a.indexCurrent! < b.indexCurrent! ? 1 : 0);
    else
      rangeMoves.sort((a, b) => a.indexCurrent! < b.indexCurrent! ? 0 : 1);

    // check if rangeMOves is exist,, then proceed switch position
    if (rangeMoves.length > 0) {
      int tempIndex = rangeMoves[0].indexCurrent!;

      Offset tempPos = rangeMoves[0].posCurrent!;

      // yeayy.. sorry my mistake.. :)
      for (var i = 0; i < rangeMoves.length - 1; i++) {
        rangeMoves[i].indexCurrent = rangeMoves[i + 1].indexCurrent;
        rangeMoves[i].posCurrent = rangeMoves[i + 1].posCurrent;
      }

      rangeMoves.last.indexCurrent = slideObjectEmpty.indexCurrent;
      rangeMoves.last.posCurrent = slideObjectEmpty.posCurrent;

      // haha ..i forget to setup pos for empty puzzle box.. :p
      slideObjectEmpty.indexCurrent = tempIndex;
      slideObjectEmpty.posCurrent = tempPos;
    }

    // this to check if all puzzle box already in default place.. can set callback for success later
    if (slideObjects?.where((slideObject) => slideObject.indexCurrent == slideObject.indexDefault! - 1).length == slideObjects?.length && finishSwap) {
      print("Success");
      success = true;
      if(isReversePuzzle && widget.sizePuzzle<=5){
        widget.voidCallback();
        generatePuzzle();
      }
      SharedPreferences pref = await SharedPreferences.getInstance();
        int  id =  pref.getInt("SGH")??0;
        id = id + 1;
        await pref.setInt("SGH", id);

    } else {
      success = false;
    }

    startSlide = true;
    setState(() {});

  }
  clearPuzzle() {
    setState(() {
      // checking already slide for reverse purpose
      startSlide = true;
      slideObjects = null;
      finishSwap = true;
    });
  }

  reversePuzzle() async {
    startSlide = true;
    finishSwap = true;
    setState(() {});

    await Stream.fromIterable(process!.reversed)
        .asyncMap((event) async =>
    await Future.delayed(Duration(milliseconds: 50))
        .then((value) => changePos(event,false)))
        .toList();

    // yeayy
    process = [];
    setState(() {});
  }

}
class SlideObject{
  // setup offset for default / current position
  Offset? posDefault;
  Offset? posCurrent;
  // setup index for default / current position
  int? indexDefault;
  int? indexCurrent;
  // status box is empty
  bool empty;
  // size each box
  Size? size;
  // Image field for crop later
  Image? image;

  SlideObject({
    this.empty = false,
    this.image,
    this.indexCurrent,
    this.indexDefault,
    this.posCurrent,
    this.posDefault,
    this.size,
  });

}