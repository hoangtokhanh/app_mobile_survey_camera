import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointItem extends StatelessWidget{
  final PointModel model;
  final bool onTap;
  final MenuCallback callback;
  const PointItem({super.key, required this.model,this.onTap = true, required this.callback});
  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: onTap,
      endActionPane: ActionPane(
        extentRatio: 100/Get.width,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed:(context2){
              _removePoint(context);
            },
            backgroundColor: ThemeConfig.redColor,
            foregroundColor: Colors.white,
            icon: FeatherIcons.trash2,
            label: 'Xóa',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: (){
          if(onTap){
            Get.to(() => PointDetailScreen(model: model,))?.then((value) => callback(true));
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding/5),
          padding: EdgeInsets.all(ThemeConfig.defaultPadding/2),
          decoration: BoxDecoration(
              color: ThemeConfig.fourthColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    offset: const Offset(0,5),
                    color: ThemeConfig.greyColor2.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1
                )
              ]
          ),
          child: Row(
            children: [
              _buildImage(),
              Expanded(child: Column(
                children: [
                  _buildRecord('Tên:', model.name),
                  _buildRecord('Mô tả:', model.des),
                  _buildRecord('Ghi chú:', model.note),
                  _buildRecord('Vĩ độ:', model.latitude),
                  _buildRecord('Kinh độ:', model.longitude),
                  _buildRecord('Tạo bởi:', model.user),
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecord(String label, String value){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyCustomText(text: label, style: ThemeConfig.defaultStyle),
        MyCustomText(text: value, style: ThemeConfig.defaultStyle,fontWeight: FontWeight.bold,),
      ],
    );
  }

  Widget _buildImage(){
    return Padding(
      padding: EdgeInsets.only(right: ThemeConfig.defaultPadding/2),
      child: ImageCircle(image: model.imageShow.isNotEmpty?'${AppConfig.ASSET_URL}${model.imageShow}':'', size: 50),
    );
  }

  _removePoint(context){
    showDialog(
      context: context,
      builder: (context) {
        return DialogConfim(
            message:'Xác nhận xóa điểm ${model.name}',
            onCancel: () => Navigator.pop(context),
            onConfirm: () async{
              Get.back();
              Get.dialog(const LoadingItem(size: 200),barrierDismissible: false);
              await api.deletePoint({'point':model.name}).then((value) => callback(true));
              Get.back();
            }
        );
      },
    );
  }
}