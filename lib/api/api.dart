import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:app_mobile_survey_camera/api/project.dart';
import 'auth.dart';

class BaseApi {
  Dio dio = Dio(BaseOptions(
    baseUrl: AppConfig.BASE_URL,
    connectTimeout: const Duration(milliseconds: 300000),
    receiveTimeout: const Duration(milliseconds: 300000),
  ));

  void saveLog(e) async {
    if(e.response != null) {
      if (e.response.statusCode == 500 || e.response.statusCode == 502 ||
          e.response.statusCode == 404) {
        appController.errorLog = 'Lỗi hệ thống';
      } else if (e.response.statusCode == 401) {
        appController.errorLog = 'Truy cập bị từ chối';
      }else{
        appController.errorLog = 'Lỗi hệ thống';
      }
    }else{
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      if(hasInternet){
        appController.errorLog = e.error.message;
      }
      else {
        appController.errorLog = 'Không có mạng';
      }
    }
  }
}

class Api extends BaseApi with AuthApi,ProjectApi{}

final Api api = Api();
