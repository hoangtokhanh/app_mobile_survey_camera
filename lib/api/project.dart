import 'package:app_mobile_survey_camera/all_file.dart';
mixin ProjectApi on BaseApi {
  Future<List<ProjectModel>> getListProject() async {
    const url = '/Admin/getListProject';
    try {
      Response response = await dio.get(url,options: Options(
        headers: {'Content-Type': 'application/json','accept':'*/*','token':appController.token},
      ));
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => ProjectModel.fromJson(e)).toList();
      } else {
        appController.errorLog = response.data['mess'];
        return [];
      }
    } catch (e) {
      saveLog(e);
      return [];
    }
  }
  Future<List<PointModel>> getListPointProject(param) async {
    const url = '/Admin/getListPointProject';
    try {
      Response response = await dio.get(url,options: Options(
        headers: {'Content-Type': 'application/json','accept':'*/*','token':appController.token},
      ),queryParameters: param);
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => PointModel.fromJson(e)).toList();
      } else {
        appController.errorLog = response.data['mess'];
        return [];
      }
    } catch (e) {
      saveLog(e);
      return [];
    }
  }

  Future<bool> createPoint(data) async {
    const url = '/Job/createPoint';
    try {
      Response response = await dio.post(url,options: Options(
        headers: {'Content-Type': 'application/json','accept':'*/*','token':appController.token},
      ),data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        appController.errorLog = response.data['mess'];
        return false;
      }
    } catch (e) {
      saveLog(e);
      return false;
    }
  }
  Future<bool> updatePoint(data) async {
    const url = '/Job/editPoint';
    try {
      Response response = await dio.put(url,options: Options(
        headers: {'Content-Type': 'application/json','accept':'*/*','token':appController.token},
      ),data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        appController.errorLog = response.data['mess'];
        return false;
      }
    } catch (e) {
      saveLog(e);
      return false;
    }
  }

  Future<bool> addPointToProject(data) async {
    const url = '/Job/addPointProject';
    try {
      Response response = await dio.post(url,options: Options(
        headers: {'Content-Type': 'application/json','accept':'*/*','token':appController.token},
      ),queryParameters: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        appController.errorLog = response.data['mess'];
        return false;
      }
    } catch (e) {
      saveLog(e);
      return false;
    }
  }

  Future<String> addImageToPoint(param,body) async {
    const url = '/Job/addImagePoint';
    try {
      Response response = await dio.put(url,options: Options(
        headers: {'Content-Type': 'application/json','accept':'*/*','token':appController.token},
      ),queryParameters: param,data: body);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        appController.errorLog = response.data['mess'];
        return '';
      }
    } catch (e) {
      saveLog(e);
      return '';
    }
  }

  Future<bool>removeImagePoint(param) async {
    const url = '/Job/removeImagePoint';
    try {
      Response response = await dio.delete(url,options: Options(
        headers: {'Content-Type': 'application/json','accept':'*/*','token':appController.token},
      ),queryParameters: param);
      if (response.statusCode == 200) {
        return true;
      } else {
        appController.errorLog = response.data['mess'];
        return false;
      }
    } catch (e) {
      saveLog(e);
      return false;
    }
  }

  Future<bool>deletePoint(param) async {
    const url = '/Job/deletePoint';
    try {
      Response response = await dio.delete(url,options: Options(
        headers: {'Content-Type': 'application/json','accept':'*/*','token':appController.token},
      ),queryParameters: param);
      if (response.statusCode == 200) {
        return true;
      } else {
        appController.errorLog = response.data['mess'];
        return false;
      }
    } catch (e) {
      saveLog(e);
      return false;
    }
  }

  Future<bool> setAvatarPoint(data) async {
    const url = '/Job/setImageShowPoint';
    try {
      Response response = await dio.put(url,options: Options(
        headers: {'Content-Type': 'application/json','accept':'*/*','token':appController.token},
      ),queryParameters: data);
      if (response.statusCode == 200) {
        return true;
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
