import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_mobile_survey_camera/all_file.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future getData() async {
    await appController.checkPermission();
    if (appController.checkLogin()) {
      if(Get.currentRoute !='/home') {
        Get.offAllNamed('/home');
      }
    } else {
      Get.toNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Center(
              child: Image.asset(
                'assets/images/Smartlook-transparent.png',
                width: 200,
              ));
        },
      ),
    );
  }
}
