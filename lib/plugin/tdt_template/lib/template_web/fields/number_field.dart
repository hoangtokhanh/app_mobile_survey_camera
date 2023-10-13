import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdt_template/template_web/fields/parent_field.dart';
import 'package:tdt_template/utils/utils.dart';
import '../../../../config/list_string_config.dart';
import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';
import '../widget/my_input.dart';

class MyNumberField extends StatefulWidget {
  const MyNumberField({Key? key}) : super(key: key);

  @override
  State<MyNumberField> createState() => _MyNumberFieldState();
}

class _MyNumberFieldState extends State<MyNumberField> {
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
    final TextStyle labelStyle = TextStyle(fontSize: ThemeConfig.smallSize, fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          MyInput(
            readOnly: (view.compareTo('edit') == 0) ? field['readOnly'] ?? false : false,
            contendPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            title: Container(
              alignment: Alignment.center,
              width: Get.width * 0.1,
              height: 50,
              decoration: BoxDecoration(
                  color: ThemeConfig.greyColor.withOpacity(0.2),
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(ThemeConfig.borderRadius / 2))),
              child: Text(
                '${field['label']} ${field['required'] ?? false ? '*' : ''}',
                style: labelStyle,
              ),
            ),
            maxLine: field['max_line'] ?? 1,
            initValue: getInitValue(),
            hasTitle: showLabel,
            hintText: field['label'],
            keyboardType: TextInputType.text,
            callbackUpdate: (value) {
              model.setValue(field['field'], value);
            },
          ),
          _buildSpace
        ],
      ),
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
        alignment: textAlign,
        child: SelectableText(getMoneyFormat(model.getValue(field['field'])),
            style: ThemeConfig.smallStyle.copyWith(color: ThemeConfig.whiteColor)));
  }
}
