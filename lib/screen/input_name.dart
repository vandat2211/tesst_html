import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu.dart';

class InputName extends StatefulWidget {
   InputName({super.key});

  @override
  State<InputName> createState() => _InputNameState();
}

class _InputNameState extends State<InputName> {
  TextEditingController controller = TextEditingController();

  FocusNode focusNode = FocusNode();

  bool irError = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/bg.jpg"),fit: BoxFit.cover)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
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
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              onPressed: () async {
                if(controller.text.isEmpty){
                  setState(() {
                    irError = true;
                  });
                }else{
                  DateTime now = DateTime.now();
                  int timestamp = now.millisecondsSinceEpoch;
                  DatabaseReference ref = FirebaseDatabase.instance.ref("users/$timestamp");
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  await pref.setString("id", "$timestamp");
                  await ref.set({
                    "id":"$timestamp",
                    "name": controller.text,
                    "point":"0"
                  });
                }


            }, child: Text("Ok"),)
          ],
        ),
      ),
    ));
  }
}
