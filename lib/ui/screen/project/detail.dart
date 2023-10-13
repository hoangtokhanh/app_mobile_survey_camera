import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProjectDetailScreen extends StatefulWidget{
  final ProjectModel model;
  const ProjectDetailScreen({super.key, required this.model});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeConfig.fourthColor,
        resizeToAvoidBottomInset:false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding),
              height: 80,
              color: ThemeConfig.greenColor,
              child: SafeArea(
                child: Row(
                  children: [
                    InkWell(
                      onTap: Get.back,
                      child: Icon(Icons.arrow_back,size: ThemeConfig.iconSize,color: ThemeConfig.whiteColor,),
                    ),
                    SizedBox(width: ThemeConfig.defaultPadding/2,),
                    MyCustomText(text: widget.model.name, style: ThemeConfig.titleStyle.copyWith(color: ThemeConfig.whiteColor,fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Expanded(child: _buildBody())
          ],
        )
    );
  }

  Widget _buildBody(){
    return Padding(
      padding: EdgeInsets.all(ThemeConfig.defaultPadding/2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyCustomText(text: 'Thông tin dự án', style: ThemeConfig.headerStyle.copyWith(fontWeight: FontWeight.bold)),
          ProjectItem(model: widget.model,onTap: false,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyCustomText(text: 'Danh sách điểm', style: ThemeConfig.headerStyle.copyWith(fontWeight: FontWeight.bold)),
              floatingActionButton()
            ],
          ),
          Expanded(child: ListPointView(key:UniqueKey(),model: widget.model,)),
        ],
      ),
    );
  }

  Widget floatingActionButton(){
    return GestureDetector(
      onTap: () => Get.to(() => UpdatePointScreen(model: PointModel(project: widget.model.name),isCreate: true,))?.then((value){
        if(value == true){
          setState(() {});
        }
      }),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding/2),
        decoration: const BoxDecoration(
          color: ThemeConfig.greenColor2,

        ), height: 30,
        alignment: Alignment.center,
        child: Row(
          children: [
            Icon(FeatherIcons.plus,size: ThemeConfig.headerSize,color: ThemeConfig.fourthColor,),
            MyCustomText(text: 'Thêm điểm', style: ThemeConfig.defaultStyle.copyWith(fontWeight: FontWeight.bold,color: ThemeConfig.fourthColor)),
          ],
        ),
      ),
    );
  }
}