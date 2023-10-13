import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../model/template/template_model.dart';

class ReportController extends GetxController {
  RxBool isLoading = false.obs;
  late final RxList<TemplateModel> listDataModel = List<TemplateModel>.empty().obs;
  late TemplateModel typeModel = TemplateModel();
  final GlobalKey<SfDataGridState> keyGridView = GlobalKey<SfDataGridState>();
  late Map<dynamic, dynamic> template = {};
  late String titleName = '';
  late bool changeDate = true;
  late bool selectb2e = true;
  double rowHeight = 30;
  bool byShift = false;
  String shift = '1';
  late String url = '';
  String urlUpdateApi = '';
  final TextEditingController beginController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  DateTime begin = DateTime.now();
  DateTime end = DateTime.now();

  Future loadData() async {}

  Future<bool> updateReport() async {
    String data = '';
    List listModelEdit = listDataModel.where((model) => model.isEdit).toList();
    if (listModelEdit.isEmpty) {
      return true;
    } else {
      data = jsonEncode(listModelEdit.map((e) => e.data).toList());
    }
    if (urlUpdateApi.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
