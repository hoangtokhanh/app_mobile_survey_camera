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

class ListViewHeaderReport extends StatelessWidget {
  ListViewHeaderReport({Key? key, required this.callback, required this.controller}) : super(key: key);
  final MenuCallback callback;
  final ReportController controller;
  final RxBool isEdit = false.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ThemeConfig.defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Báo Cáo',
                    style:
                        ThemeConfig.defaultStyle.copyWith(color: ThemeConfig.hoverColor, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: ThemeConfig.defaultSize,
                  color: ThemeConfig.blackColor,
                ),
                Text(
                  controller.titleName,
                  style: ThemeConfig.defaultStyle.copyWith(color: ThemeConfig.blackColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // _buildHeaderButton(context),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(context) {
    if ((controller.template['buttons'] as List).isEmpty) {
      return const SizedBox();
    } else {
      return Obx(() => _buildHeaderActionDropdown(context));
    }
  }

  Widget _buildHeaderActionDropdown(context) {
    return isEdit.value
        ? _buildEditActionButton(context)
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: ThemeConfig.buttonPrimary, borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFirstButton((controller.template['buttons'] as List)[0], context),
                (controller.template['buttons'] as List).length > 1
                    ? PopupMenuButton<dynamic>(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: ThemeConfig.whiteColor,
                          size: 20,
                        ),
                        itemBuilder: (context) => (controller.template['buttons'] as List)
                            .getRange(1, (controller.template['buttons'] as List).length)
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
        _buildSaveButton(context),
      ],
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      onTap: () async {
        if (!controller.isLoading.value) {
          for (TemplateModel model in controller.listDataModel) {
            model.initValue();
          }
          isEdit.value = false;
          callback({'is_edit': false});
        }
      },
      child: Container(
        width: 150,
        padding:
            EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding / 2, horizontal: ThemeConfig.defaultPadding / 2),
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
        if (!controller.isLoading.value) {
          controller.isLoading.value = true;
          controller.updateReport().then((value) {
            if (value) {
              isEdit.value = false;
              callback({'is_edit': false});
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
          controller.isLoading.value = false;
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
        width: 150,
        padding:
            EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding / 2, horizontal: ThemeConfig.defaultPadding / 2),
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
      child: Padding(
        padding: EdgeInsets.all(ThemeConfig.defaultPadding / 2),
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

  _buildActionCreate(context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            content: CreateView(
              model: controller.typeModel.getEmptyModel(),
              isNew: true,
            ),
          );
        }).then((value) {
      if (value != null) {
        controller.listDataModel.add(value);
        callback(true);
      }
    });
  }

  _buildActionEdit(context) {
    isEdit.value = true;
    callback({'is_edit': true});
  }

  _buildActionImport(context) {
    // return  showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return ImportScreen(typeModel: controller.typeModel,listDataModel: controller.listDataModel);
    //     }).then((value){
    //   callback(true);
    // });
  }

  _buildActionExport(context) {
    return _exportExcel(context);
  }

  Future<void> _exportExcel(context) async {
    final Workbook workbook = controller.keyGridView.currentState!.exportToExcelWorkbook();
    final Style globalStyle = workbook.styles.add('globalStyle');
    globalStyle.fontName = 'Times New Roman';
    final Worksheet sheet = workbook.worksheets[0];
    sheet.insertRow(1, 1, ExcelInsertOptions.formatAsAfter);
    sheet.insertRow(1, 1, ExcelInsertOptions.formatAsAfter);
    sheet.getRangeByName('B1:H1').merge();
    sheet.getRangeByName('B1:H1').cellStyle.hAlign = HAlignType.left;
    sheet.getRangeByName('B1:H1').cellStyle.bold = true;
    sheet.getRangeByName('B1').setText(controller.titleName.toUpperCase());
    sheet.getRangeByName('A3:Z3').cellStyle.bold = true;
    //
    if (controller.changeDate) {
      sheet.getRangeByName('B2:C2').merge();
      sheet.getRangeByName('B2:C2').cellStyle.hAlign = HAlignType.left;
      sheet.getRangeByName('B2').setText(controller.selectb2e
          ? 'Từ ngày: ${controller.beginController.text}'
          : 'Ngày: ${controller.beginController.text}');
      //
      if (controller.selectb2e) {
        sheet.getRangeByName('D2:E2').merge();
        sheet.getRangeByName('D2:E2').cellStyle.hAlign = HAlignType.left;
        sheet.getRangeByName('D2').setText('Đến ngày: ${controller.endController.text}');
      }
      if (controller.byShift) {
        sheet.getRangeByName('D2:E2').merge();
        sheet.getRangeByName('D2:E2').cellStyle.hAlign = HAlignType.left;
        sheet.getRangeByName('D2').setText('Ca: ${controller.shift}');
      }
    }
    int maxColumn = (controller.typeModel.getListViewTemplate()['fields'] as List).length;
    for (int i = 1; i < maxColumn + 1; i++) {
      sheet.getRangeByIndex(3, i).setText(controller.typeModel.getListViewTemplate()['fields'][i - 1]['label']);
    }
    bool checkColDelete = (controller.typeModel.getListViewTemplate()['fields'] as List)
        .where((element) => element['field'] == 'action_button')
        .isNotEmpty;
    if (checkColDelete) {
      sheet.deleteColumn((controller.typeModel.getListViewTemplate()['fields'] as List).length);
    }
    final List<int> bytes = workbook.saveAsStream();
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
    controller.loadData();
  }
}
