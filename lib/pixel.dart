import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  dynamic color;
  var int;

  Pixel({Key? key, required this.color, required this.int}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          int.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
