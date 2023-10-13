class PointModel {
  late String name;
  late String des;
  late String longitude;
  late String latitude;
  late String note;
  late String imageShow;
  late List<String> images;
  late String project;
  late String user;

  PointModel(
      {this.name = '',
        this.des = '',
        this.longitude = '0',
        this.latitude = '0',
        this.note = '',
        this.imageShow = '',
        this.project = '',
        this.user = '',
        this.images = const []});

  PointModel.fromJson(Map<String, dynamic> json) {
    name = json['name']??'';
    des = json['des']??'';
    longitude = json['longitude']??'0';
    latitude = json['latitude']??'0';
    note = json['note']??'';
    imageShow = json['imageShow']??'';
    images = json['images'].cast<String>();
    project = '';
    user = json['user']??'';
  }

  Map<String, dynamic> toJsonCreate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['des'] = des;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['note'] = note;
    return data;
  }

  Map<String, dynamic> toJsonSetAvatar() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['imageShow'] = imageShow;
    return data;
  }

  Map<String, dynamic> toJsonAddProject() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['point'] = name;
    data['project'] = project;
    return data;
  }

  bool checkValidate(){
    return (name.isNotEmpty && longitude.isNotEmpty && latitude.isNotEmpty);
  }

  updateModel(PointModel model){
    name = model.name;
    des = model.des;
    note = model.note;
    longitude = model.longitude;
    latitude = model.latitude;
  }
}
