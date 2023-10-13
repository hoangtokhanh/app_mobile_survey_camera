import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Row;
import '../../../../config/theme_config.dart';
import '../../../../controller/report_controller.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';
import '../create_view.dart';

class ButtonHeaderReport extends StatefulWidget {
  const ButtonHeaderReport({Key? key, required this.callback, required this.controller}) : super(key: key);
  final MenuCallback callback;
  final ReportController controller;

  @override
  State<ButtonHeaderReport> createState() => _ButtonHeaderReportState();
}

class _ButtonHeaderReportState extends State<ButtonHeaderReport> {
  final RxBool isEdit = false.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ThemeConfig.defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeaderButton(context),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(context) {
    if ((widget.controller.template['buttons'] as List).isEmpty) {
      return const SizedBox();
    } else {
      return _buildHeaderActionDropdown(context);
    }
  }

  Widget _buildHeaderActionDropdown(context) {
    return Obx(() => isEdit.value
        ? _buildEditActionButton(context)
        : Row(
            children:
                (widget.controller.template['buttons'] as List).map((e) => _buildFirstButton(e, context)).toList(),
          ));
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
        _buildPreview(context),
        SizedBox(
          width: ThemeConfig.defaultPadding,
        ),
        _buildCancelButton(),
        SizedBox(
          width: ThemeConfig.defaultPadding,
        ),
        _buildSaveButton(context),
      ],
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      onTap: () async {
        if (!widget.controller.isLoading.value) {
          for (TemplateModel model in widget.controller.listDataModel) {
            model.initValue();
          }
          isEdit.value = false;
          widget.callback({'is_edit': false});
        }
      },
      child: Container(
        height: 48,
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: ThemeConfig.greyColor, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Icon(
              Icons.cancel_outlined,
              size: 20,
              color: ThemeConfig.whiteColor,
            ),
            const SizedBox(width: 10),
            Text(
              'Hủy',
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

  Widget _buildSaveButton(context) {
    return InkWell(
      onTap: () async {
        if (!widget.controller.isLoading.value) {
          widget.controller.isLoading.value = true;
          widget.controller.updateReport().then((value) {
            if (value) {
              isEdit.value = false;
              widget.callback({'is_edit': false});
              // appController.message = const SweetAlert(
              //   type: SweetAlertType.success,
              //   message: 'Dữ liệu chốt số đã được cập nhập',
              //   title: 'Thành công',
              // );
              // appController.pushNotificationStream.rebuildWidget(true);
            } else {
              // appController.message = const SweetAlert(
              //   type: SweetAlertType.error,
              //   message: 'Cập nhật chốt số thất bại. Vui lòng thao tác lại',
              //   title: 'Lỗi',
              // );
              // appController.pushNotificationStream.rebuildWidget(true);
            }
          });
          widget.controller.isLoading.value = false;
          showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Chốt số'),
                content: Text('Dữ liệu mới đã được lưu, hệ thống sẽ tính toán và cập nhật lại kết quả sau 5 phút'),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Xác nhận'))
                ],
              );
            },
          );
        }
      },
      child: Container(
        height: 48,
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: ThemeConfig.primaryColor, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 20,
              color: ThemeConfig.whiteColor,
            ),
            const SizedBox(width: 10),
            Text(
              'Lưu',
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
          case 'refresh':
            _buildActionRefresh(context);
            break;
          default:
            _buildActionExport(context);
        }
      },
      child: Container(
        height: 48,
        width: 150,
        margin: EdgeInsets.only(right: ThemeConfig.defaultPadding),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: ThemeConfig.primaryColor, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Icon(
              (button['icon'] as IconData),
              size: 20,
              color: ThemeConfig.whiteColor,
            ),
            const SizedBox(width: 10),
            Text(
              (button['label'] as String),
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

  Widget _buildPreview(context) {
    return InkWell(
      onTap: () {
        widget.callback(true);
      },
      child: Container(
        width: 150,
        height: 48,
        margin:
            EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding / 2, horizontal: ThemeConfig.defaultPadding / 2),
        decoration: BoxDecoration(
            color: ThemeConfig.primaryColor, borderRadius: BorderRadius.circular(ThemeConfig.borderRadius / 2)),
        padding: EdgeInsets.all(ThemeConfig.defaultPadding / 2),
        child: Row(
          children: [
            Icon(
              Icons.preview,
              size: 20,
              color: ThemeConfig.whiteColor,
            ),
            const SizedBox(width: 10),
            Text(
              'Xem trước',
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

  _buildActionCreate(context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            content: CreateView(
              model: widget.controller.typeModel.getEmptyModel(),
              isNew: true,
            ),
          );
        }).then((value) {
      if (value != null) {
        widget.controller.listDataModel.add(value);
        widget.callback(true);
      }
    });
  }

  _buildActionEdit(context) {
    setState(() {
      isEdit.value = true;
    });
    widget.callback({'is_edit': true});
  }

  _buildActionImport(context) {
    // return  showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return ImportScreen(typeModel: widget.controller.typeModel,listDataModel: widget.controller.listDataModel);
    //     }).then((value){
    //   widget.callback(true);
    // });
  }

  _buildActionExport(context) {
    return _exportExcel(context);
  }

  Future<void> _exportExcel(context) async {
    final Workbook workbook = widget.controller.keyGridView.currentState!.exportToExcelWorkbook();
    final Style globalStyle = workbook.styles.add('globalStyle');
    globalStyle.fontName = 'Times New Roman';
    final Worksheet sheet = workbook.worksheets[0];
    sheet.insertRow(1, 1, ExcelInsertOptions.formatAsAfter);
    sheet.insertRow(1, 1, ExcelInsertOptions.formatAsAfter);
    sheet.getRangeByName('B1:H1').merge();
    sheet.getRangeByName('B1:H1').cellStyle.hAlign = HAlignType.left;
    sheet.getRangeByName('B1:H1').cellStyle.bold = true;
    sheet.getRangeByName('B1').setText(widget.controller.titleName.toUpperCase());
    sheet.getRangeByName('A3:Z3').cellStyle.bold = true;
    //
    if (widget.controller.changeDate) {
      sheet.getRangeByName('B2:C2').merge();
      sheet.getRangeByName('B2:C2').cellStyle.hAlign = HAlignType.left;
      sheet.getRangeByName('B2').setText(widget.controller.selectb2e
          ? 'Từ ngày: ${widget.controller.beginController.text}'
          : 'Ngày: ${widget.controller.beginController.text}');
      //
      if (widget.controller.selectb2e) {
        sheet.getRangeByName('D2:E2').merge();
        sheet.getRangeByName('D2:E2').cellStyle.hAlign = HAlignType.left;
        sheet.getRangeByName('D2').setText('Đến ngày: ${widget.controller.endController.text}');
      }
      if (widget.controller.byShift) {
        sheet.getRangeByName('D2:E2').merge();
        sheet.getRangeByName('D2:E2').cellStyle.hAlign = HAlignType.left;
        sheet.getRangeByName('D2').setText('Ca: ${widget.controller.shift}');
      }
    }
    int maxColumn = (widget.controller.typeModel.getListViewTemplate()['fields'] as List).length;
    for (int i = 1; i < maxColumn + 1; i++) {
      sheet.getRangeByIndex(3, i).setText(widget.controller.typeModel.getListViewTemplate()['fields'][i - 1]['label']);
    }
    bool checkColDelete = (widget.controller.typeModel.getListViewTemplate()['fields'] as List)
        .where((element) => element['field'] == 'action_button')
        .isNotEmpty;
    if (checkColDelete) {
      sheet.deleteColumn((widget.controller.typeModel.getListViewTemplate()['fields'] as List).length);
    }
    final List<int> bytes = workbook.saveAsStream();
    // print(path);
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Download successfully'),
          content: Text('Download successfully'),
          actions: [CupertinoDialogAction(onPressed: Get.back, child: const Text('OK'))],
        );
      },
    );
  }

  _buildActionRefresh(context) {
    widget.controller.loadData();
  }
}
