import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {

  static Color primaryColor = const Color(0xFF272944);
  static Color secondColor = Colors.green;
  static Color backgroundColor = const Color(0xff1B1103);
  static Color background2 = const Color(0xfff9fafd);
  static Color thirdColor = const Color(0xFFA7D676);
  static Color fourthColor = const Color(0xFFFE7235);
  static Color greenColor = Colors.green;
  static Color redColor = Colors.red;
  static Color textColor = const Color(0xFF444d5b);
  static Color whiteColor = Colors.white;
  static Color greyColor = Colors.grey;
  static Color greyColor2 =  textColor;
  static Color blackColor = Colors.black;
  static Color buttonPrimary = Colors.blueAccent;
  static Color hoverColor = const Color(0xffe4e6ea);
  static Color successColor = const Color(0xFFaaf683);
  static Color errorColor = const Color(0xFFee6055);
  static Color warningColor = const Color(0xFFffd97d);
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(vertical: 4, horizontal: 10);

  static double get headerSize => 25;
  static double get headerLargeSize => 30;
  static double get borderRadius => 10;
  static double get borderRadiusMax => 50;

  static double get defaultSize => 14;
  static double get labelSize => 12;
  static double get smallSize => 13;
  static double get titleSize => 20;
  static double get iconSize => 30;

  static String fontFamily = 'Roboto';
  static double defaultHorPadding = 10;
  static double defaultPadding = 20;
  static double defaultVerPadding = 20;
  static double lineHigh = 1.5;

  static TextStyle defaultStyle = GoogleFonts.openSans(
      textStyle: TextStyle(fontSize: ThemeConfig.defaultSize, color: ThemeConfig.textColor, height: 1.5));
  static TextStyle titleStyle = GoogleFonts.openSans(
      textStyle: TextStyle(fontSize: ThemeConfig.titleSize, color: ThemeConfig.textColor, height: 1.5));

  static TextStyle headerStyle = GoogleFonts.openSans(
      textStyle: TextStyle(fontSize: ThemeConfig.headerSize, color: ThemeConfig.textColor, height: 1.5));

  static TextStyle smallStyle = GoogleFonts.openSans(
      textStyle: TextStyle(fontSize: ThemeConfig.smallSize, color: ThemeConfig.textColor, height: 1.5));

  static TextStyle labelStyle = GoogleFonts.openSans(
      textStyle: TextStyle(fontSize: ThemeConfig.labelSize, color: ThemeConfig.textColor, height: 1.5));
}
