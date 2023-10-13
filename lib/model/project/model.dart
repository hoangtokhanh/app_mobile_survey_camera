import 'package:app_mobile_survey_camera/all_file.dart';
class ProjectModel {
  late String name;
  late String des;
  late List<PointModel> points;

  ProjectModel(
      {this.name = '',
        this.des = '',
        this.points = const []
      });

  ProjectModel.fromJson(Map<String, dynamic> json) {
    name = json['name']??'';
    des = json['des']??'';
    points = (json['points'] as List).map((e) => PointModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['des'] = des;
    data['points'] = points;
    return data;
  }
}
