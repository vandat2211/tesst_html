import 'package:flutter/material.dart';

import '../models/question.dart';

class DetailTBPage extends StatefulWidget {
  Mes mes;
   DetailTBPage({super.key,required this.mes});

  @override
  State<DetailTBPage> createState() => _DetailTBPageState();
}

class _DetailTBPageState extends State<DetailTBPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(widget.mes.title),
            Text(widget.mes.body)
          ],
        ),
      ),
    );
  }
}
