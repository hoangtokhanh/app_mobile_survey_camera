import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../model/template/template_model.dart';
import '../../controller/controller.dart';
import '../../controller/reload_controller.dart';
import '../../model/reload_controller_model.dart';
import 'data_list.dart';
import 'header.dart';
import 'package:get/get.dart';
class MyListView extends StatefulWidget {
  MyListView(
      {Key? key,
      required this.listDataModel,
      required this.template,
      required this.typeModel,
      this.header = true,
      required this.height,
      this.rowHeight, this.reloadControllerStream, this.select = SelectionMode.none, this.callback, this.headerAction})
      : super(key: key);
  final RxList<TemplateModel> listDataModel;
  final TemplateModel typeModel;
  final bool header;
  final double height;
  final double? rowHeight;
  final Map<dynamic, dynamic> template;
  final ReloadControllerStream ?reloadControllerStream;
  final SelectionMode select;
  final MenuCallback ?callback;
  final Widget ? headerAction;

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  final GlobalKey<SfDataGridState> keyGridView = GlobalKey<SfDataGridState>();
  @override
  void initState() {
    super.initState();
  }
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.header
            ? ListViewHeader(
                callback: (param) async {
                  if (param == true) {
                    widget.listDataModel.refresh();
                  } else {
                    search = param['search'] ?? '';
                    widget.reloadControllerStream!.reloadData(
                      ReloadControllerModel(data: getListModel().value,type: TypeReLoad.reset)
                    );
                  }
                },
                keyGridView: keyGridView,
                typeModel: widget.typeModel,
                listDataModel: widget.listDataModel,
                template: widget.template,
                headerAction: widget.headerAction,
              )
            : const SizedBox(),
        MyDaTaList(
          rowHeight: widget.rowHeight,
          height: widget.header?(widget.height - 60):widget.height,
          keyGridView: keyGridView,
          typeModel: widget.typeModel,
          listDataModel: getListModel(),
          template: widget.template,
          reloadControllerStream: widget.reloadControllerStream,
          select: widget.select,
          callback: (value){
            widget.callback!(value);
          },
        )
      ],
    );
  }

  RxList<TemplateModel> getListModel() {
    List<String> column = (widget.template['fields'] as List).map((e) => e['field'].toString()).toList();
    if (search.isNotEmpty) {
      List<TemplateModel> dataList = widget.listDataModel.where((element) {
        bool flag = false;
        for (String col in column) {
          if ((element.getValue(col).toString().toLowerCase()).contains(search.toLowerCase())) {
            flag = true;
          }
        }
        return flag;
      }).toList();
      return dataList.obs;
    }
    return widget.listDataModel;
  }
}
