import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_mobile_survey_camera/all_file.dart';
class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/Smartlook-transparent.png'),
                  fit: BoxFit.cover,width: 250,),
                SizedBox(height: ThemeConfig.defaultPadding,),
                MyTextField(controller: Get.find<LoginController>().username, title: 'Tên đăng nhập'),
                MyTextField(controller: Get.find<LoginController>().password, title: 'Mật khẩu',password: true,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 80,
                  height: 56,
                  margin: EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding/2,horizontal: ThemeConfig.defaultPadding),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.find<LoginController>().login();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: ThemeConfig.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 15.0,
                    ),
                    child: Obx(() => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Get.find<LoginController>().isLoading.value
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Please wait...',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )
                        ],
                      )
                          : MyCustomText(
                        text:'Đăng nhập',
                        style: ThemeConfig.titleStyle,color: ThemeConfig.whiteColor,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}