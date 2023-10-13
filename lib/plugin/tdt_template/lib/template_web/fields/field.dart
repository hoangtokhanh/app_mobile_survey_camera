import 'package:flutter/cupertino.dart';
import 'package:tdt_template/template_web/fields/parent_field.dart';
import 'package:tdt_template/template_web/fields/text_field.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/component_config.dart';
import '../../controller/controller.dart';

class MyField extends StatelessWidget {
  const MyField(
      {Key? key,
      this.showlabel = true,
      required this.field,
      required this.model,
      required this.callback,
      required this.view})
      : super(key: key);
  final Map field;
  final bool showlabel;
  final TemplateModel model;
  final MenuCallback callback;
  final String view;

  @override
  Widget build(BuildContext context) {
    return FieldParent(
      showLabel: showlabel,
      field: field,
      model: model,
      callback: callback,
      view: view,
      child: Builder(
        builder: (BuildContext fieldParentContext) {
          return ComponentConfig.mapComponent[field['type']] ?? const MyTextField();
        },
      ),
    );
  }
}
