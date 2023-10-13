import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:tdt_template/template_web/fields/parent_field.dart';
import '../../../../config/list_string_config.dart';
import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';
import '../widget/my_input.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({Key? key}) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final RxBool showPass = true.obs;

  get view => FieldParent.of(context).view;

  get field => FieldParent.of(context).field;

  get model => FieldParent.of(context).model;

  get showLabel => FieldParent.of(context).showLabel;

  get callback => FieldParent.of(context).callback;

  bool readOnly = false;

  @override
  void didChangeDependencies() {
    readOnly = (view.compareTo('edit') == 0) ? field['readOnly'] ?? false : false;
    super.didChangeDependencies();
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${field['label']} ${field['required'] ?? false ? '*' : ''}',
            style: ThemeConfig.defaultStyle,
          ),
          Obx(() => MyInput(
                obscureText: showPass.value,
                readOnly: readOnly,
                contendPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                textAlignVertical: const TextAlignVertical(y: 0),
                suffix: InkWell(
                  onTap: () => showPass.value = !showPass.value,
                  child: Icon(!showPass.value ? FeatherIcons.eye : FeatherIcons.eyeOff),
                ),
                prefixIcon: (view.compareTo('edit') == 0)?InkWell(
                  onTap: (){
                    setState(() {
                      readOnly = !readOnly;
                    });
                  },
                  child: Icon(readOnly ? FeatherIcons.lock : FeatherIcons.unlock),
                ):null,
                maxLine: field['max_line'] ?? 1,
                initValue: getInitValue(),
                hasTitle: showLabel,
                hintText: field['label'],
                keyboardType: TextInputType.text,
                callbackUpdate: (value) {
                  model.setValue(field['field'], value);
                },
              )),
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
        alignment: textAlign, child: Text(model.getValue(field['field']).toString(), style: ThemeConfig.defaultStyle));
  }
}
