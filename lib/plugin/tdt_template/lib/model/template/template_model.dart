import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'template_view.dart';

class TemplateModel with TemplateView {
  final RxBool isLoading = false.obs;
  final RxBool isValidate = false.obs;
  bool isEdit = false;
  final Map<String, dynamic> data = {};

  getValue(String fieldName) {
    return data[fieldName] ?? '';
  }

  void setValue(String filedName, value) {
    switch (data[filedName].runtimeType) {
      case int:
        data[filedName] = int.tryParse(value.toString()) ?? 0;
        break;
      case double:
        data[filedName] = double.tryParse(value.toString()) ?? 0;
        break;
      default:
        data[filedName] = value;
    }

    checkValidateModel();
  }
  String getRecordName(){
    return '';
  }

  void setValues(Map<String, dynamic> values) {
    values.forEach((key, value) {
      data[key] = value;
      checkValidateModel();
    });
  }

  Map<String, dynamic> toJson() {
    return data;
  }

  Future<bool> update() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    return true;
  }

  Future<bool> create() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    return true;
  }

  Future<bool> delete() async {
    return true;
  }

  Map<dynamic, dynamic> getListViewTemplate() {
    return getView()['list_view'];
  }

  Map<dynamic, dynamic> getViewTemplateByName(String name) {
    return getView()[name] ?? getListViewTemplate();
  }

  Map<dynamic, dynamic> getEditViewTemplate() {
    return getView()['edit_view'];
  }

  Map<dynamic, dynamic> getCreateViewTemplate() {
    return getView()['create_view'];
  }

  Map<String, String> getAllFieldTemplate() {
    return getView()['all_field']??{};
  }

  bool isFilter(String field, [bool isReport = false]) {
    if (!isReport) {
      if (getListViewTemplate()['field_filter'] == null) {
        return false;
      } else {
        return ((getListViewTemplate()['field_filter'] as List).contains(field));
      }
    } else {
      if (getListViewTemplate()['field_not_filter'] == null) {
        return true;
      } else {
        return (!(getListViewTemplate()['field_not_filter'] as List).contains(field));
      }
    }
  }

  bool isSort(String field) {
    if (getListViewTemplate()['field_not_sort'] == null) {
      return true;
    } else {
      return (!(getListViewTemplate()['field_not_sort'] as List).contains(field));
    }
  }

  String getModelName() {
    return '';
  }

  List<String> getAllField() {
    List<String> fields = [];
    data.forEach((key, value) {
      fields.add(key);
    });
    return fields;
  }

  Map<String, String> getAllFieldMetadata() {
    Map<String, String> fields = {};
    Map<String, String> allFields = getAllFieldTemplate();
    if(allFields.isEmpty) {
      data.forEach((key,value) {
        fields[key] = key;
      });
    }else{
      allFields.forEach((key,value) {
        fields[key] = value;
      });
    }
    return fields;
  }

  TemplateModel getEmptyModel() {
    return TemplateModel();
  }

  Map getInfoField(String field,Map template) {
    Map infoField = {};
    List<Map> listField = template['fields'];
    for (Map element in listField) {
      if (element['field'] == field) {
        infoField = element;
      }
    }
    return infoField;
  }

  void initValue() {
    checkValidateModel();
  }

  void checkValidateModel() {
    List<Map> listField = [];
    bool validate = true;
    listField = getEditViewTemplate()['fields'];
    for (Map field in listField) {
      if (field['required'] ?? false) {
        if (data[field['field']] == null || data[field['field']] == '') {
          validate = false;
          break;
        }
      }
    }
    isValidate.value = validate;
  }

  updateData(Map<String, dynamic> json) {}

  TemplateModel fromJson(e) {
    TemplateModel myModel = TemplateModel();
    myModel.updateData(e);
    return myModel;
  }

  getPreviewScreen() {
    return Container();
  }
}
