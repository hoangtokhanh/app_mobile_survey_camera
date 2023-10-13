import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdt_template/template_web/fields/parent_field.dart';

import '../../../../config/list_string_config.dart';
import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';

class MyCheckboxField extends StatefulWidget {
  const MyCheckboxField({Key? key}) : super(key: key);

  @override
  State<MyCheckboxField> createState() => _MyCheckboxFieldState();
}

class _MyCheckboxFieldState extends State<MyCheckboxField> {
  get view => FieldParent.of(context).view;

  get field => FieldParent.of(context).field;

  get model => FieldParent.of(context).model;

  get showLabel => FieldParent.of(context).showLabel;

  get callback => FieldParent.of(context).callback;

  @override
  Widget build(BuildContext context) {
    return _buildFieldEdit();
  }

  final Widget _buildSpace = const SizedBox(height: 10);

  Widget _buildFieldEdit() {
    final TextStyle labelStyle = TextStyle(fontSize: ThemeConfig.smallSize, fontWeight: FontWeight.bold);
    return Checkbox(
      value: model.getValue(field['field']),
      onChanged: (bool? value) {
        setState(() {
          model.setValue(field['field'], value);
        });
      },
    );
  }

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
    return Align(
        alignment: textAlign, child: Text(model.getValue(field['field']).toString(), style: ThemeConfig.defaultStyle));
  }
}
