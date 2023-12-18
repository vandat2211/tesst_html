import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as prefix0;

enum Position { TOP, BOTTOM, CENTER }

class Toast {
  ///[msg] Nội dung sẽ hiển thị
  ///[msgColor] Màu của nội dung sẽ hiển thị
  ///[bgColor] Màu nền sẽ hiển thị
  ///[fontSize] Kích thước font chữ nội dung
  ///[position] Vị trí sẽ hiển thị [Position]
  static void showShort(String msg,
      {int msgColor = 0xFFffffff,
      int bgColor = 0xFF9C1111,
      double fontSize = 16.0,
      Position position = Position.BOTTOM}) {
    if (msg.trim().toString() == "") {
      return;
    }
    prefix0.Fluttertoast.showToast(
      msg: msg,
      fontSize: fontSize,
      toastLength: prefix0.Toast.LENGTH_SHORT,
      gravity: _getGravity(position),
      backgroundColor: Color(bgColor),
      textColor: Color(msgColor),
      timeInSecForIosWeb: 3,
    );
  }

  ///[msg] Nội dung sẽ hiển thị
  ///[msgColor] Màu của nội dung sẽ hiển thị
  ///[bgColor] Màu nền sẽ hiển thị
  ///[fontSize] Kích thước font chữ nội dung
  ///[position] Vị trí sẽ hiển thị [Position]
  static void showLong(String msg,
      {int msgColor = 0xFFffffff,
      int bgColor = 0xFF9C1111,
      double fontSize = 16.0,
      Position position = Position.BOTTOM}) {
    if (msg.trim().toString() == "") {
      return;
    }
    prefix0.Fluttertoast.showToast(
      msg: msg,
      fontSize: fontSize,
      toastLength: prefix0.Toast.LENGTH_SHORT,
      gravity: _getGravity(position),
      backgroundColor: Color(bgColor),
      textColor: Color(msgColor),
      timeInSecForIosWeb: 5,
    );
  }

  ///Trả về [prefix0.ToastGravity] theo position sẽ hiển thị
  static prefix0.ToastGravity _getGravity(Position position) {
    if (position == Position.BOTTOM) {
      return prefix0.ToastGravity.BOTTOM;
    } else if (position == Position.CENTER) {
      return prefix0.ToastGravity.CENTER;
    } else {
      return prefix0.ToastGravity.TOP;
    }
  }

  ///[msg] Nội dung sẽ hiển thị
  ///[msgColor] Màu của nội dung sẽ hiển thị
  ///[bgColor] Màu nền sẽ hiển thị
  ///[fontSize] Kích thước font chữ nội dung
  ///[position] Vị trí sẽ hiển thị [Position]
  static void showLongTop(String msg,
      {int msgColor = 0xFFffffff,
      int bgColor = 0xFF9C1111,
      double fontSize = 16.0,
      Position position = Position.BOTTOM}) {
    if (msg.trim().toString() == '') {
      return;
    }
    prefix0.Fluttertoast.showToast(
      msg: msg,
      fontSize: fontSize,
      toastLength: prefix0.Toast.LENGTH_LONG,
      gravity: _getGravity(position),
      backgroundColor: Color(bgColor),
      textColor: Color(msgColor),
      timeInSecForIosWeb: 5,
    );
  }
}
