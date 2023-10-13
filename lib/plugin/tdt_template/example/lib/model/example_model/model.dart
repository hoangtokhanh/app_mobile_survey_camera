import 'package:tdt_template/tdt_template.dart';
import 'package:tdt_template_example/model/example_model/view.dart';
class CameraModel extends TemplateModel with CameraView{
  late String name;
  late String des;
  late String link;
  late bool online;
  late String type;
  late String area;
  late String node;
  late String viewlink;
  late String viewfulllink;
  late String viewailink;
  late bool show;
  late bool isPublic;
  List<String> ?points;
  CameraModel(
      {this.name = '',
        this.des = '',
        this.link = '',
        this.online = false,
        this.type = '',
        this.area = '',
        this.node = '',
        this.viewlink = '',
        this.show = false,
        this.isPublic = false,
        this.viewfulllink = '',
        this.viewailink = '',
        this.points}){
    initValue();
  }

  @override
  void initValue(){
    data['name'] = name;
    data['des'] = des;
    data['link'] = link;
    data['online'] = online;
    data['area'] = area;
    data['node'] = node;
    data['viewlink'] = viewlink;
    data['viewfulllink'] = viewfulllink;
    data['viewailink'] = viewailink;
    data['show'] = show;
    data['isPublic'] = isPublic;
    data['points'] = points;
    data['type'] = type;
  }


  CameraModel.fromJson(Map<String, dynamic> json) {
    updateData(json);
    initValue();
  }

  @override
  updateData(Map<String, dynamic> json) {
    name = json['name']??'';
    des = json['des']??'';
    link = json['link']??'';
    online = json['online']??'';
    type = json['type']??'';
    area = json['area']??'';
    node = json['node']??'';
    viewlink = json['viewlink']??'';
    viewailink = json['viewailink']??'';
    viewfulllink = json['viewfulllink']??'';
    points = json['point']??[];
    show = false;
    isPublic = false;
  }

  @override
  String getModelName() {
    // TODO: implement getModelName
    return 'List Camera';
  }

  @override
  TemplateModel getEmptyModel() {
    return CameraModel();
  }

  @override
  Future<bool> create() {
    // TODO: implement create
    return super.create();
  }

  @override
  Future<bool> update() {
    // TODO: implement update
    return super.update();
  }

  @override
  Future<bool> delete() {
    // TODO: implement delete
    return super.delete();
  }

  Map<String, dynamic> toNewJson() {
    final Map<String, dynamic> dataJson = <String, dynamic>{};
    dataJson['name'] = name;
    dataJson['area'] = area;
    dataJson['node'] = node;
    return dataJson;
  }


}

final CameraModel tempCamera  = CameraModel(
    name: 'Tạo test',
    des: 'Tạo test,http://office.stvg.vn:59053/File/image/323032322d31302d32352d30392d34392d33352e6a70677c363338303232383831373532363330313536,http://office.stvg.vn:59053/File/image/323032322d31302d32352d30392d34392d33352e6a70677c363338303232383831373532363330313536,http://office.stvg.vn:59053/File/image/323032322d31302d32352d30392d34392d33352e6a70677c363338303232383831373532363330313536',
    link: 'http://office.stvg.vn:59053/File/image/323032322d31302d32352d30392d34392d33352e6a70677c363338303232383831373532363330313536',
    type: 'person',
    area: '',
    viewlink: ''
);