import 'template/template_model.dart';

class ReloadControllerModel {
  late TypeReLoad type;
  final List<TemplateModel> data;

  ReloadControllerModel({required this.data, this.type = TypeReLoad.refresh});
}

enum TypeReLoad{
  refresh, reset
}