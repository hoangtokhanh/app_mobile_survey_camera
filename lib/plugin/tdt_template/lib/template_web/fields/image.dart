import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tdt_template/template_web/fields/parent_field.dart';
import '../../../../config/list_string_config.dart';
import '../widget/image.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class ImageField extends StatefulWidget {
  const ImageField({Key? key}) : super(key: key);

  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  get view => FieldParent.of(context).view;

  get field => FieldParent.of(context).field;

  get model => FieldParent.of(context).model;

  get showLabel => FieldParent.of(context).showLabel;

  get callback => FieldParent.of(context).callback;

  @override
  void initState() {
    HttpOverrides.global = MyHttpOverrides();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFieldList();
  }

  final Widget _buildSpace = const SizedBox(height: 10);

  // Widget _buildFieldEdit(){
  String getInitValue() {
    if (field['type'] == 'dropdown') {
      return ListStringConfig.getValueInList(field['list_string'], model.getValue(field['field']));
    } else {
      return model.getValue(field['field']).toString();
    }
  }

  Widget _buildFieldList() {
    Alignment textAlign = (model.getValue(field['field']) is int || model.getValue(field['field']) is double)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return InkWell(
      onTap: _showMyDialog,
      child: Align(
          alignment: textAlign,
          child: ImageWidget(
            url: model.getValue(field['field']).toString(),
            borderWidth: 0,
            color: Colors.transparent,
          )),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Image.network(model.getValue(field['field']).toString()),
        );
      },
    );
  }
}
