import 'package:flutter/material.dart';
import 'package:tdt_template/template_web/fields/parent_field.dart';
import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';
import '../widget/selection_button_2.dart';

class MyRelationField extends StatefulWidget {
  const MyRelationField({Key? key}) : super(key: key);

  @override
  State<MyRelationField> createState() => _MyRelationFieldState();
}

class _MyRelationFieldState extends State<MyRelationField> {
  get view => FieldParent.of(context).view;

  get field => FieldParent.of(context).field;

  get model => FieldParent.of(context).model;

  get showLabel => FieldParent.of(context).showLabel;

  get callback => FieldParent.of(context).callback;

  @override
  Widget build(BuildContext context) {
    return view.compareTo('edit') == 0 ? _buildFieldEdit() : _buildFieldList();
  }

  final Widget _buildSpace = const SizedBox(height: 10);

  Widget _buildFieldEdit() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          MyDropdown2(
              value: model.getValue(field['field']) ?? '',
              title: Text(
                '${field['label']} ${field['required'] ?? false ? '*' : ''}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: ThemeConfig.smallSize),
              ),
              data: field['list_string'],
              callback: (value) {
                model.setValue(field['field'], value);
              }),
          _buildSpace
        ],
      ),
    );
  }

  Widget _buildFieldList() {
    return Text(
      model.getValue(field['field']).toString(),
      style: ThemeConfig.defaultStyle,
    );
  }
}
