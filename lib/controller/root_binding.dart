import 'package:get/get.dart';
import 'package:app_mobile_survey_camera/all_file.dart';

class InitialScreenBindings implements Bindings {
  InitialScreenBindings();

  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
