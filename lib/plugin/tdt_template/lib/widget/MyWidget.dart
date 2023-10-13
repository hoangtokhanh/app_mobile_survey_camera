import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../config/theme_config.dart';

class MyWidget {
  static successToast({required String content}) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_LONG,
      fontSize: ThemeConfig.defaultSize,
      backgroundColor: Colors.green,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 4,
      webShowClose: true,
      webPosition: 'center');

  static failedToast({required String content}) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_LONG,
      fontSize: ThemeConfig.defaultSize,
      webBgColor: "linear-gradient(to right, #FF6347, #FF0000)",
      backgroundColor: Colors.red,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 4,
      webShowClose: true,
      webPosition: 'center');
}
