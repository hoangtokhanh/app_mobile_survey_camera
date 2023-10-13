import 'package:flutter/material.dart';

class MyCustomText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color? color;
  final FontWeight? fontWeight;
  final int ?maxLines;
  const MyCustomText({super.key, required this.text, required this.style, this.color, this.fontWeight,this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: style.copyWith(color: color, fontWeight: fontWeight),
    );
  }
}
