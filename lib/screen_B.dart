// import 'package:flutter/material.dart';
//
// class ScreenB extends StatefulWidget {
//   final List<String> items;
//
//   ScreenB({required this.items});
//
//   @override
//   _ScreenBState createState() => _ScreenBState();
// }
//
// class _ScreenBState extends State<ScreenB> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Màn hình B'),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Column(
//             children: List.generate(
//               widget.items.length,
//                   (index) {
//                 return AnimatedListItem(
//                   item: widget.items[index],
//                   index: index,
//                   maxWidth: constraints.maxWidth.toDouble(),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class AnimatedListItem extends StatefulWidget {
//   final String item;
//   final int index;
//   final double maxWidth;
//
//   AnimatedListItem({required this.item, required this.index, required this.maxWidth});
//
//   @override
//   _AnimatedListItemState createState() => _AnimatedListItemState();
// }
//
// class _AnimatedListItemState extends State<AnimatedListItem> {
//   bool isVisible = false;
//   double width = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     // Delay the animation for each item based on its index
//     Future.delayed(Duration(milliseconds: 300 * widget.index), () {
//       setState(() {
//         isVisible = true;
//         width = widget.maxWidth; // Set width to max width
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 500),
//       width: isVisible ? width : 0,
//       child: isVisible
//           ? Container(
//         color: Colors.blue, // Màu nền cho từng khối
//         margin: EdgeInsets.all(8), // Khoảng cách giữa các khối
//         padding: EdgeInsets.all(16), // Khoảng cách bên trong khối
//         child: Text(
//           widget.item,
//           style: TextStyle(fontSize: 24),
//         ),
//       )
//           : Container(),
//     );
//   }
// }

///
///
// import 'package:flutter/material.dart';
//
// class ScreenB extends StatelessWidget {
//   final List<String> items;
//
//   ScreenB({required this.items});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Màn hình B'),
//       ),
//       body: ListView.builder(
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           return DelayedAnimatedListItem(
//             item: items[index],
//             index: index,
//           );
//         },
//       ),
//     );
//   }
// }
//
// class DelayedAnimatedListItem extends StatefulWidget {
//   final String item;
//   final int index;
//
//   DelayedAnimatedListItem({required this.item, required this.index});
//
//   @override
//   _DelayedAnimatedListItemState createState() => _DelayedAnimatedListItemState();
// }
//
// class _DelayedAnimatedListItemState extends State<DelayedAnimatedListItem> {
//   bool isVisible = false;
//   double translateY = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     // Thằng đầu giữ nguyên vị trí
//     if (widget.index == 0) {
//       isVisible = true;
//       translateY = 0;
//     } else {
//       // Delay the animation for each thằng sau based on its index
//       Future.delayed(Duration(milliseconds: 300 * widget.index), () {
//         setState(() {
//           isVisible = true;
//           translateY = 100; // Rơi xuống
//         });
//         // Sau khi rơi xuống, sau một khoảng thời gian, trở lại vị trí cũ
//         Future.delayed(Duration(milliseconds: 1000), () {
//           setState(() {
//             translateY = 0; // Trở lại vị trí cũ
//           });
//         });
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 500),
//       transform: Matrix4.translationValues(0, translateY, 0), // Thay đổi vị trí theo chiều dọc
//       child: isVisible
//           ? Container(
//         color: Colors.blue, // Màu nền cho từng khối
//         margin: EdgeInsets.all(8), // Khoảng cách giữa các khối
//         padding: EdgeInsets.all(16), // Khoảng cách bên trong khối
//         child: Text(
//           widget.item,
//           style: TextStyle(fontSize: 24),
//         ),
//       )
//           : Container(),
//     );
//   }
// }
///
///
// import 'package:flutter/material.dart';
//
// class ScreenB extends StatefulWidget {
//   final List<String> items;
//
//   ScreenB({required this.items});
//
//   @override
//   State<ScreenB> createState() => _ScreenBState();
// }
//
// class _ScreenBState extends State<ScreenB> {
//   final double sizeBox = 100;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Màn hình B'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             for (int i = widget.items.length - 1; i >= 0; i--)
//               DelayedAnimatedListItem(
//                 item: widget.items[i],
//                 index: i,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DelayedAnimatedListItem extends StatefulWidget {
//   final String item;
//   final int index;
//
//   DelayedAnimatedListItem({required this.item, required this.index});
//
//   @override
//   _DelayedAnimatedListItemState createState() => _DelayedAnimatedListItemState();
// }
//
// class _DelayedAnimatedListItemState extends State<DelayedAnimatedListItem> {
//   bool isVisible = false;
//   @override
//   void initState() {
//     super.initState();
//
//     Future.delayed(Duration(milliseconds: widget.index * 500), () {
//       setState(() {
//         isVisible = true;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       width: MediaQuery.of(context).size.width,
//       duration: Duration(milliseconds: 500),
//       height: isVisible ? 100 : 0,
//       child: isVisible
//           ? Container(
//         color: Colors.blue,
//         margin: EdgeInsets.all(8),
//         padding: EdgeInsets.all(16),
//         child: Text(
//           widget.item,
//           style: TextStyle(fontSize: 24),
//         ),
//       )
//           : Container(),
//     );
//   }
// }
///
///
///
import 'package:flutter/material.dart';
import 'dart:math';

class ParabolicAnimation extends StatefulWidget {
  @override
  _ParabolicAnimationState createState() => _ParabolicAnimationState();
}

class _ParabolicAnimationState extends State<ParabolicAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<ParabolicBlock> blocks = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    final random = Random();
    for (int i = 0; i < 5; i++) {
      blocks.add(ParabolicBlock(controller: _controller, index: i, random: random));
    }

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parabolic Animation'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size(300, 400),
              painter: ParabolicPainter(blocks: blocks),
            );
          },
        ),
      ),
    );
  }
}

class ParabolicBlock {
  final AnimationController controller;
  final int index;
  final Random random;

  ParabolicBlock({required this.controller, required this.index, required this.random});

  double get value => controller.value - index / 5.0;

  double get x => value * 200 + random.nextDouble() * 20;
  double get y => -value * value * 200 + 400 + random.nextDouble() * 20;
}

class ParabolicPainter extends CustomPainter {
  final List<ParabolicBlock> blocks;

  ParabolicPainter({required this.blocks});

  @override
  void paint(Canvas canvas, Size size) {
    for (ParabolicBlock block in blocks) {
      final offset = Offset(block.x, block.y);
      final paint = Paint()..color = Colors.blue;
      canvas.drawCircle(offset, 20, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
