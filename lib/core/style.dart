import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//? font icon
const String fontIconApp = 'MyFlutterApp';

//!modeOrange

//! height //! width //! size  //! weight
double heightInputCombobox = 40;
const double fontsizeInputCombobox = 16;
const double heightButton = 40;
double height_16 = 8.h;
double height_40 = 20.h;
double margin_16 = 8.h;
double margin_32 = 16.h;
double padding_24 = 12.h;
double padding_20 = 10.h;
double padding_32 = 16.h;
double padding_16 = 8.h;
double padding_5 = 2.5.h;
double margin_24 = 12.h;
double width_24 = 12.w;
double width_40 = 20.w;
double width_8 = 4.w;
double width_6 = 1.w;
double width_16 = 8.w;
double width_32 = 16.w;
double width_250 = 125.w;
double width_2 = 1.w;
double width_1 = 0.8.w;
double width_70 = 35.w;
double width_50 = 25.w;
double width_30 = 15.w;
double height_8 = 4.h;
double height_24 = 12.h;
double height_32 = 16.h;
double height_28 = 14.h;
double height_2 = 1.h;
double height_70 = 35.h;
double height_150 = 75.h;
double height_50h = 50.h;
double height_50 = 25.h;
double height_160 = 80.h;
double height_400 = 200.h;
double height_300 = 150.h;
double height_90 = 45.h;
double height_38h = 38.h;
double height4 = 2.h;
double height8 = 4.h;
double height6 = 6.h;
double height24 = 12.h;
double height32 = 16.h;
double height36 = 18.h;
double height_64 = 32.h;
double height_100 = 40.h;
double height_110 = 50.h;
double height_120 = 60.h;
double height_130 = 65.h;
double height_350 = 170.h;
double width8 = 4.w;
double width16 = 8.w;
double width24 = 12.w;
double width_56 = 28.w;
double width32 = 16.w;
double width100 = 50.w;
double width40w = 40.w;
double width_130 = 65.w;
double width120 = 60.w;
double width300 = 150.w;
double width_600 = 300.w;
double width_800 = 400.w;
double width3 = 1.5.w;

double fontSize_48sp = 20.sp;
double fontSize_40sp = 16.sp;
double fontSize_42sp = 18.sp;
double fontSize_38sp = 14.sp;
double fontSize_39sp = 15.sp;
double fontSize_36sp = 13.sp;
double fontSize_35sp = 12.sp;
double fontSize_32sp = 10.sp;
double fontSize_60sp = 36.sp;
double fontSize_45sp = 19.sp;

double icon_400sp = 200.sp;
double icon_80sp = 40.sp;
double icon_60sp = 20.sp;
double icon_65sp = 25.sp;
double icon_70sp = 30.sp;
double icon_50sp = 15.sp;
double icon_40sp = 10.sp;
double icon_150sp = 60.sp;
const double fontSize_12 = 12;
const double fontSize_16 = 16;
const FontWeight w500 = FontWeight.w500;

//! color
const Color colorBorderInputCombobox = Color(0xFFB2B8BB);
const Color colorlabelInputCombobox = Color(0xFFA3A3A3);

const Color colorBlack = Color(0xFF000000);
const Color colorRed = Color(0xFFD80F0F);
// const Color colorRed = Color(0xFFFC6A50);
const Color colorRedBlack = Color(0xFF940706);
// const Color colorRedBlack = Color(0xFFAA3624);
const Color colorWhite = Color(0xFFEAE5E5);
const Color colorPink = Color(0xFFFCF5E3);
const Color colorYellow100 = Color(0xFFECBC3C);
const Color mau_vangbaca_50 = Color(0xFFFCF5E3);
const Color mau_vangbaca_100 = Color(0xFFF5D98D);
// màu sắc button
Color color_button = Color.fromRGBO(201, 137, 18, 1);

const Color colorPrimary = Color(0xFFD51515);
// const Color colorPrimary = Color(0xFFFC6A50);
const Color colorGrey = Color(0xFF696D76);
const Color colorBlue = Color(0xFF324486);
const Color colorYellow = Color(0xFFDBB309);
const Color colorPrimaryLogin = Color(0xFFF5F5F5);
const Color colorBg = Color(0xFFDEDEDE);
const Color colorBgHome1 = Color(0xFF141F29);
const Color colorBgHome2 = Color(0xFF141B20);
const Color colorFFF300 = Color(0xFFFFF300);
//login vnid green
const Color colorGreen = Color(0xFF1a5613);
const Color colorGreen2 = Color(0xFF2f8822);
//login vnid red
const Color colorRedd = Color(0xFF8d0c0f);
const Color colorRedd2 = Color(0xFFaa0c13);
//login vnid yellow
const Color colorYellows = Color(0xFFeac892);
const Color colorYellows2 = Color(0xFFe5c89c);


// màu sắc icon
Color color_icon = Color.fromRGBO(50, 68, 134, 1.0);
////

// font chữ mặc định
TextStyle text_normal_size = TextStyle(fontSize: 14);
TextStyle text_normal_size_bold = TextStyle(fontSize: fontSize_38sp, fontWeight: FontWeight.bold, color: Colors.white);

// chữ màu trắng
TextStyle text_default_white =
TextStyle(color: Color(0xFFEAEAEA), fontSize: fontSize_35sp);
TextStyle text_default2_white =
TextStyle(color: Color(0xFFEAEAEA), fontSize: fontSize_36sp);
TextStyle text_default_white_bold =
TextStyle(color: Color(0xFFEAEAEA), fontSize: fontSize_35sp, fontWeight: FontWeight.bold);

TextStyle text_default_white_bold_italic =
TextStyle(color: Color(0xFFEAEAEA), fontSize: fontSize_35sp, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);

TextStyle text_default_white_italic =
TextStyle(color: Color(0xFFEAEAEA), fontSize: fontSize_35sp, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic);

TextStyle text_white_40 = TextStyle(
    color: Colors.white, fontSize: fontSize_38sp, fontWeight: FontWeight.normal);

TextStyle text_white_40_bold = TextStyle(
    color: Colors.white, fontSize: fontSize_38sp, fontWeight: FontWeight.bold);

TextStyle text_default_white_under =
TextStyle(color: Color(0xFFEAE5E5), fontSize: fontSize_38sp, decoration: TextDecoration.underline,);

TextStyle text_small_white =
TextStyle(color: Colors.white, fontSize: fontSize_32sp);
// chữ màu xám
TextStyle text_default_grey =
TextStyle(color: colorlabelInputCombobox, fontSize: fontSize_38sp);

// chữ màu đen
TextStyle text_default_black =
TextStyle(color: colorBlack, fontSize: fontSize_38sp);

// chữ màu xanh biển
TextStyle text_default_blue =
TextStyle(color: colorPrimary, fontSize: fontSize_38sp);


TextStyle text_default_primary =
TextStyle(color: colorPrimary, fontSize: fontSize_38sp);

TextStyle text_default_login_primary =
TextStyle(color: colorPrimaryLogin, fontSize: fontSize_38sp);

TextStyle text_default_yellow =
TextStyle(color: Color(0xFFFFF300), fontSize: fontSize_38sp);
TextStyle text_default2_yellow =
TextStyle(color: Color(0xFFFFF300), fontSize: fontSize_35sp);
TextStyle text_default3_yellow =
TextStyle(color: Color(0xFFFFF300), fontSize: fontSize_39sp);

TextStyle text_default_yellow_bold =
TextStyle(color: Color(0xFFFFF300), fontSize: fontSize_38sp, fontWeight: FontWeight.bold);

TextStyle text_default_red_normal_size =
TextStyle(color: Color(0xFF9C1111), fontSize: fontSize_38sp);

TextStyle text_default_error =
TextStyle(color: colorYellow, fontSize: fontSize_38sp);
// font chữ nhỏ ở màn hình Home và Menu
// chữ màu đen
TextStyle text_small_black =
TextStyle(color: Colors.black, fontSize: fontSize_32sp);

// chữ màu xám
TextStyle text_small_grey =
TextStyle(color: colorlabelInputCombobox, fontSize: fontSize_32sp);

///

// font chữ in đậm
TextStyle text_big_w500_black = TextStyle(
    color: Colors.black, fontSize: fontSize_38sp, fontWeight: FontWeight.w500);

TextStyle text_big_bold_black = TextStyle(
    color: Colors.black, fontSize: fontSize_38sp, fontWeight: FontWeight.bold);
TextStyle text_bold_white = TextStyle(
    color: Colors.white, fontSize: fontSize_38sp, fontWeight: FontWeight.bold);

TextStyle text_big_w700_white = TextStyle(
    color: Colors.white, fontSize: fontSize_40sp, fontWeight: FontWeight.w700);

TextStyle text_big_w700_black = TextStyle(
    color: Colors.black, fontSize: fontSize_38sp, fontWeight: FontWeight.w700);

// style tiêu đề của AppBar
TextStyle style_title_appBar = TextStyle(
    fontSize: fontSize_40sp, fontWeight: FontWeight.bold, color: Colors.black);

// style tiêu đề của Button
TextStyle style_title_button = TextStyle(
    fontSize: fontSize_38sp, fontWeight: FontWeight.bold, color: Colors.white);

// font blue text
TextStyle text_normal_blue = TextStyle(
    color: Colors.blue, fontSize: fontSize_16, fontWeight: FontWeight.w700);
// font red text
TextStyle text_normal_red =
TextStyle(fontSize: fontSize_38sp, color: Colors.red);

TextStyle text_white_font_18 =
TextStyle(fontSize: fontSize_40sp, color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold);

TextStyle text_white_font_14 =
TextStyle(fontSize: fontSize_38sp, color: Color(0x80C6C6C6), fontWeight: FontWeight.w400);

TextStyle text_default_white_home =
TextStyle(color: Color(0xFFFFFFFF), fontSize: fontSize_32sp);
TextStyle text_bold_white_home =
TextStyle(color: Color(0xFFFFFFFF), fontSize: fontSize_32sp, fontWeight: FontWeight.bold);