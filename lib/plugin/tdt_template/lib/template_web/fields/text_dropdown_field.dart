import 'package:flutter/material.dart';
import 'package:tdt_template/template_web/fields/parent_field.dart';
import 'package:tdt_template/template_web/fields/text_field.dart';
import '../../../../config/list_string_config.dart';
import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';
import 'dropdown_field.dart';

class MyTextDropdownField extends StatefulWidget {
  const MyTextDropdownField({Key? key}) : super(key: key);

  @override
  State<MyTextDropdownField> createState() => _MyTextDropdownFieldState();
}

class _MyTextDropdownFieldState extends State<MyTextDropdownField> {
  get view => FieldParent.of(context).view;

  get field => FieldParent.of(context).field;

  get model => FieldParent.of(context).model;

  get showLabel => FieldParent.of(context).showLabel;

  get callback => FieldParent.of(context).callback;

  @override
  Widget build(BuildContext context) {
    return (view.compareTo('edit') == 0 || view.compareTo('create') == 0) ? _buildFieldEdit() : _buildFieldList();
  }

  final Widget _buildSpace = const SizedBox(height: 10);

  Widget _buildFieldEdit() {
    return Column(
      children: [
        (view.compareTo('edit') == 0 && field['readOnly'] == true)
            ? _buildEditReadOnly()
            : view.compareTo('edit') == 0
                ? FieldParent(
                    showLabel: showLabel,
                    field: field,
                    model: model,
                    callback: callback,
                    view: view,
                    child: Builder(
                      builder: (BuildContext fieldParentContext) {
                        return const MyDropdownField();
                      },
                    ),
                  )
                : _buildEditReadOnly(),
        _buildSpace
      ],
    );
  }

  Widget _buildFieldList() {
    return Text(
      ListStringConfig.getValueInList(field['list_string'], model.getValue(field['field'])),
      style: ThemeConfig.defaultStyle,
    );
  }

  Widget _buildEditReadOnly() {
    return FieldParent(
      showLabel: showLabel,
      field: field,
      model: model,
      callback: callback,
      view: view,
      child: Builder(
        builder: (BuildContext fieldParentContext) {
          return const MyTextField();
        },
      ),
    );
  }
}
