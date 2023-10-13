import 'package:flutter/material.dart';

class MyCustomText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color? color;
  final FontWeight? fontWeight;

  const MyCustomText({super.key, required this.text, required this.style, this.color, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(color: color, fontWeight: fontWeight),
    );
  }
}
