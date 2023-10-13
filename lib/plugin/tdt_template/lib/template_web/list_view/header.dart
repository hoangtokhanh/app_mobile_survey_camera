import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Row, Border, Column;
import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';
import '../create_view.dart';
import '../import.dart';

class ListViewHeader extends StatelessWidget {
  ListViewHeader(
      {Key? key,
      this.titleName,
      required this.callback,
      required this.keyGridView,
      required this.listDataModel,
      required this.template,
      required this.typeModel, this.headerAction})
      : super(key: key);
  final RxList<TemplateModel> listDataModel;
  final TemplateModel typeModel;
  final GlobalKey<SfDataGridState> keyGridView;
  final Map<dynamic, dynamic> template;
  final MenuCallback callback;
  final String? titleName;
  final RxBool isEdit = false.obs;
  final Widget ?headerAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [headerAction??const SizedBox(),_buildHeaderButton(context), _buildSearch()],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      width: 300,
      height: 40,
      child: TextField(
        onChanged: (value) {
          callback({'search': value});
        },
        style: TextStyle(fontSize: ThemeConfig.smallSize),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          contentPadding: ThemeConfig.contentPadding,
          hintText: 'Tìm kiếm...',
          hintStyle: TextStyle(color: ThemeConfig.greyColor, fontSize: ThemeConfig.smallSize),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.redAccent)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: ThemeConfig.greyColor2)),
        ),
      ),
    );
  }

  Widget _buildHeaderButton(context) {
    if ((template['buttons'] as List).isEmpty) {
      return const SizedBox();
    } else {
      return _buildMultipleButton(context);
    }
  }

  Widget _buildMultipleButton(context){
    return Row(
      children: (template['buttons'] as List).map((e) => _buildAction(e,context)).toList(),
    );
  }

  Widget _buildAction(Map button,context){
    return InkWell(
      onTap: () {
        switch (button['type']) {
          case 'create':
            _buildActionCreate(context);
            break;
          case 'import':
            _buildActionImport(context);
            break;
          default:
            _buildActionExport(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: ThemeConfig.greyColor2.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(ThemeConfig.borderRadius / 2)
        ),
        margin: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding/4),
        padding: EdgeInsets.symmetric(
            horizontal: ThemeConfig.defaultPadding / 2),
        height: 40,
        child: Row(
          children: [
            Icon(button['icon'], size: ThemeConfig.defaultSize + 5,
              color: ThemeConfig.primaryColor,),
            Text(
              button['label'],
              style: ThemeConfig.defaultStyle,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderActionDropdown(context) {
    return isEdit.value
        ? _buildEditActionButton(context)
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(ThemeConfig.borderRadius / 2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFirstButton((template['buttons'] as List)[0], context),
                (template['buttons'] as List).length > 2
                    ? PopupMenuButton<dynamic>(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: ThemeConfig.blackColor,
                          size: 20,
                        ),
                        itemBuilder: (context) => (template['buttons'] as List)
                            .getRange(1, (template['buttons'] as List).length)
                            .map((e) => _buildDropdownActionItem(e, context))
                            .toList(),
                        onSelected: (value) async {
                          switch (value) {
                            case 'create':
                              _buildActionCreate(context);
                              break;
                            case 'import':
                              _buildActionImport(context);
                              break;
                            default:
                              _buildActionExport(context);
                          }
                        },
                      )
                    : const SizedBox()
              ],
            ),
          );
  }

  PopupMenuItem _buildDropdownActionItem(Map<String, dynamic> button, context) {
    return PopupMenuItem(
      value: button['type'],
      child: Row(
        children: [
          Icon(
            (button['icon'] as IconData),
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            (button['label'] as String),
            style: TextStyle(
              color: ThemeConfig.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditActionButton(context) {
    return Row(
      children: [
        _buildCancelButton(),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      onTap: () async {
        for (TemplateModel model in listDataModel) {
          model.initValue();
        }
        isEdit.value = false;
        callback({'is_edit': false});
      },
      child: Container(
        width: 150,
        padding:
            EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding / 4, horizontal: ThemeConfig.defaultPadding / 2),
        margin: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 2),
        decoration: BoxDecoration(
            color: ThemeConfig.greyColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(ThemeConfig.borderRadius / 2)),
        child: Row(
          children: [
            Icon(
              Icons.cancel_outlined,
              size: 20,
              color: ThemeConfig.whiteColor,
            ),
            const SizedBox(width: 10),
            Text(
              'Cancel',
              style: TextStyle(
                color: ThemeConfig.whiteColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return InkWell(
      onTap: () {
        isEdit.value = false;
        callback({'is_edit': false});
      },
      child: Container(
        width: 150,
        padding:
            EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding / 4, horizontal: ThemeConfig.defaultPadding / 2),
        margin: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 2),
        decoration: BoxDecoration(
            color: ThemeConfig.buttonPrimary.withOpacity(0.9),
            borderRadius: BorderRadius.circular(ThemeConfig.borderRadius / 2)),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 20,
              color: ThemeConfig.whiteColor,
            ),
            const SizedBox(width: 10),
            Text(
              'Save',
              style: TextStyle(
                color: ThemeConfig.whiteColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstButton(Map<String, dynamic> button, context) {
    return InkWell(
      onTap: () {
        switch (button['type']) {
          case 'create':
            _buildActionCreate(context);
            break;
          case 'import':
            _buildActionImport(context);
            break;
          case 'edit':
            _buildActionEdit(context);
            break;
          default:
            _buildActionExport(context);
        }
      },
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ThemeConfig.borderRadius / 2),
            border: Border.all(color: ThemeConfig.greyColor)),
        child: Icon(
          (button['icon'] as IconData),
          size: ThemeConfig.titleSize,
          color: ThemeConfig.blackColor,
        ),
      ),
    );
  }

  _buildActionCreate(context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            content: CreateView(
              model: typeModel.getEmptyModel(),
              isNew: true,
            ),
          );
        }).then((value) {
      if (value != null) {
        listDataModel.add(value);
        callback(true);
      }
    });
  }

  _buildActionEdit(context) {
    isEdit.value = true;
    callback({'is_edit': true});
  }

  _buildActionImport(context) {
    return  showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return MyImportScreen(typeModel: typeModel);
        }).then((value){
          callback(true);
    });
  }

  _buildActionExport(context) {
    return _exportExcel(context);
  }

  Future<void> _exportExcel(context) async {
    final Workbook workbook = keyGridView.currentState!.exportToExcelWorkbook();
    final Style globalStyle = workbook.styles.add('globalStyle');
    globalStyle.fontName = 'Times New Roman';
    final Worksheet sheet = workbook.worksheets[0];
    sheet.insertRow(1, 1, ExcelInsertOptions.formatAsAfter);
    sheet.insertRow(1, 1, ExcelInsertOptions.formatAsAfter);
    sheet.getRangeByName('B1:H1').merge();
    sheet.getRangeByName('B1:H1').cellStyle.hAlign = HAlignType.left;
    sheet.getRangeByName('B1:H1').cellStyle.bold = true;
    sheet.getRangeByName('B1').setText(typeModel.getModelName());
    bool checkColDelete = (template['fields'] as List)
        .where((element) => element['field'] == 'action_button')
        .isNotEmpty;
    if (checkColDelete) {
      sheet.deleteColumn((template['fields'] as List).length,1);
    }
    int maxColumn = (template['fields'] as List).length;
    for (int i = 1; i < maxColumn; i++) {
      sheet.getRangeByIndex(3, i).setText(template['fields'][i - 1]['label']);
    }
    final List<int> bytes = workbook.saveAsStream();
    // print(path);
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return CupertinoAlertDialog(
    //       title: const Text('Download successfully'),
    //       content: Text('Download successfully'),
    //       actions: [CupertinoDialogAction(onPressed: Get.back, child: const Text('OK'))],
    //     );
    //   },
    // );
  }
}
