import 'package:flutter/material.dart';
import '../template/template_model.dart';
import 'view.dart';

class SmartContractModel extends TemplateModel with SmartContractView {
  late String name;
  late String symbol;
  late String project;

  SmartContractModel({
    this.name = '',
    this.symbol = '',
    this.project = '',
  }) {
    initValue();
  }

  @override
  void initValue() {
    data['name'] = name;
    data['symbol'] = symbol;
    data['project'] = project;
  }

  SmartContractModel.fromJson(Map<String, dynamic> json) {
    updateData(json);
    initValue();
  }

  @override
  updateData(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    symbol = json['symbol'] ?? '';
    project = json['project'] ?? '';
  }

  @override
  String getModelName() {
    // TODO: implement getModelName
    return 'List Camera';
  }

  @override
  TemplateModel getEmptyModel() {
    return SmartContractModel();
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
}
