import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../controller/report_controller.dart';
import '../../../../model/template/template_model.dart';
import '../../config/theme_config.dart';
import '../../controller/app_controller.dart';
import '../data_table_report.dart';
import '../list_view/search.dart';
import '../widget/custom_table_source.dart';
import '../widget/loading_screen.dart';
import '../widget/my_input_date.dart';
import '../widget/selection_button.dart';
import 'button_header.dart';

class TemplateReport extends StatefulWidget {
  TemplateReport({Key? key, required this.isEdit, required this.controller}) : super(key: key);
  late bool isEdit;
  final ReportController controller;

  @override
  State<TemplateReport> createState() => _TemplateReportState();
}

class _TemplateReportState extends State<TemplateReport> {
  DateTime begin = DateTime.now();
  DateTime end = DateTime.now();
  final DataGridController _dataGridController = DataGridController();
  late CustomDataSource _dataSource;
  List<String> sumCol = [];
  final filter = {};
  String search = '';
  RxList<TemplateModel> dataList = <TemplateModel>[].obs;
  List<String> column = [];
  final Map<String, List> allFilter = {};
  late Map<String, double> columnWidths = {};
  final RxInt _rowsPerPage = 50.obs;
  final List<GridSummaryColumn> sumRow = [];

  @override
  void initState() {
    _loadData();
    column.addAll((widget.controller.template['fields'] as List).map((e) => e['field']).toList().cast<String>());
    sumCol = widget.controller.typeModel.getListViewTemplate()['sum_col'] ?? [];
    sumRow.add(GridSummaryColumn(name: 'Count', columnName: column[0], summaryType: GridSummaryType.count));
    sumRow.addAll(sumCol
        .map((col) => GridSummaryColumn(name: 'Sum', columnName: col, summaryType: GridSummaryType.sum))
        .toList());
    _setData();
    super.initState();
  }

  void _loadData() async {
    _resetFilter();
    if (widget.controller.begin.compareTo(widget.controller.end) <= 0) {
      Duration diff = widget.controller.end.difference(widget.controller.begin);
      widget.controller.loadData().then((value) {
        if (appController.errorLog.isNotEmpty) {
          widget.controller.isLoading.value = false;
          showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Error'),
                content: Text(appController.errorLog),
              );
            },
          ).then((value) {
            widget.controller.isLoading.value = false;
          });
        } else {
          _setData();
          widget.controller.isLoading.value = false;
        }
      });
    } else {
      appController.reportData = [];
      _setData();
      showDialog(
        context: context,
        builder: (context) {
          return const CupertinoAlertDialog(
            title: Text('Error Time'),
            content: Text('Ngày bắt đầu phải nhỏ hơn ngày kết thúc '),
          );
        },
      );
    }
  }

  void _resetFilter() {
    setState(() {
      filter.forEach((key, value) {
        filter[key] = [];
      });
    });
  }

  void _setData() {
    getColumns();
    dataList.clear();
    dataList.addAll(widget.controller.listDataModel);
    _dataSource = CustomDataSource(
        isReport: true,
        modelType: widget.controller.typeModel,
        isEdit: widget.isEdit,
        callback: (value) {
          if (value == true) {
            _setData();
          } else {
            setState(() {});
          }
        },
        listAllModel: widget.controller.listDataModel,
        list: dataList,
        listColumn: column,
        context: context);
    for (String col in column) {
      if (widget.controller.typeModel.isFilter(col, true)) {
        allFilter[col] = _getAllValueByKey(col);
      }
    }
  }

  void getColumns() {
    for (String key in column) {
      columnWidths[key] = double.nan;
      filter[key] = [];
    }
  }

  void getKeysFromMap(Map map) {
    if (column.isEmpty) {
      // Get all keys
      for (var key in map.keys) {
        column.add(key);
        columnWidths[key] = double.nan;
        filter[key] = [];
      }
    } else {
      for (String key in column) {
        // column.add(key);
        columnWidths[key] = double.nan;
        filter[key] = [];
      }
    }
  }

  List<dynamic> _getAllValueByKey(String key) {
    List<dynamic> result = [];
    for (TemplateModel item in widget.controller.listDataModel) {
      if (!result.contains(item.getValue(key))) {
        result.add(item.getValue(key));
      }
    }
    return result;
  }

  void _getDataByFilter() {
    dataList.clear();
    dataList.addAll(widget.controller.listDataModel);
    for (String col in column) {
      if (filter[col].isNotEmpty) {
        dataList.value = dataList.where((element) => filter[col].contains(element.getValue(col))).toList();
      }
    }
    _dataSource = CustomDataSource(
        isReport: true,
        modelType: widget.controller.typeModel,
        isEdit: widget.isEdit,
        callback: (value) {
          if (value == true) {
            _setData();
          } else {
            setState(() {});
          }
        },
        listAllModel: widget.controller.listDataModel,
        list: dataList,
        listColumn: column,
        context: context);
  }

  void _searchGlobal() {
    List<TemplateModel> currentList = [];
    _getDataByFilter();
    currentList.addAll(dataList);
    if (search.isNotEmpty) {
      currentList = dataList.where((element) {
        bool flag = false;
        for (String col in column) {
          if ((element.getValue(col).toString().toLowerCase()).contains(search.toLowerCase())) {
            flag = true;
          }
        }
        return flag;
      }).toList();
    }
    dataList.clear();
    dataList.addAll(currentList);
    _dataSource = CustomDataSource(
        isReport: true,
        modelType: widget.controller.typeModel,
        isEdit: widget.isEdit,
        callback: (value) {
          if (value == true) {
            _setData();
          } else {
            setState(() {});
          }
        },
        listAllModel: widget.controller.listDataModel,
        search: search,
        list: dataList,
        listColumn: column,
        context: context);
  }

  Widget _buildSelectDate() {
    return ResponsiveGridRow(
      children: [
        ResponsiveGridCol(
            lg: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 2),
              child: MyInputDate(
                padding: EdgeInsets.zero,
                controller: widget.controller.beginController,
                date: widget.controller.begin,
                label: 'Ngày bắt đầu',
                functionCallBack: (param) {
                  widget.controller.begin = param;
                },
              ),
            )),
        ResponsiveGridCol(lg: 1, child: Container()),
        widget.controller.selectb2e
            ? ResponsiveGridCol(
                lg: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 2),
                  child: MyInputDate(
                    padding: EdgeInsets.zero,
                    controller: widget.controller.endController,
                    date: widget.controller.end,
                    label: 'Ngày kết thúc',
                    functionCallBack: (param) {
                      widget.controller.end = param;
                    },
                  ),
                ))
            : widget.controller.byShift
                ? ResponsiveGridCol(
                    lg: 2,
                    child: SelectionButtonCustom(
                      isReload: true,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      title: 'Ca',
                      hintext: 'Chọn ca',
                      data: const ['1', '2', '3'],
                      value: widget.controller.shift,
                      setItem: (param) {
                        setState(() {
                          widget.controller.shift = param;
                        });
                      },
                    ))
                : ResponsiveGridCol(lg: 1, child: Container()),
        ResponsiveGridCol(
            lg: 7,
            child: Row(
              children: [
                InkWell(
                  onTap: () => _loadData(),
                  child: Container(
                    width: 150,
                    height: 48,
                    margin: EdgeInsets.symmetric(
                        vertical: ThemeConfig.defaultPadding, horizontal: ThemeConfig.defaultPadding / 2),
                    decoration: BoxDecoration(
                        color: ThemeConfig.primaryColor,
                        borderRadius: BorderRadius.circular(ThemeConfig.borderRadius / 2)),
                    padding: EdgeInsets.all(ThemeConfig.defaultPadding / 2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 20,
                          color: ThemeConfig.whiteColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Áp dụng',
                          style: TextStyle(
                            color: ThemeConfig.whiteColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ButtonHeaderReport(
                  callback: (param) {
                    if (param != true) {
                      widget.isEdit = param['is_edit'];
                      setState(() {});
                    } else {
                      setState(() {});
                    }
                  },
                  controller: widget.controller,
                ),
              ],
            )),
      ],
    );
  }

  // end function
  Widget _buildTable(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 2),
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
              top: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
              bottom: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
              left: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)))),
      child: SfDataGrid(
        isScrollbarAlwaysShown: true,
        allowEditing: widget.isEdit,
        selectionMode: SelectionMode.single,
        navigationMode: GridNavigationMode.cell,
        editingGestureType: EditingGestureType.tap,
        key: widget.controller.keyGridView,
        showCheckboxColumn: false,
        // rowHeight: 40,
        onQueryRowHeight: (details) {
          return details.rowIndex == 0 ? 70 : widget.controller.rowHeight;
          // return details.getIntrinsicRowHeight(details.rowIndex);
        },
        frozenColumnsCount: widget.controller.template['col_span'] ?? 0,
        highlightRowOnHover: true,
        rowsPerPage: _rowsPerPage.value,
        checkboxColumnSettings: DataGridCheckboxColumnSettings(
          width: 100,
          label: _buildActionDropdown(),
        ),
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        tableSummaryRows: sumCol.isNotEmpty
            ? [
                GridTableSummaryRow(
                    color: ThemeConfig.greyColor.withOpacity(0.5),
                    showSummaryInRow: false,
                    titleColumnSpan: 3,
                    title: 'Tổng số dòng: {Count}',
                    columns: sumRow,
                    position: GridTableSummaryRowPosition.bottom),
              ]
            : [],
        controller: _dataGridController,
        source: _dataSource,
        footer: _dataSource.listModel.isEmpty
            ? Container(
                color: Colors.grey[400],
                child: Center(
                    child: Text(
                  'Không có dữ liệu',
                  style: ThemeConfig.defaultStyle.copyWith(fontWeight: FontWeight.bold),
                )))
            : null,
        columns: (widget.controller.template['fields'] as List).map((field) => _buildColumn(field)).toList(),
      ),
    );
  }

  GridColumn _buildColumn(Map<String, dynamic> field) {
    return field['field'] != 'action_button'
        ? GridColumn(
            allowEditing: field['is_edit'] ?? false,
            width: field['width'] ?? (Get.width - 2 * ThemeConfig.defaultPadding) / column.length,
            columnName: field['field'],
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          field['label'],
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeConfig.defaultStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: ThemeConfig.defaultSize,
                              color: ThemeConfig.textColor),
                        )),
                  ),
                  widget.controller.typeModel.isFilter(field['field'], true)
                      ? InkWell(
                          onTap: () => _showMyDialog(field),
                          child: Icon(
                            (filter[field['field']] as List).isNotEmpty
                                ? Icons.filter_list_alt
                                : Icons.filter_alt_outlined,
                            size: ThemeConfig.defaultSize,
                            color: ThemeConfig.blackColor,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ))
        : GridColumn(
            columnName: field['field'],
            width: 50,
            label: Container(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  '',
                  style: ThemeConfig.defaultStyle.copyWith(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                )));
  }

  // Widget _buildSum(){
  //   return (widget.controller.countRecord && sumCol.isEmpty)?Row(
  //     children: [
  //       SizedBox(width: (MediaQuery.of(context).size.width-103)/(column.isEmpty?1:column.length)*2),
  //       Text('${widget.controller.titleCount}: ',style: TextStyle(fontSize: ThemeConfig.smallSize,fontWeight: FontWeight.bold)),
  //       SizedBox(width: (MediaQuery.of(context).size.width-103)/(column.isEmpty?1:column.length)/2),
  //       Text('${dataList.length}',style: TextStyle(fontSize: ThemeConfig.smallSize,fontWeight: FontWeight.bold)),
  //     ],
  //   )
  //       :sumCol.isNotEmpty?Row(
  //     children:column.map((e){
  //       return sumCol.contains(e)?SizedBox(
  //         width: (MediaQuery.of(context).size.width-103)/(column.isEmpty?1:column.length),
  //         child:Text(appController.getMoneyFormat(_sumDataByKey(e)),style: TextStyle(fontSize: ThemeConfig.smallSize,fontWeight: FontWeight.bold),),
  //       ):SizedBox(width: (MediaQuery.of(context).size.width-103)/(column.isEmpty?1:column.length),
  //           child: Text(column.indexOf(e)==2?'Total:':'',style: TextStyle(fontSize: ThemeConfig.smallSize,fontWeight: FontWeight.bold),)
  //       );
  //     }).toList(),
  //   ):const SizedBox(height: 0,);
  // }

  // int _sumDataByKey(col){
  //   return dataList.fold<int>(0, (sum, item) => sum + item.getValue(col) as int);
  // }

  @override
  Widget build(BuildContext context) {
    _searchGlobal();
    return Obx(() => Column(
          children: [
            _buildSelectDate(),
            SearchListView(callback: (value) {
              setState(() {
                search = value;
              });
            }),
            widget.controller.isLoading.value ? const LoadingScreen() : Expanded(child: _buildTable(context)),
            _buildPaging()
          ],
        ));
  }

  Widget _buildPaging() {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(
        itemColor: ThemeConfig.whiteColor,
        selectedItemColor: ThemeConfig.primaryColor,
        itemBorderRadius: BorderRadius.circular(5),
        backgroundColor: ThemeConfig.whiteColor,
      ),
      child: SfDataPager(
        visibleItemsCount: _rowsPerPage.value,
        delegate: _dataSource,
        availableRowsPerPage: appController.listConfigPage,
        onRowsPerPageChanged: (int? rowsPerPage) {
          setState(() {
            _rowsPerPage.value = rowsPerPage!;
            _dataSource.updateDataGriDataSource();
          });
        },
        pageCount: (dataList.length / _rowsPerPage.value).ceil().toDouble() == 0
            ? 1
            : (dataList.length / _rowsPerPage.value).ceil().toDouble(),
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _buildActionDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: PopupMenuButton<int>(
        icon: Icon(
          Icons.more_horiz_outlined,
          color: ThemeConfig.whiteColor,
          size: 20,
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                const Icon(
                  Icons.delete_outline,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Delete',
                  style: ThemeConfig.defaultStyle.copyWith(
                    color: ThemeConfig.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
        onSelected: (value) async {
          if (value == 1) {
            showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('Delete ${widget.controller.typeModel.getValue('name')}'),
                  content: Text('Do you want to delete ${widget.controller.typeModel.getValue('name')}'),
                  actions: [
                    CupertinoDialogAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                          for (DataGridRow element in _dataGridController.selectedRows) {
                            (element as CustomDataGridRow).model.delete().then((value) {
                              if (value) {
                                widget.controller.listDataModel.remove(element.model);
                              }
                            });
                          }
                        },
                        child: const Text('Delete')),
                    CupertinoDialogAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'))
                  ],
                );
              },
            ).then((value) {
              widget.controller.listDataModel.refresh();
              _setData();
            });
          }
        },
      ),
    );
  }

  Future<void> _showMyDialog(Map<String, dynamic> field) async {
    // bool selectAll = false;
    List? currentFilter = allFilter[field['field']];

    TextEditingController search = TextEditingController();
    search.addListener(() {
      if (search.text.isNotEmpty) {
        setState(() {
          currentFilter = allFilter[field['field']]
              ?.where((element) => (element.toString().toLowerCase()).contains(search.text.toLowerCase()))
              .toList();
        });
      } else {
        setState(() {
          currentFilter = allFilter[field['field']];
        });
      }
    });
    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(field['label']),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              currentFilter = allFilter[field['field']]
                                  ?.where((element) => (element.toString().toLowerCase()).contains(value.toLowerCase()))
                                  .toList();
                            });
                          } else {
                            setState(() {
                              currentFilter = allFilter[field['field']];
                            });
                          }
                        },
                        style: TextStyle(fontSize: ThemeConfig.defaultSize),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: ThemeConfig.contentPadding,
                          counter: const SizedBox(),
                          hintText: 'Tìm kiếm',
                          hintStyle: TextStyle(color: ThemeConfig.greyColor, fontSize: ThemeConfig.smallSize),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.redAccent)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: ThemeConfig.greyColor)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if ((filter[field['field']] as List).length != currentFilter?.length) {
                              filter[field['field']].clear();
                              filter[field['field']].addAll(currentFilter);
                            } else {
                              filter[field['field']] = [];
                            }
                          });
                        },
                        child: ListTile(
                          leading: Checkbox(
                            value: (filter[field['field']] as List).length == currentFilter?.length,
                            onChanged: (bool? value) {
                              setState(() {
                                // selectAll = value!;
                                if (value!) {
                                  filter[field['field']].clear();
                                  filter[field['field']].addAll(currentFilter);
                                } else {
                                  filter[field['field']] = [];
                                }
                              });
                            },
                          ),
                          title: const Text('Chọn tất cả'),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: ThemeConfig.greyColor,
                      ),
                      ListBody(
                          children: currentFilter!.map((e) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if ((filter[field['field']] as List).contains(e)) {
                                    (filter[field['field']] as List).remove(e);
                                  } else {
                                    (filter[field['field']] as List).add(e);
                                  }
                                });
                              },
                              child: ListTile(
                                leading: Checkbox(
                                  value: (filter[field['field']] as List).contains(e),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value!) {
                                        (filter[field['field']] as List).add(e);
                                      } else {
                                        // selectAll = false;
                                        (filter[field['field']] as List).remove(e);
                                      }
                                    });
                                  },
                                ),
                                title: Text((e.toString() == '' || e == null) ? '(Blank)' : e.toString()),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: ThemeConfig.greyColor,
                            )
                          ],
                        );
                      }).toList())
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Áp dụng'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
