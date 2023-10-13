import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectItem extends StatelessWidget{
  final ProjectModel model;
  final bool onTap;
  const ProjectItem({super.key, required this.model, this.onTap = true});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(onTap){
          Get.to(() => ProjectDetailScreen(model: model));
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
        child: Column(
          children: [
            _buildRecord('Tên:', model.name),
            _buildRecord('Mô tả:', model.des),
            _buildRecord('Số điểm:', model.points.length.toString()),
          ],
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
}