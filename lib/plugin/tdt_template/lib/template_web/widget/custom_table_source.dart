import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../../../../utils/utils.dart';
import '../../controller/controller.dart';
import '../create_view.dart';
import '../data_table_report.dart';
import '../fields/field.dart';

class CustomDataSource extends DataGridSource {
  CustomDataSource(
      {this.isReport = false,
      required this.modelType,
      this.isEdit = false,
      required RxList<TemplateModel> list,
      required this.callback,
      required this.listColumn,
      required this.context,
      this.search = '',
      required this.listAllModel}) {
    context = context;
    listModel = list;
    buildPaginatedDataGridRows();
  }

  BuildContext context;
  final MenuCallback callback;
  final bool isEdit;
  final bool isReport;
  List<CustomDataGridRow> _dataGridRow = [];
  List<String> listColumn = [];
  final String search;
  dynamic newCellValue;
  final TemplateModel modelType;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  void buildPaginatedDataGridRows() {
    _dataGridRow = listModel
        .map((model) => CustomDataGridRow(
            model: model,
            cells: listColumn
                .map(
                  (e) => DataGridCell(columnName: e, value: model.getValue(e)),
                )
                .toList()))
        .toList(growable: false);
  }

  void updateDataGriDataSource() {
    notifyListeners();
    buildPaginatedDataGridRows();
  }

  RxList<TemplateModel> listModel = <TemplateModel>[].obs;
  RxList<TemplateModel> listAllModel = <TemplateModel>[].obs;

  @override
  List<DataGridRow> get rows => _dataGridRow;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getBackgroundColor() {
      return Colors.transparent;
      int index = _dataGridRow.indexOf(row as CustomDataGridRow) + 1;
      if (index % 2 == 0) {
        return ThemeConfig.whiteColor;
      } else {
        return ThemeConfig.background2;
      }
    }

    List<Widget> listWidget = row.getCells().map<Widget>((dataGridCell) {
      Color getColor() {
        return Colors.transparent;
        if (search.isNotEmpty && dataGridCell.value.toString().toLowerCase().contains(search.toLowerCase())) {
          return Colors.blue[200]!;
        } else {
          return _dataGridRow.indexOf((row as CustomDataGridRow)) % 2 == 0
              ? ThemeConfig.whiteColor
              : ThemeConfig.background2;
        }
      }

      return dataGridCell.columnName != 'action_button'
          ? Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(color: isReport ? getColor() : Colors.transparent),
              padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 2),
              child: MyField(
                showlabel: false,
                field: (row as CustomDataGridRow).model.getInfoField(dataGridCell.columnName,{}),
                view: 'list',
                model: row.model,
                callback: (value) {
                  row.model.setValue(dataGridCell.columnName, value);
                },
              ),
            )
          : _buildActionRow((row as CustomDataGridRow).model,
              _dataGridRow.indexOf(row) % 2 == 0 ? ThemeConfig.whiteColor : ThemeConfig.background2);
    }).toList();
    // TODO: implement buildRow
    return DataGridRowAdapter(color: getBackgroundColor(), cells: listWidget);
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    //check number
    final String? value1 =
        a?.getCells().firstWhereOrNull((element) => element.columnName == sortColumn.name)?.value.toString();
    final String? value2 =
        b?.getCells().firstWhereOrNull((element) => element.columnName == sortColumn.name)?.value.toString();

    int? aLength = value1?.length;
    int? bLength = value2?.length;

    if (aLength == null || bLength == null) {
      return 0;
    }

    try {
      DateTime dateTime1 = DateFormat('HH:mm:ss dd/MM/yyyy').parse(value1!);
      DateTime dateTime2 = DateFormat('HH:mm:ss dd/MM/yyyy').parse(value2!);
      if (sortColumn.sortDirection == DataGridSortDirection.ascending) {
        return dateTime1.compareTo(dateTime2);
      } else {
        return dateTime2.compareTo(dateTime1);
      }
    } catch (e) {
      print(e);
    }

    try {
      double double1 = double.parse(value1!);
      double double2 = double.parse(value2!);
      if (sortColumn.sortDirection == DataGridSortDirection.ascending) {
        return double1.compareTo(double2);
      } else {
        return double2.compareTo(double1);
      }
    } catch (e) {
      print(e);
    }

    return super.compare(a, b, sortColumn);
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex, String summaryValue) {
    if (double.tryParse(summaryValue) != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 2),
        child: Text(
          getMoneyFormat(double.tryParse(summaryValue)),
          style: ThemeConfig.defaultStyle.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 2),
        child: Text(
          summaryValue,
          style: ThemeConfig.defaultStyle.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      );
    }
  }

  Widget _buildActionRow(TemplateModel model, Color color) {
    Map<String, dynamic> field = (modelType.getListViewTemplate()['fields'] as List)
        .where((element) => element['field'] == 'action_button')
        .first;
    if (field['type'] == 'multiple_button') {
      return _buildActionMultipleButton(model, color);
    }
    return _buildActionDropdownButton(model, color);
  }

  List<PopupMenuItem<String>> _buildDropdownList(TemplateModel model, Color color) {
    return ((modelType.getListViewTemplate()['fields'] as List)
            .where((element) => element['field'] == 'action_button')
            .first['action'] as List)
        .map((e) => PopupMenuItem<String>(
              height: 30,
              value: e['type'],
              child: Row(
                children: [
                  Icon(
                    e['icon'],
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    e['label'].toString().toLowerCase(),
                    style: ThemeConfig.labelStyle.copyWith(color: ThemeConfig.textColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildActionDropdownButton(TemplateModel model, Color color) {
    return GestureDetector(
      onTapUp: (TapUpDetails details) async {
        double left = details.globalPosition.dx - details.localPosition.dx - 7 * ThemeConfig.defaultPadding / 2;
        double top = details.globalPosition.dy - details.localPosition.dy + 35;
        await showMenu<String>(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2 * ThemeConfig.borderRadius))),
          context: context,
          position: RelativeRect.fromLTRB(left, top, left, top),
          //position where you want to show the menu on screen
          items: _buildDropdownList(model, color),
          elevation: 8.0,
        ).then<void>((String? value) {
          if (value != null) {
            _buildAction(model, value);
          }
        });
      },
      child: const Icon(
        Icons.more_vert_outlined,
        color: Colors.grey,
        size: 20,
      ),
    );
  }

  Widget _buildActionMultipleButton(TemplateModel model, Color color) {
    return Container(
      // color: color,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ((modelType.getListViewTemplate()['fields'] as List)
                .where((element) => element['field'] == 'action_button')
                .first['action'] as List)
            .map((e) => Tooltip(
                  message: e['label'] ?? '',
                  child: InkWell(
                    onTap: () {
                      _buildAction(model, e['type'] ?? '');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 4),
                      child: Icon(
                        e['icon'],
                        color: e['color'] ?? ThemeConfig.buttonPrimary,
                        size: e['width'] ?? ThemeConfig.defaultSize,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  _buildAction(TemplateModel model, String action) {
    if (action == 'edit') {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              content: CreateView(
                model: model,
                isNew: false,
              ),
            );
          }).then((value) {
        if (value == null) {
          model.initValue();
        } else {
          if (!value) {
            model.initValue();
          } else {
            listModel.refresh();
            updateDataGriDataSource();
            callback(true);
          }
        }
      });
    } else if (action == 'delete') {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Xóa ${model.getValue('name')}'),
            content: Text('Bạn có muốn xóa ${model.getValue('name')}'),
            actions: [
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    model.delete().then((value) {
                      if (value) {
                        listModel.remove(model);
                        listAllModel.remove(model);
                        updateDataGriDataSource();
                        // appController.message = SweetAlert(
                        //   type: SweetAlertType.success,
                        //   message: 'Xóa ${model.getModelName()} thành công',
                        //   title: 'Thành công',
                        // );
                        // appController.pushNotificationStream.rebuildWidget(true);
                        callback(true);
                      } else {
                        // appController.message = SweetAlert(
                        //   type: SweetAlertType.error,
                        //   message: 'Xóa ${model.getModelName()} không thành công',
                        //   title: 'Lỗi',
                        // );
                        // appController.pushNotificationStream.rebuildWidget(true);
                      }
                    });
                  },
                  child: const Text('Xóa')),
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'))
            ],
          );
        },
      );
    } else if (action == 'preview') {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              content: model.getPreviewScreen(),
            );
          });
    }
  }
  @override
  Widget? buildEditWidget(
      DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType = ((dataGridRow as CustomDataGridRow).model.getValue(column.columnName) is int ||
        dataGridRow.model.getValue(column.columnName) is double);
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        style: ThemeConfig.defaultStyle,
        autofocus: true,
        controller: editingController..text = dataGridRow.model.getValue(column.columnName).toString(),
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        keyboardType: TextInputType.text,
        onChanged: (String value) {
          dataGridRow.model.setValue(column.columnName, value);
        },
        onSubmitted: (String value) {
          // In Mobile Platform.
          // Call [CellSubmit] callback to fire the canSubmitCell and
          // onCellSubmit to commit the new value in single place.
          // submitCell();
        },
      ),
    );
  }
}

class CustomDataGridRow extends DataGridRow {
  TemplateModel model;

  CustomDataGridRow({required super.cells, required this.model});
}
