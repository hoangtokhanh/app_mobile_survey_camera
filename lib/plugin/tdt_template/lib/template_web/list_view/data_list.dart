import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdt_template/controller/controller.dart';
import '../../../../config/theme_config.dart';
import '../../../../controller/app_controller.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/reload_controller.dart';
import '../../model/reload_controller_model.dart';
import '../data_table_report.dart';
import 'custom_datasource.dart';

class MyDaTaList extends StatefulWidget{
  const MyDaTaList({Key? key, required this.keyGridView,required this.listDataModel,required this.template,required this.typeModel, required this.height,this.rowHeight, this.reloadControllerStream, this.select = SelectionMode.none, this.callback}) : super(key: key);
  final RxList<TemplateModel> listDataModel;
  final TemplateModel typeModel;
  final GlobalKey<SfDataGridState> keyGridView;
  final Map<dynamic,dynamic> template;
  final double height;
  final double ?rowHeight;
  final ReloadControllerStream ?reloadControllerStream;
  final SelectionMode select;
  final MenuCallback ?callback;
  @override
  State<MyDaTaList> createState() => _MyDaTaListState();
}

class _MyDaTaListState extends State<MyDaTaList> {
  late final DataGridController _dataGridController ;
  late CustomDataSourceList _dataSource;
  late Map<String, double> columnWidths = {};
  final RxInt _rowsPerPage = appController.listConfigPage.first.obs;
  final RxBool isShow = false.obs;
  @override
  void initState() {
    _dataGridController =  DataGridController();
    _setData(widget.listDataModel);
    widget.reloadControllerStream!.rebuildStream.listen((event) {
      if((event as ReloadControllerModel).type == TypeReLoad.refresh) {
        _dataSource.listModel.clear();
        _dataSource.listModel.addAll((event).data);
        Future.delayed(Duration.zero).then((value){
          _dataSource.updateDataGriDataSource();
        }).then((value) =>  Future.delayed(Duration.zero).then((value){
          if(mounted) {
            setState(() {});
          }
        }));
      }else{
        _setData(event.data);
        if(mounted) {
          setState(() {});
        }
      }
    });
    super.initState();
  }
  void _setData(List<TemplateModel> list){
    _dataSource = CustomDataSourceList(
      modelType: widget.typeModel,
      listModel: list,
      template: widget.template,
      perPage: _rowsPerPage.value
    );
  }

  Widget _buildTable(context) {
    return  SizedBox(
      height: getHeight(),
      child: SfDataGrid(
        onQueryRowHeight: (details) {
          if(widget.rowHeight == null) {
            return details.getIntrinsicRowHeight(details.rowIndex);
          }else{
            return details.rowIndex == 0 ? 50 : widget.rowHeight!;
          }
        },
        frozenRowsCount: 0,
        allowFiltering: true,
        key: widget.keyGridView,
        allowSorting: widget.template['allow_sort']??false,
        allowTriStateSorting: true,
        showCheckboxColumn: widget.template['show_checkbox']??false,
        rowHeight: widget.template['row_height']??double.nan,
        highlightRowOnHover: true,
        rowsPerPage: _rowsPerPage.value,
        // checkboxColumnSettings: DataGridCheckboxColumnSettings(
        //   width: 100,
        //   label: _buildActionDropdown(),
        // ),
        onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows){
          // print(_dataGridController.selectedRows.length);
          widget.callback!(_dataGridController.selectedRows.map((e) => (e as CustomDataGridRow).model).toList());
        },
        navigationMode: GridNavigationMode.cell,
        selectionMode: widget.select,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columnWidthMode: ColumnWidthMode.fill,
        controller: _dataGridController,
        source: _dataSource,
        footer: _dataSource.listModel.isEmpty?Container(
          decoration: BoxDecoration(
            color: ThemeConfig.whiteColor.withOpacity(0.2),
            border: Border.all(color: Colors.grey.withOpacity(0.5))
          ),
            child: Center(
                child: Text(
                  'No data',
                  style: ThemeConfig.defaultStyle.copyWith(fontWeight: FontWeight.bold,color: ThemeConfig.textColor),
                ))):null,
        columns: (widget.template['fields'] as List).map((field) => _buildColumn(field)).toList(),
      ),
    );
  }
  GridColumn _buildColumn(Map<String,dynamic> field){
    return field['field'] != 'action_button'?field['width'] == null?GridColumn(
      allowFiltering: widget.typeModel.isFilter(field['field']),
        allowSorting: widget.typeModel.isSort(field['field']),
        columnName: field['field'],
        minimumWidth: 150,
        label: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding/2),
          child: Row(
            children: [
              Expanded(child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (field['label'] as String),
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeConfig.smallStyle.copyWith(
                        fontSize: ThemeConfig.smallSize,
                        color: ThemeConfig.textColor,
                      fontWeight: FontWeight.bold
                    ),
                  )
              )),
            ],
          ),
        )
    ):GridColumn(
      allowFiltering: widget.typeModel.isFilter(field['field']),
        allowSorting: widget.typeModel.isSort(field['field']),
        columnName: field['field'],
        minimumWidth: 150,
        width: field['width'],
        label: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding/2),
          child: Row(
            children: [
              Expanded(child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (field['label'] as String),
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeConfig.smallStyle.copyWith(
                        fontSize: ThemeConfig.smallSize,
                        color: ThemeConfig.textColor,
                        fontWeight: FontWeight.bold
                    ),
                  )
              )),
            ],
          ),
        )
    ):GridColumn(
      allowFiltering: false,
        allowSorting: false,
        columnName: field['field'],
        minimumWidth: 150,
        width: field['width']??150,
        label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12.0),
            child:Text(
              (field['label'] as String).toUpperCase(),
              style: ThemeConfig.defaultStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ThemeConfig.smallSize,
                  color: ThemeConfig.textColor,
              ),
            )));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfDataGridTheme(
            data: SfDataGridThemeData(
                selectionColor: ThemeConfig.thirdColor.withOpacity(0.6),
                rowHoverColor: ThemeConfig.whiteColor.withOpacity(0.2),
                headerHoverColor: Colors.transparent,
                brightness: Brightness.light,
                headerColor: Colors.transparent),
            child: _buildTable(context)),
        _dataSource.listModel.isNotEmpty?_buildPaging():const SizedBox()
        // _dataSource.listModel.length > _rowsPerPage.value?_buildPaging():const SizedBox(),
      ],
    );
  }
  Widget _buildPaging(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: SfDataPagerTheme(
        data: SfDataPagerThemeData(
          itemColor: ThemeConfig.whiteColor,
          selectedItemColor: ThemeConfig.primaryColor,
          itemBorderRadius: BorderRadius.circular(5),
          backgroundColor: ThemeConfig.whiteColor,
        ),
        child:SfDataPager(
          visibleItemsCount: _rowsPerPage.value,
          delegate: _dataSource,
          availableRowsPerPage: appController.listConfigPage,
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _rowsPerPage.value = rowsPerPage!;
              _dataSource.rowPerpage = _rowsPerPage.value;
              _dataSource.updateDataGriDataSource();
            });
          },
          pageCount: (_dataSource.listModel.length / _rowsPerPage.value).ceil().toDouble()==0?1:(_dataSource.listModel.length / _rowsPerPage.value).ceil().toDouble(),
          direction: Axis.horizontal,
        ),
      ),
    );
  }

  double getHeight(){
    if(_dataSource.listModel.length > _rowsPerPage.value){
      return widget.height - 60;
    }
    return widget.height - 60;
  }
}