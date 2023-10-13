import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdt_template/template_web/fields/field.dart';
import 'package:tdt_template/template_web/fields/parent_field.dart';
import '../../../../config/list_string_config.dart';
import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';
import '../widget/my_input.dart';

class NameWithAvatar extends StatefulWidget {
  const NameWithAvatar({Key? key}) : super(key: key);

  @override
  State<NameWithAvatar> createState() => _NameWithAvatarState();
}

class _NameWithAvatarState extends State<NameWithAvatar> {
  get view => FieldParent.of(context).view;

  get field => FieldParent.of(context).field;

  get model => FieldParent.of(context).model;

  get showLabel => FieldParent.of(context).showLabel;

  get callback => FieldParent.of(context).callback;

  @override
  Widget build(BuildContext context) {
    return _buildFieldList();
  }

  Widget _buildFieldList() {
    return Row(
      children: (field['list_field'] as List)
          .map((e) => Padding(
                padding: EdgeInsets.only(right: ThemeConfig.defaultPadding / 2),
                child: MyField(field: e, model: model, callback: callback, view: view),
              ))
          .toList(),
    );
  }
}
