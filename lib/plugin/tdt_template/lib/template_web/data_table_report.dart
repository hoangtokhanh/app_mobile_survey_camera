import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment, Row, Border;
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:tdt_template/template_web/widget/loading_screen.dart';
export 'package:syncfusion_flutter_datagrid/datagrid.dart';
export 'package:syncfusion_flutter_core/theme.dart';
import '../../../config/app_config.dart';
import '../../../config/theme_config.dart';
import '../../../controller/app_controller.dart';
import '../../../model/template/template_model.dart';
import '../controller/controller.dart';
import 'widget/custom_scaffold.dart';
import 'widget/my_input_date.dart';

List<Map<String, dynamic>> _paginatedData = [];
final TextEditingController searchController = TextEditingController();

class DataTableReport extends StatefulWidget {
  final MenuCallback callback;
  List<Map<String, dynamic>> data = [];
  String title = '';
  int mapColumnName = 1;
  double rowHeigh;
  String url = '';
  List<String> indexColumn;
  List<String>? sumCol;
  bool changeDate = true;
  final String titleCount;
  bool fixTable = true;
  String exportTitle;
  bool countRecord;
  bool selectb2e;
  final TemplateModel typeModel;

  DataTableReport(
      {Key? key,
      required this.typeModel,
      required this.callback,
      this.selectb2e = true,
      this.exportTitle = '',
      this.rowHeigh = 50,
      this.titleCount = '',
      required this.countRecord,
      this.sumCol,
      required this.indexColumn,
      this.mapColumnName = 1,
      this.fixTable = true,
      this.changeDate = true,
      required this.title,
      required this.url})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataTableReportState();
}

class _DataTableReportState extends State<DataTableReport> {
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  TextEditingController beginController = TextEditingController();
  TextEditingController endController = TextEditingController();
  DateTime begin = DateTime.now();
  DateTime end = DateTime.now();
  List<String> sumCol = [];
  int _rowsPerPage = 10;
  final filter = {};
  List<Map<String, dynamic>> dataList = [];
  late DataSource _dataSource;
  List<String> column = [];
  final Map<String, List> allFilter = {};
  late Map<String, double> columnWidths = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rowsPerPage = 10;
    sumCol = widget.sumCol ?? sumCol;
    column.addAll(widget.indexColumn);
    beginController.text = DateFormat(AppConfig.DATE_USER_FOMAT).format(begin);
    endController.text = DateFormat(AppConfig.DATE_USER_FOMAT).format(end);
    _loadData();
    getColumns();
    dataList = widget.data.isEmpty ? [] : widget.data;
    _dataSource = DataSource(
        dataAll: dataList,
        column: column,
        mapColumnName: widget.mapColumnName,
        callback: (image) => widget.callback(image));
    for (String col in column) {
      if (UtilFunction.isFilter(col)) {
        allFilter[col] = _getAllValueByKey(col);
      }
    }
  }

  Future<void> _exportExcel() async {
    final Workbook workbook = key.currentState!.exportToExcelWorkbook();
    final Style globalStyle = workbook.styles.add('globalStyle');
    globalStyle.fontName = 'Times New Roman';
    final Worksheet sheet = workbook.worksheets[0];
    sheet.insertRow(1, 1, ExcelInsertOptions.formatAsAfter);
    sheet.insertRow(1, 1, ExcelInsertOptions.formatAsAfter);
    sheet.getRangeByName('B1:H1').merge();
    sheet.getRangeByName('B1:H1').cellStyle.hAlign = HAlignType.left;
    sheet.getRangeByName('B1:H1').cellStyle.bold = true;
    sheet.getRangeByName('B1').setText(widget.exportTitle.toUpperCase());
    sheet.getRangeByName('A3:Z3').cellStyle.bold = true;
    //
    if (widget.changeDate) {
      sheet.getRangeByName('B2:C2').merge();
      sheet.getRangeByName('B2:C2').cellStyle.hAlign = HAlignType.left;
      sheet
          .getRangeByName('B2')
          .setText(widget.selectb2e ? 'Từ ngày: ${beginController.text}' : 'Ngày: ${beginController.text}');
      //
      if (widget.selectb2e) {
        sheet.getRangeByName('D2:E2').merge();
        sheet.getRangeByName('D2:E2').cellStyle.hAlign = HAlignType.left;
        sheet.getRangeByName('D2').setText('Đến ngày: ${endController.text}');
      }
    }
    int rowNext = sheet.getLastRow() + 1;
    int colIndex = 0;
    int colIndexmin = 100;
    int rowLast = rowNext + 1;
    if (sumCol.isNotEmpty) {
      for (String col in sumCol) {
        colIndex = column.indexOf(col);
        if (colIndexmin > colIndex) {
          colIndexmin = colIndex;
        }
        sheet
            .getRangeByIndex(rowNext, colIndex + 1)
            .setText(appController.getMoneyFormat(_sumDataByKey(UtilFunction.getColumn(col)).toString()));
        sheet.getRangeByIndex(rowNext, colIndex + 1).cellStyle.bold = true;
      }
      sheet.getRangeByIndex(rowNext, 1, rowNext, colIndexmin).merge();
      sheet.getRangeByIndex(rowNext, 1, rowNext, colIndexmin).cellStyle.bold = true;
      sheet.getRangeByIndex(rowNext, 1, rowNext, colIndexmin).cellStyle.hAlign = HAlignType.center;
      sheet.getRangeByIndex(rowNext, 1, rowNext, colIndexmin).setText('Tổng cộng:');
    }
    if (widget.countRecord) {
      if (sumCol.isEmpty) {
        sheet.getRangeByName('B$rowNext:C$rowNext').merge();
        sheet.getRangeByName('B$rowNext:C$rowNext').cellStyle.bold = true;
        sheet.getRangeByName('B$rowNext').setText('${widget.titleCount}:');
        //
        sheet.getRangeByName('D$rowNext').cellStyle.bold = true;
        sheet.getRangeByName('D$rowNext').setText('${dataList.length}');
      } else {
        sheet.getRangeByIndex(rowLast, 1, rowLast, colIndexmin).merge();
        sheet.getRangeByIndex(rowLast, 1, rowLast, colIndexmin).cellStyle.bold = true;
        sheet.getRangeByIndex(rowLast, 1, rowLast, colIndexmin).cellStyle.hAlign = HAlignType.center;
        sheet.getRangeByIndex(rowLast, 1, rowLast, colIndexmin).setText('${widget.titleCount}: ${dataList.length}');
        //
        // sheet.getRangeByIndex(rowLast,colIndexmin+1).cellStyle.bold = true;
        // sheet.getRangeByIndex(rowLast,colIndexmin+1).cellStyle.hAlign = HAlignType.center;
        // sheet.getRangeByIndex(rowLast,colIndexmin+1).setText('${dataList.length}');
      }
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

  void _setData() {
    setState(() {
      widget.data = appController.reportData;
      // if(column.isEmpty) {
      getColumns();
      // }
      dataList = widget.data.isEmpty ? [] : widget.data;
      _dataSource = DataSource(
          dataAll: appController.reportData,
          column: column,
          mapColumnName: widget.mapColumnName,
          callback: (image) => widget.callback(image));
      for (String col in column) {
        if (UtilFunction.isFilter(col)) {
          allFilter[col] = _getAllValueByKey(col);
        }
      }
    });
  }

  void _loadData() async {
    _resetFilter();
    if (end.difference(begin).inDays >= 0) {
      setState(() {
        // appController.isLoading.value = true;
      });
      // api.getRawData(
      //      begin: DateFormat(AppConfig.DATE_DB).format(begin),
      //      end: DateFormat(AppConfig.DATE_DB).format(end)).then((value){
      //        if(value) {
      //          _setData();
      //          setState(() {
      //         appController.isLoading.value = false;
      //       });
      //        }else{
      //          showDialog(
      //            context: context,
      //            builder: (context) {
      //              return CupertinoAlertDialog(
      //                title: const Text('Error'),
      //                content: Text(appController.errorLog),
      //              );
      //            },
      //          );
      //        }
      // });

    } else {
      appController.reportData = [];
      _setData();
      showDialog(
        context: context,
        builder: (context) {
          return const CupertinoAlertDialog(
            title: Text('Error Time'),
            content: Text('Start date must be less than end date '),
          );
        },
      );
    }
  }

  void getColumns() {
    if (widget.data.isNotEmpty) {
      getKeysFromMap(widget.data[0]);
    } else {
      for (String key in column) {
        // column.add(key);
        columnWidths[key] = double.nan;
        filter[key] = [];
      }
    }
  }

  void getKeysFromMap(Map map) {
    if (column.isEmpty) {
      // Get all keys
      map.keys.forEach((key) {
        column.add(key);
        columnWidths[key] = double.nan;
        filter[key] = [];
      });
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
    for (Map item in widget.data) {
      if (!result.contains(item[key])) {
        result.add(item[key]);
      }
    }
    return result;
  }

  void _searchGlobal(String value) {
    List<Map<String, dynamic>> currentList = [];
    _getDataByFilter();
    currentList = dataList;
    setState(() {
      if (value.isNotEmpty) {
        currentList = dataList.where((element) {
          bool flag = false;
          for (String col in column) {
            if ((element[col].toString().toLowerCase()).contains(value.toLowerCase())) {
              flag = true;
            }
          }
          return flag;
        }).toList();
      }
      dataList = currentList;
      _dataSource = DataSource(
          dataAll: currentList,
          column: column,
          mapColumnName: widget.mapColumnName,
          callback: (image) => widget.callback(image));
    });
  }

  void _resetFilter() {
    setState(() {
      filter.forEach((key, value) {
        filter[key] = [];
      });
    });
  }

  void _getDataByFilter() {
    setState(() {
      dataList = widget.data.isEmpty ? [] : widget.data;
      for (String col in column) {
        if (filter[col].isNotEmpty) {
          dataList = dataList.where((element) => filter[col].contains(element[col])).toList();
        }
      }
      _dataSource = DataSource(
          dataAll: dataList,
          column: column,
          mapColumnName: widget.mapColumnName,
          callback: (image) => widget.callback(image));
    });
  }

  int _sumDataByKey(col) {
    return dataList.fold<int>(0, (sum, item) => sum + int.parse(item[col] ?? '0'));
  }

  double _getHeightTable() {
    double height = 620;
    if (height.isNaN) {
      return 100;
    }
    return height;
  }

  Widget _buildPop() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          appController.reportData = [];
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          size: ThemeConfig.titleSize,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSelectDate() {
    return widget.changeDate
        ? Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                    lg: 3,
                    child: MyInputDate(
                      padding: EdgeInsets.zero,
                      controller: beginController,
                      date: begin,
                      label: widget.selectb2e ? 'Start date' : 'Date',
                      functionCallBack: (param) {
                        setState(() {
                          begin = param;
                          _loadData();
                        });
                      },
                    )),
                ResponsiveGridCol(lg: 1, child: Container()),
                widget.selectb2e
                    ? ResponsiveGridCol(
                        lg: 3,
                        child: MyInputDate(
                          padding: EdgeInsets.zero,
                          controller: endController,
                          date: end,
                          label: 'End date',
                          functionCallBack: (param) {
                            setState(() {
                              end = param;
                              _loadData();
                            });
                          },
                        ))
                    : ResponsiveGridCol(lg: 1, child: Container()),
              ],
            ),
          )
        : Container();
  }

  Widget _buildSearch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                _searchGlobal(value);
              });
            },
            style: TextStyle(fontSize: ThemeConfig.defaultSize),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              contentPadding: ThemeConfig.contentPadding,
              counter: Container(),
              hintText: 'Search...',
              hintStyle: TextStyle(color: ThemeConfig.greyColor, fontSize: ThemeConfig.smallSize),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.redAccent)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: ThemeConfig.greyColor)),
            ),
          ),
        ),
        // const SizedBox(width: 20,),
        // InkWell(onTap: _exportExcel, child: Container(
        //     padding: const EdgeInsets.all(11),
        //     decoration: BoxDecoration(
        //         border: Border.all(color: ThemeConfig.greyColor),
        //         borderRadius: BorderRadius.circular(5)
        //     ),
        //     child: const Icon(Icons.download_outlined))),
      ],
    );
  }

  Widget _buildGrid() {
    return Container(
      height: _getHeightTable(),
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
              top: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
              bottom: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
              left: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)))),
      child: SfDataGrid(
        key: key,
        controller: appController.dataGridController,
        allowSorting: true,
        allowMultiColumnSorting: true,
        allowTriStateSorting: true,
        rowsPerPage: _rowsPerPage,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columnWidthMode: widget.fixTable ? ColumnWidthMode.fill : ColumnWidthMode.lastColumnFill,
        allowColumnsResizing: true,
        source: _dataSource,
        onQueryRowHeight: (details) {
          return details.rowIndex == 0 ? 70 : widget.rowHeigh;
          // return details.getIntrinsicRowHeight(details.rowIndex);
        },
        onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
          setState(() {
            columnWidths[details.column.columnName] = details.width;
          });
          return true;
        },
        footer: _dataSource._data.isEmpty
            ? Container(
                color: Colors.grey[400],
                child: const Center(
                    child: Text(
                  'No data',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )))
            : (sumCol.isEmpty && !widget.countRecord)
                ? null
                : _buildSum(),
        columns: column.map((e) {
          return _buildColumn(e);
        }).toList(),
      ),
    );
  }

  Widget _buildSum() {
    return (widget.countRecord && sumCol.isEmpty)
        ? Row(
            children: [
              SizedBox(width: (MediaQuery.of(context).size.width - 103) / (column.isEmpty ? 1 : column.length) * 2),
              Text('${widget.titleCount}: ',
                  style: TextStyle(fontSize: ThemeConfig.smallSize, fontWeight: FontWeight.bold)),
              SizedBox(width: (MediaQuery.of(context).size.width - 103) / (column.isEmpty ? 1 : column.length) / 2),
              Text('${dataList.length}',
                  style: TextStyle(fontSize: ThemeConfig.smallSize, fontWeight: FontWeight.bold)),
            ],
          )
        : sumCol.isNotEmpty
            ? Row(
                children: column.map((e) {
                  return sumCol.contains(e)
                      ? SizedBox(
                          width: (MediaQuery.of(context).size.width - 103) / (column.isEmpty ? 1 : column.length),
                          child: Text(
                            appController.getMoneyFormat(_sumDataByKey(UtilFunction.getColumn(e)).toString()),
                            style: TextStyle(fontSize: ThemeConfig.smallSize, fontWeight: FontWeight.bold),
                          ),
                        )
                      : SizedBox(
                          width: (MediaQuery.of(context).size.width - 103) / (column.isEmpty ? 1 : column.length),
                          child: Text(
                            column.indexOf(e) == 2 ? 'Total:' : '',
                            style: TextStyle(fontSize: ThemeConfig.smallSize, fontWeight: FontWeight.bold),
                          ));
                }).toList(),
              )
            : const SizedBox(
                height: 0,
              );
  }

  GridColumn _buildColumn(String e) {
    return GridColumn(
        // minimumWidth: 100,
        width: columnWidths[e] ?? 200,
        columnName: UtilFunction.getColName(e, widget.mapColumnName),
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      UtilFunction.getColName(e, widget.mapColumnName),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: ThemeConfig.smallSize, color: ThemeConfig.textColor),
                    )),
              ),
              UtilFunction.isFilter(e)
                  ? InkWell(
                      onTap: () => _showMyDialog(e),
                      child: Icon(
                        (filter[e] as List).isNotEmpty ? Icons.filter_list_alt : Icons.filter_alt_outlined,
                        size: ThemeConfig.defaultSize,
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }

  Widget _buildPaging() {
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(
        itemColor: Colors.white,
        selectedItemColor: Colors.lightGreen,
        itemBorderRadius: BorderRadius.circular(5),
        backgroundColor: Colors.teal,
      ),
      child: SfDataPager(
        visibleItemsCount: 10,
        delegate: _dataSource,
        availableRowsPerPage: const [10, 20, 30, 50],
        onRowsPerPageChanged: (int? rowsPerPage) {
          setState(() {
            _rowsPerPage = rowsPerPage!;
            _dataSource.updateDataGriDataSource();
          });
        },
        pageCount: (dataList.length / _rowsPerPage).ceil().toDouble() == 0
            ? 1
            : (dataList.length / _rowsPerPage).ceil().toDouble(),
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _buildMain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildPop(),
        _buildTitle(),
        _buildSelectDate(),
        _buildSearch(),
        Expanded(child: _buildDataTable())
      ],
    );
  }

  Widget _buildDataTable() {
    return appController.isLoading.value
        ? const LoadingScreen()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildGrid(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text('Total ${dataList.length} record'),
              ),
              _buildPaging()
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(body: _buildMain());
  }

  Future<void> _showMyDialog(String col) async {
    bool selectAll = false;
    List? curentFilter = allFilter[col];

    TextEditingController search = TextEditingController();
    search.addListener(() {
      if (search.text.isNotEmpty) {
        setState(() {
          curentFilter = allFilter[col]
              ?.where((element) => (element.toString().toLowerCase()).contains(search.text.toLowerCase()))
              .toList();
        });
      } else {
        setState(() {
          curentFilter = allFilter[col];
        });
      }
    });
    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(UtilFunction.getColName(col, widget.mapColumnName)),
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
                              curentFilter = allFilter[col]
                                  ?.where((element) => (element.toString().toLowerCase()).contains(value.toLowerCase()))
                                  .toList();
                            });
                          } else {
                            setState(() {
                              curentFilter = allFilter[col];
                            });
                          }
                        },
                        style: TextStyle(fontSize: ThemeConfig.defaultSize),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: ThemeConfig.contentPadding,
                          counter: Container(),
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
                            if ((filter[col] as List).length != curentFilter?.length) {
                              filter[col] = curentFilter;
                            } else {
                              filter[col] = [];
                            }
                          });
                        },
                        child: ListTile(
                          leading: Checkbox(
                            value: (filter[col] as List).length == curentFilter?.length,
                            onChanged: (bool? value) {
                              setState(() {
                                selectAll = value!;
                                if (value) {
                                  filter[col] = curentFilter;
                                } else {
                                  filter[col] = [];
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
                          children: curentFilter!.map((e) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if ((filter[col] as List).contains(e)) {
                                    (filter[col] as List).remove(e);
                                  } else {
                                    (filter[col] as List).add(e);
                                  }
                                });
                              },
                              child: ListTile(
                                leading: Checkbox(
                                  value: (filter[col] as List).contains(e),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value!) {
                                        (filter[col] as List).add(e);
                                      } else {
                                        selectAll = false;
                                        (filter[col] as List).remove(e);
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
                _getDataByFilter();
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

class DataSource extends DataGridSource {
  DataSource(
      {required this.callback,
      required List<Map<String, dynamic>> dataAll,
      required this.column,
      required this.mapColumnName}) {
    _data = dataAll;
    _paginatedData = dataAll;
    // _paginatedData = dataAll.getRange(0, dataAll.length<19?dataAll.length:19).toList(growable: false);
    buildPaginatedDataGridRows();
    // _data = data
    //     .map<DataGridRow>((e) => DataGridRow(
    //   cells: column.map((_column) {
    //     return DataGridCell(columnName: _column, value: e[_column].toString());
    //   }).toList()
    // )).toList();
  }

  int mapColumnName = 1;
  List<String> column;
  List<DataGridRow> _dataGridRow = [];
  List<Map<String, dynamic>> _data = [];
  final MenuCallback callback;

  @override
  List<DataGridRow> get rows => _dataGridRow;

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      Color getColor() {
        if (searchController.text.isNotEmpty &&
            dataGridCell.value.toString().toLowerCase().contains(searchController.text.toLowerCase())) {
          return Colors.blue[200]!;
        } else {
          return _dataGridRow.indexOf(row) % 2 == 0 ? ThemeConfig.whiteColor : ThemeConfig.background2;
        }
      }

      return Container(
        decoration: BoxDecoration(color: getColor()),
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
        child: dataGridCell.columnName != 'Image'
            ? SelectableText(
                dataGridCell.value.toString(),
                maxLines: 10,
                style: TextStyle(fontSize: ThemeConfig.smallSize, color: ThemeConfig.textColor),
              )
            : InkWell(
                onTap: () => callback(dataGridCell.value.toString()),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/gif/loading.gif',
                  image: dataGridCell.value.toString(),
                ),
              ),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    appController.dataGridController.scrollToVerticalOffset(0);
    return super.handlePageChange(oldPageIndex, newPageIndex);
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    //check number
    final String? value1 = a?.getCells().firstWhereOrNull((element) => element.columnName == sortColumn.name)?.value;
    final String? value2 = b?.getCells().firstWhereOrNull((element) => element.columnName == sortColumn.name)?.value;

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

  void buildPaginatedDataGridRows() {
    appController.dataGridController.scrollToVerticalOffset(0);
    _dataGridRow = _paginatedData
        .map<DataGridRow>((e) => DataGridRow(
                cells: column.map((_column) {
              return DataGridCell(
                  columnName: UtilFunction.getColName(_column, mapColumnName),
                  value: _getValueDisplay(_column, e[UtilFunction.getColumn(_column)]));
            }).toList()))
        .toList(growable: false);
  }

  List<DataGridRow> buildAllDataGridRows() {
    return _data
        .map<DataGridRow>((e) => DataGridRow(
                cells: column.map((_column) {
              return DataGridCell(
                  columnName: UtilFunction.getColName(_column, mapColumnName), value: e[_column].toString());
            }).toList()))
        .toList(growable: false);
  }

  void updateDataGriDataSource() {
    notifyListeners();
  }

  String _getValueDisplay(String col, value) {
    if (col == 'ngay') {
      return value.toString().replaceAll('-', '/');
    } else {
      if (['soluong', 'trongluong', 'khoiluong', 'khoiluong_pref'].contains(col)) {
        return appController.getMoneyFormat(value);
      } else if (col == 'image1') {
        return '${AppConfig.ASSET_URL}${value.toString()}';
      }
    }
    return value ?? '';
  }
}

class UtilFunction {
  static String getColumn(String col) {
    return col == 'khoiluong_pref' ? 'soluong' : col;
  }

  static const mapColumnName = {
    'camera': 'Camera',
    'area': 'Area',
    'node': 'Node',
    'image1': 'Image',
    'type': 'Type',
    'time': 'Time'
  };
  static const mapColumnName2 = {
    'name': 'Lô',
    'type': 'Tên sản phẩm',
    'number': 'Số lượng',
    'loaisanpham': 'Loại sản phẩm trước điều chuyển',
  };

  static const mapColumnName3 = {'name': 'Kho', 'product': 'Tên sản phẩm', 'number': 'Số lượng'};
  static const mapColumnName4 = {
    'khoiluong': 'Khối lượng\nquy đổi',
    'trongluong': 'Khối lượng\nđã trừ bì',
    'saiso': 'Khối lượng\nchênh lệch',
    'kho': 'Kho lấy hàng\nthực tế',
    'DVVT': 'ĐVVT',
    'soxe': 'Số xe',
    'soromooc': 'Số Romooc',
    'loaihang': 'Loại hàng'
  };
  static const columnNotFilter = [
    'id',
    'code',
    'index',
    'des',
    'soluong',
    'khoiluong',
    'number',
    'saiso',
    'trongluong',
    'khoiluong_pref',
    'time',
    'image1'
  ];
  static const columnNotSort = ['Image', 'image', 'link'];

  static String getColName(col, [int type = 1]) {
    if (type == 1) {
      return mapColumnName[col] ?? col;
    } else if (type == 2) {
      return mapColumnName2[col] ?? mapColumnName[col] ?? col;
    } else if (type == 3) {
      return mapColumnName3[col] ?? mapColumnName[col] ?? col;
    } else {
      return mapColumnName4[col] ?? mapColumnName[col] ?? col;
    }
  }

  static bool isFilter(col) => !columnNotFilter.contains(col);
}
