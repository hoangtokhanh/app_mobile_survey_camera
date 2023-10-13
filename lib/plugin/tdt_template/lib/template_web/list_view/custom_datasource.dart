import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../config/theme_config.dart';
import '../../../../model/template/template_model.dart';
import '../data_table_report.dart';
import '../fields/field.dart';
class CustomDataSourceList extends DataGridSource {
  final TemplateModel modelType;
  final List<TemplateModel> listModel;
  final Map template;
  CustomDataSourceList({required this.listModel, required this.modelType,required this.template,required int perPage}) {
    rowPerpage = perPage;
    _paginated = listModel.getRange(0, rowPerpage>listModel.length?listModel.length:rowPerpage).toList(growable: false);
    buildPaginatedDataGridRows();
  }
  List<CustomDataGridRow> _dataGridRow = [];
  late int rowPerpage;
  void buildPaginatedDataGridRows() {
    _dataGridRow = _paginated
        .map((model) => CustomDataGridRow(model: model,cells: getColumn()
        .map((e) =>  DataGridCell(columnName:e , value: model.getValue(e)),).toList()))
        .toList(growable:false);
  }

  List<String> getColumn(){
    return (template['fields'] as List).map((e) => e['field'].toString()).toList();
  }

  void updateDataGriDataSource() {
    buildPaginatedDataGridRows();
    notifyListeners();
  }

  List<TemplateModel> _paginated = [];
  @override
  List<DataGridRow> get rows => _dataGridRow;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      if (index % 2 != 0) {
        return ThemeConfig.greyColor.withOpacity(0.2);
      }

      return Colors.transparent;
    }
    List<Widget> listWidget = row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
            color: Colors.transparent
        ),
        padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding/2),
        child: MyField(
          showlabel: false,
          field: (row as CustomDataGridRow).model.getInfoField(dataGridCell.columnName,template),
          view: 'list',
          model: row.model,
          callback: (value){
            row.model.setValue(dataGridCell.columnName, value);
          },
        ),
      );
    }).toList();
    // TODO: implement buildRow
    return DataGridRowAdapter(
        color: getRowBackgroundColor(),
        cells: listWidget);
  }
  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * rowPerpage;
    int endIndex = startIndex + rowPerpage;
    if(listModel.isNotEmpty) {
      _paginated =
          listModel.getRange(startIndex,
              endIndex > listModel.length ? listModel.length : endIndex).toList(
              growable: false);
    }else{
      _paginated = [];
    }
    updateDataGriDataSource();
    return true;
  }



  // @override
  // int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
  //   //check number
  //   final String? value1 = a
  //       ?.getCells()
  //       .firstWhereOrNull((element) => element.columnName == sortColumn.name)
  //       ?.value.toString();
  //   final String? value2 = b
  //       ?.getCells()
  //       .firstWhereOrNull((element) => element.columnName == sortColumn.name)
  //       ?.value.toString();
  //
  //
  //   int? aLength = value1?.length;
  //   int? bLength = value2?.length;
  //
  //   if (aLength == null || bLength == null) {
  //     return 0;
  //   }
  //
  //   try {
  //     DateTime dateTime1 = DateFormat('HH:mm:ss dd/MM/yyyy').parse(value1!);
  //     DateTime dateTime2 = DateFormat('HH:mm:ss dd/MM/yyyy').parse(value2!);
  //     if(sortColumn.sortDirection == DataGridSortDirection.ascending){
  //       return dateTime1.compareTo(dateTime2);
  //     }else{
  //       return dateTime2.compareTo(dateTime1);
  //     }
  //   }catch(e){
  //     print(e);
  //   }
  //
  //   try {
  //     double double1 = double.parse(value1!);
  //     double double2 = double.parse(value2!);
  //     if(sortColumn.sortDirection == DataGridSortDirection.ascending){
  //       return double1.compareTo(double2);
  //     }else{
  //       return double2.compareTo(double1);
  //     }
  //   }catch(e){
  //     print(e);
  //   }
  //
  //   return super.compare(a, b,sortColumn);
  // }

  // Widget _buildActionRow(TemplateModel model,Color color){
  //   Map<String,dynamic> field = (modelType.getListViewTemplate()['fields'] as List)
  //       .where((element) => element['field'] == 'action_button').first;
  //   if(field['type'] == 'multiple_button'){
  //     return _buildActionMultipleButton(model, color);
  //   }
  //   return _buildActionDropdownButton(model, color);
  // }
  //
  // List<PopupMenuItem<String>> _buildDropdownList(TemplateModel model,Color color){
  //   return ((modelType.getListViewTemplate()['fields'] as List)
  //       .where((element) => element['field'] == 'action_button').first['action'] as List)
  //       .map((e) => PopupMenuItem<String>(
  //     height: 30,
  //     value: e['type'],
  //     child: Row(
  //       children: [
  //         Icon(
  //           e['icon'] ,
  //           size: 15,
  //         ),
  //         const SizedBox(width: 5),
  //         Text(
  //           e['label'].toString().toLowerCase(),
  //           style: ThemeConfig.labelStyle.copyWith(color: ThemeConfig.textColor,fontWeight: FontWeight.bold),
  //         ),
  //       ],
  //     ),
  //   )).toList();
  // }
  //
  // Widget _buildActionDropdownButton(TemplateModel model,Color color){
  //   return GestureDetector(
  //     onTapUp: (TapUpDetails details) async{
  //       double left = details.globalPosition.dx - details.localPosition.dx - 7*ThemeConfig.defaultPadding/2;
  //       double top = details.globalPosition.dy - details.localPosition.dy + 35;
  //       await showMenu<String>(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(2*ThemeConfig.borderRadius))
  //         ),
  //         context: context,
  //         position: RelativeRect.fromLTRB(left,top,left,top),      //position where you want to show the menu on screen
  //         items: _buildDropdownList(model,color),
  //         elevation: 8.0,
  //       ).then<void>((String ?value) {
  //         if(value != null) {
  //           _buildAction(model,value);
  //         }
  //       });
  //     },
  //     child: const Icon(Icons.more_vert_outlined,color: Colors.grey,size: 20,),
  //   );
  // }
  //
  // Widget _buildActionMultipleButton(TemplateModel model,Color color){
  //   return Container(
  //     // color: color,
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: ((modelType.getListViewTemplate()['fields'] as List)
  //           .where((element) => element['field'] == 'action_button').first['action'] as List)
  //           .map((e) => Tooltip(
  //         message: e['label']??'',
  //         child: InkWell(
  //           onTap: () {
  //             _buildAction(model,e['type']??'');
  //           },
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding/4),
  //             child: Icon(e['icon'],color: e['color']??ThemeConfig.buttonPrimary,size: e['width']??ThemeConfig.defaultSize,),
  //           ),
  //         ),
  //       )).toList(),
  //     ),
  //   );
  // }
  //
  // _buildAction(TemplateModel model,String action){
  //   if(action == 'edit'){
  //     showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             scrollable: true,
  //             content: MyCreateView(model:model,isNew: false,),
  //           );
  //         }).then((value){
  //       if(value == null){
  //         model.initValue();
  //       }else{
  //         if(!value){
  //           model.initValue();
  //         }else{
  //           listModel.refresh();
  //           updateDataGriDataSource();
  //           callback(true);
  //         }
  //       }
  //     });
  //   }else if(action == 'delete'){
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return CupertinoAlertDialog(
  //           title: Text('Xóa ${model.getValue('name')}'),
  //           content: Text('Bạn có muốn xóa ${model.getValue('name')}'),
  //           actions: [
  //             CupertinoDialogAction(
  //                 onPressed:(){
  //                   Navigator.of(context).pop();
  //                   model.delete().then((value){
  //                     if(value){
  //                       listModel.remove(model);
  //                       listAllModel.remove(model);
  //                       updateDataGriDataSource();
  //                       // appController.message = SweetAlert(
  //                       //   type: SweetAlertType.success,
  //                       //   message: 'Xóa ${model.getModelName()} thành công',
  //                       //   title: 'Thành công',
  //                       // );
  //                       // appController.pushNotificationStream.rebuildWidget(true);
  //                       callback(true);
  //                     }else{
  //                       // appController.message = SweetAlert(
  //                       //   type: SweetAlertType.error,
  //                       //   message: 'Xóa ${model.getModelName()} không thành công',
  //                       //   title: 'Lỗi',
  //                       // );
  //                       // appController.pushNotificationStream.rebuildWidget(true);
  //                     }
  //                   });
  //                 },
  //                 child: const Text('Xóa')
  //             ),
  //             CupertinoDialogAction(
  //                 onPressed:(){
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('Hủy')
  //             )
  //           ],
  //         );
  //       },
  //     );
  //   }else if(action == 'preview'){
  //     showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             scrollable: true,
  //             content: model.getPreviewScreen(),
  //           );
  //         });
  //   }
  // }
}



class CustomDataGridRow extends DataGridRow{
  TemplateModel model;
  CustomDataGridRow({required super.cells,required this.model});

}