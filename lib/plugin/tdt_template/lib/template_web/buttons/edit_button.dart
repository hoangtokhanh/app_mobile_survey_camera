import 'package:flutter/material.dart';
import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';

class MyEditButton extends StatelessWidget {
  const MyEditButton({Key? key, required this.field, required this.model, required this.callback, required this.view})
      : super(key: key);
  final Map field;
  final TemplateModel model;
  final MenuCallback callback;
  final String view;

  @override
  Widget build(BuildContext context) {
    return view.compareTo('edit') == 0 ? _buildFieldEdit() : _buildFieldList();
  }

  final Widget _buildSpace = const SizedBox(height: 10);

  Widget _buildFieldEdit() {
    return const SizedBox();
  }

  Widget _buildFieldList() {
    return PopupMenuItem(
      value: 0,
      child: Row(
        children: [
          Icon(
            field['icon'],
            size: 15,
          ),
          const SizedBox(width: 10),
          Text(
            field['label'],
            style: TextStyle(
              color: ThemeConfig.textColor,
              fontSize: ThemeConfig.smallSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
