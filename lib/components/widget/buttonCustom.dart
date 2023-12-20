import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tesst_html/core/style.dart';

class ButtonCusTom extends StatelessWidget {
  final String title;
  final Function onPressed;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double? marginTop;
  const ButtonCusTom({super.key, required this.title, required this.onPressed, this.margin, this.width, this.height, this.marginTop});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop??16.h),
      height: height??40.h,
      width: width??MediaQuery.of(context).size.width ,
      decoration: BoxDecoration(gradient: LinearGradient( begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colorRed, colorRedBlack]),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        onPressed: (){
          onPressed();
        },
        child: Text(
          title,
          style: style_title_button,
        ),
      ),
    );
  }
}
