import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdt_template/template_web/fields/parent_field.dart';
import 'package:tdt_template/template_web/fields/text_field.dart';
import '../../../../config/list_string_config.dart';
import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';
import '../widget/selection_button_2.dart';

class MyDropdownField extends StatefulWidget {
  const MyDropdownField({Key? key}) : super(key: key);

  @override
  State<MyDropdownField> createState() => _MyDropdownFieldState();
}

class _MyDropdownFieldState extends State<MyDropdownField> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${field['label']} ${field['required'] ?? false ? '*' : ''}',
            style: ThemeConfig.defaultStyle,
          ),
          (view.compareTo('edit') == 0 && field['readOnly'] == true)
              ? _buildEditReadOnly()
              : MyDropdown2(
                  value: model.getValue(field['field']) ?? '',
                  hintext: field['label'],
                  title: showLabel
                      ? Container(
                          alignment: Alignment.center,
                          width: Get.width * 0.1,
                          height: 50,
                          decoration: BoxDecoration(
                              color: ThemeConfig.greyColor.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.horizontal(left: Radius.circular(ThemeConfig.borderRadius / 2))),
                          child: Text(
                            '${field['label']} ${field['required'] ?? false ? '*' : ''}',
                            style: ThemeConfig.smallStyle.copyWith(fontWeight: FontWeight.bold),
                          ),
                        )
                      : const SizedBox(),
                  data: ListStringConfig.getListString(field['list_string']),
                  callback: (value) {
                    model.setValue(field['field'], value);
                  }),
          _buildSpace
        ],
      ),
    );
  }

  Widget _buildFieldList() {
    return SelectableText(
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
