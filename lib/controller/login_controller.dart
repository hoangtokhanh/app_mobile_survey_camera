import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:app_mobile_survey_camera/all_file.dart';
class LoginController extends GetxController{
  RxBool isLoading = false.obs;
  RxBool isComplete = false.obs;
  RxBool validate = false.obs;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  _checkHasData() {
    if (username.text != '' && password.text != '') {
      validate.value = true;
    } else{
      validate.value = false;
    }
  }

  @override
  void onInit(){
    super.onInit();
    username.addListener(_checkHasData);
    password.addListener(_checkHasData);
  }

  Future login()async{
    if(!isLoading.value) {
      isLoading.value = true;
      var data = {
        'username': username.text,
        'password': password.text,
        // 'app_token':appController.appToken
      };
      var result = await api.login(data);
      isLoading.value = false;
      if (result) {
        Future.delayed(Duration.zero).then((value) => Get.offAllNamed('/home'));
      } else {
        appController.toastError('Login failure');
      }
    }
  }
}