import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:tdt_template/template_web/widget/loading_item.dart';

import '../config/theme_config.dart';
import '../model/template/template_model.dart';
import '../widget/MyWidget.dart';
import '../widget/custom_text.dart';
import 'fields/field.dart';
class CreateView extends StatelessWidget {
  final TemplateModel model;
  final bool isNew;
  final TextStyle labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: ThemeConfig.smallSize);

  CreateView({Key? key, required this.model, this.isNew = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child:  SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              padding: EdgeInsets.all(ThemeConfig.defaultPadding),
              child: Row(
                children: [
                  Flexible(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildTitle(),
                      Container(
                        margin: const EdgeInsets.only(top: 24, bottom: 24),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(5)),
                        child: _buildForm(context),
                      ),
                      _buildAction()
                    ],
                  ),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(){
    return  MyCustomText(
      text:isNew?'Thêm mới ${model.getModelName()}':'Cập nhật ${model.getModelName()}',
      style: ThemeConfig.headerStyle,
    );
  }

  Widget _buildForm(context) {
    List fields = [];
    if(isNew){
      if(model.getCreateViewTemplate() != null){
        fields = model.getCreateViewTemplate()['fields'];
      }else{
        fields = model.getEditViewTemplate()['fields'];
      }
    }else{
      fields = model.getEditViewTemplate()['fields'];
    }
    return ResponsiveGridRow(
      children: fields
          .map((e) => ResponsiveGridCol(
        lg: e['span'],
        child: MyField(
          field: e,
          view: isNew ? 'create' : 'edit',
          callback: (value) {},
          model: model,
        ),
      ))
          .toList(),
    );
  }

  Widget _buildAction(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey), borderRadius: BorderRadius.circular(5)),
            child: MyCustomText(
              text: 'Hủy',
              style: ThemeConfig.defaultStyle,
              color: ThemeConfig.greyColor,
            ),
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        InkWell(
          onTap: actionSave,
          child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(5)),
            child: MyCustomText(
              text: 'Hoàn thành',
              style: ThemeConfig.defaultStyle,
              color: ThemeConfig.greenColor,
            ),
          ),
        ),
      ],
    );
  }

  actionSave()async{
    if(model.isValidate.value){
      Get.dialog(const LoadingItem(size: 200),barrierDismissible: false);
      bool result = false;
      if(isNew){
        result = await model.create();
      }else{
        result = await model.update();
      }
      Get.back();
      if (result) {
        MyWidget.successToast(content: '${isNew?'Thêm mới':'Cập nhật'} thành công');
        Get.back(result: true);
      } else {
        MyWidget.failedToast(content: '${isNew?'Thêm mới':'Cập nhật'} thất bại');
      }

    }
    else{
      MyWidget.failedToast(
        content: 'Vui lòng nhập đầy đủ thông tin',
      );
    }
  }

}
