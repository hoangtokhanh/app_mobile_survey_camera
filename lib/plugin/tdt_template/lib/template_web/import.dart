import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdt_template/template_web/widget/custom_dialog.dart';
import 'package:tdt_template/template_web/widget/loading_item.dart';
import 'package:tdt_template/template_web/widget/my_button.dart';
import 'package:tdt_template/template_web/widget/selection_button_2.dart';

import '../config/theme_config.dart';
import '../model/template/template_model.dart';
import '../widget/custom_text.dart';

class MyImportScreen extends StatefulWidget{
  const MyImportScreen({Key? key,required this.typeModel}) : super(key: key);
  final TemplateModel typeModel;

  @override
  State<MyImportScreen> createState() => _MyImportScreenState();
}

class _MyImportScreenState extends State<MyImportScreen> {
  late Sheet sheet;

  final RxBool isReadFileSuccess = false.obs;

  final RxBool isLoading = false.obs;

  final RxBool isComplete = false.obs;

  RxString fileName = ''.obs;

  int totalRecordImport = 0;

  List<TemplateModel> listError = [];

  List<TemplateModel> listSuccess = [];

  FilePickerResult ?filePickerResult;

  Map<String,String> mapColumn = {};

  List<String> columns = [];

  List<DataColumn> listCol = [];

  List<String> rowData = [];

  RxBool hasFile = false.obs;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(children: [Expanded(child: _buildMain(context))]);
  }

  Widget _buildMain(context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding),
      child: Obx(() => isComplete.value?_buildComplete():Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: ListView(
            children: [
              MyCustomText(text:'Nhập dữ liệu ${widget.typeModel.getModelName()}',
                  style: ThemeConfig.titleStyle,
                  fontWeight: FontWeight.bold,color: ThemeConfig.primaryColor
              ),
              SizedBox(height: ThemeConfig.defaultPadding/2,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child: MyButton(
                      validate: true,
                      height: 40,
                      width: 200,
                      borderRadius: ThemeConfig.borderRadius/2,
                      color: ThemeConfig.primaryColor,
                      callback: ()=> _readExcel(context),
                      childWidget: MyCustomText(
                        text: 'Chọn file',
                        style: ThemeConfig.defaultStyle.copyWith(color: ThemeConfig.fourthColor),
                      ),
                    ),
                  ),
                  SizedBox(width: ThemeConfig.defaultPadding,),
                  Obx(() => Text(
                    fileName.value,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: ThemeConfig.labelSize
                    ),
                  ))
                ],
              ),
              SizedBox(height: ThemeConfig.defaultPadding/2,),
              Obx(()=> fileName.isNotEmpty?MyCustomText(text:'Xem trước mẫu dữ liệu:',
                style: ThemeConfig.titleStyle.copyWith(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: ThemeConfig.primaryColor),
              ):const SizedBox()),
              Obx(() => fileName.isNotEmpty?_buildPreviewExcel():const SizedBox()),
              Obx(() => (isReadFileSuccess.value)?_buildMapCol():const SizedBox()),
            ],
          )),
          _buildAction()

        ],
      )),
    );
  }

  Future<void> _readExcel(context) async{
    isReadFileSuccess.value = false;
    filePickerResult =
    await FilePicker.platform.pickFiles();

    if (filePickerResult != null) {
      fileName.value = filePickerResult?.files.single.name??'';
      hasFile.value = true;
      var data = filePickerResult?.files.single.bytes;
      var excel = Excel.decodeBytes(data!);
      sheet = excel.tables['Sheet1']!;
      try {
        listCol = [];
        rowData = [];
        mapColumn = {};
        for (int i = 0; i < sheet.maxCols; i++) {
          String col = sheet.row(0)[i]?.value;
          columns.add(col);
          mapColumn[col] = col.toString().toLowerCase();
          listCol.add(DataColumn(label: Text(col)),);
          String value = sheet.row(1)[i]!.value.toString();
          rowData.add(value);
        }
        isReadFileSuccess.value = true;
      }catch(e){
        isReadFileSuccess.value = false;
      }
    }else{
      fileName.value = '';
    }
  }

  Widget _buildPreviewExcel(){
    return isReadFileSuccess.value?SingleChildScrollView(
      child: DataTable(
          horizontalMargin: 0,
          columnSpacing: 50,
          showCheckboxColumn: true,
          columns: listCol,
          rows: [
            DataRow(cells: rowData.map((e){
              return DataCell(Text(e));
            }).toList())
          ]
      ),
    ): MyCustomText(text:'Read data failure',style: ThemeConfig.defaultStyle,);
  }

  Widget _buildMapCol(){
    List<TableRow> rowData = [];
    rowData.add(TableRow(children: [
      _buildCell('Tên cột', true),
      _buildCell('Liên kết với thuộc tính', true),
    ]));
    mapColumn.forEach((key, value) {
      rowData.add(
          TableRow(children: [
            _buildCell(key),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: MyDropdown2(
                  value: widget.typeModel.getAllField().contains(value)?value:'',
                  data: widget.typeModel.getAllFieldMetadata(),
                  callback: (value){
                    mapColumn[key] = value.toString();
                  },
                ),
              ),
            )
          ])
      );
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyCustomText(text:'Liên kết dữ liệu',style: ThemeConfig.titleStyle.copyWith(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
        Table(
          border: TableBorder.symmetric(inside: BorderSide.merge(
              const BorderSide(color: Colors.grey),BorderSide.none
          )),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: rowData,
        )
      ],
    );
  }

  Widget _buildCell(String value, [bool isHeader = false]) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: MyCustomText(
          text:value,
          style: ThemeConfig.defaultStyle,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAction(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(() => (isReadFileSuccess.value && !isComplete.value)?_buildImportButton():const SizedBox()),
        SizedBox(width: ThemeConfig.defaultPadding/2,),
        _buildCancelButton()
      ],
    );
  }

  Widget _buildCancelButton(){
    return Obx(() => InkWell(
      onTap: () {
        Get.back(result: isComplete.value);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey), borderRadius: BorderRadius.circular(5)),
        child: MyCustomText(
          text: isComplete.value?'Hoàn thành':'Hủy',
          style: ThemeConfig.defaultStyle,
          color: ThemeConfig.greyColor,
        ),
      ),
    ));
  }

  Widget _buildImportButton(){
    return InkWell(
      onTap: _importExcel,
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(5)),
        child: MyCustomText(
          text: 'Nhập',
          style: ThemeConfig.defaultStyle,
          color: ThemeConfig.greenColor,
        ),
      ),
    );
  }

  Future _importExcel() async{
    Get.dialog(const LoadingItem(size: 200),barrierDismissible: false);
    isLoading.value = true;
    int index = 1;
    totalRecordImport = (sheet.maxRows - 1) < 0
        ? 0
        : sheet.maxRows - 1;
    for (index; index < sheet.maxRows; index++) {
      var row = sheet.row(index);
      int indexCol = 0;
      TemplateModel model = widget.typeModel.getEmptyModel();
      mapColumn.forEach((key, value) {
        model.setValue(value, row[indexCol++]?.value.toString());
      });
      model.create().then((value){
        if(value){
          listSuccess.add(model);
        }else{
          listError.add(model);
        }
        if(totalRecordImport == listSuccess.length + listError.length) {
          // Get.back();
          // listError.clear();
          // listSuccess.clear();
          isLoading.value = false;
          // hasFile.value = false;
          isComplete.value = true;
        }
      });
    }
    Get.back();
  }

  Widget _buildComplete(){
    List<Widget> listWidget = [];
    listWidget.addAll(listSuccess.map((e) => MyCustomText(text: 'Thêm thành công ${e.getRecordName()}',
      style: ThemeConfig.defaultStyle,
      color: ThemeConfig.greenColor,
    )));
    listWidget.addAll(listError.map((e) => MyCustomText(text: 'Thêm thất bại ${e.getRecordName()}',
      style: ThemeConfig.defaultStyle,
      color: ThemeConfig.redColor.withOpacity(0.7),
    )));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyCustomText(text: 'Hoàn thành nhập dữ liệu ${widget.typeModel.getModelName()}',
          style: ThemeConfig.titleStyle,
          color: ThemeConfig.primaryColor,
        ),
        SizedBox(height: ThemeConfig.defaultPadding/2,),
        Row(
          children: [
            MyCustomText(text: 'Thành công ${listSuccess.length} dòng, ',
              style: ThemeConfig.defaultStyle,
              color: ThemeConfig.greenColor,
            ),
            MyCustomText(text: 'Thất bại ${listError.length} dòng',
              style: ThemeConfig.defaultStyle,
              color: ThemeConfig.redColor,
            ),

          ],
        ),
        SizedBox(height: ThemeConfig.defaultPadding/2,),
        MyCustomText(text: 'Chi tiết:',
          style: ThemeConfig.titleStyle,
          color: ThemeConfig.primaryColor,
        ),
        SizedBox(height: ThemeConfig.defaultPadding/2,),
        Expanded(child: ListView(
          children: listWidget,
        )),
        SizedBox(height: ThemeConfig.defaultPadding/2,),
        _buildAction(),
      ],
    );
  }
}
