import 'package:app_mobile_survey_camera/all_file.dart';
mixin AuthApi on BaseApi {
  Future<bool> login(data) async {
    const url = '/Admin/login';
    try {
      Response response = await dio.post(url,options: Options(
        headers: {'Content-Type': 'application/json','accept':'*/*'},
      ), data: data);
      if (response.statusCode == 200) {
        await appController.setLoginData(response.data);
        return appController.checkLogin();
      } else {
        appController.errorLog = response.data['mess'];
        return false;
      }
    } catch (e) {
      saveLog(e);
      return false;
    }
  }
}
