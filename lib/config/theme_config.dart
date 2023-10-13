import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ThemeConfig{
  static const  Color backgroundColor = Color(0xFF272944);
  static const  Color primaryColor = Color(0xFF272944);
  static const  Color secondColor = Color(0xFF363853);
  static const  Color thirdColor = Color(0xFF404BDA);
  static const  Color fourthColor = Color(0xFFF9F9FA);
  static const  Color background2Color = Color(0xFFf0f0f0);
  static const Color background2 =   Color(0xfff2f7f7);
  static const  Color greenColor2 = Color(0xFF18bc9c);
  static const  Color greenColor = Color(0xFF00a06f);
  static const  Color blueColor = Color(0xFF016eff);
  static const  Color greyColor = Color(0xFF444d5b);
  static const  Color orangeColor = Color(0xFFff8d01);
  static const  Color violetColor = Color(0xFFaa51e6);
  static const  Color brownColor = Color(0xFF73461a);
  static const  Color redColor = Color(0xFFff3c3c);
  static const  Color redColor2 = Color(0xFFffecec);
  static const Color hoverTextColor = greenColor;
  static const  Color whiteColor = Colors.white;
  static Color whiteColorWidthOpacity = Colors.white.withOpacity(0.2);
  static Color greyColor2  = const Color(0xFF3a3d42);
  static Color hoverColor =  const Color(0xfff2f7f7);
  static Color successColor = Color(0xFFaaf683);
  static Color errorColor = Color(0xFFee6055);
  static Color warningColor = Color(0xFFffd97d);
  static const  Color textColor = greyColor;
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(vertical: 11,horizontal: 10);
  static List<Color> listChartColor = const [
    greenColor2,
    orangeColor,
    brownColor,
    blueColor,
    greyColor,
    violetColor,
    redColor2,
  ];
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
      textStyle: TextStyle(
          fontSize: ThemeConfig.defaultSize,
          color: ThemeConfig.textColor,
          height: 1.5
      )
  );
  static TextStyle titleStyle = GoogleFonts.openSans(
      textStyle: TextStyle(
          fontSize: ThemeConfig.titleSize,
          color: ThemeConfig.textColor,
          height: 1.5
      )
  );

  static TextStyle headerStyle = GoogleFonts.openSans(
      textStyle: TextStyle(
          fontSize: ThemeConfig.headerSize,
          color: ThemeConfig.textColor,
          height: 1.5
      )
  );

  static TextStyle headerLargeStyle = GoogleFonts.openSans(
      textStyle: TextStyle(
          fontSize: ThemeConfig.headerLargeSize,
          color: ThemeConfig.textColor,
          height: 1.5
      )
  );

  static TextStyle smallStyle = GoogleFonts.openSans(
      textStyle: TextStyle(
          fontSize: ThemeConfig.smallSize,
          color: ThemeConfig.textColor,
          height: 1.5
      )
  );

  static TextStyle labelStyle = GoogleFonts.openSans(
      textStyle: TextStyle(
          fontSize: ThemeConfig.labelSize,
          color: ThemeConfig.textColor,
          height: 1.5
      )
  );
}