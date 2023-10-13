import 'dart:typed_data';
import 'package:dio/dio.dart' as dio;
import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
class PointDetailScreen extends StatefulWidget{
  final PointModel model;
  const PointDetailScreen({super.key, required this.model});

  @override
  State<PointDetailScreen> createState() => _PointDetailScreenState();
}

class _PointDetailScreenState extends State<PointDetailScreen> {
  final ImagePicker _picker = ImagePicker();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyCustomText(text: 'Thông tin điểm', style: ThemeConfig.headerStyle.copyWith(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: (){
                  Get.to(() => UpdatePointScreen(model: widget.model, isCreate: false,))!.then((value){
                    if(value != null){
                      setState(() {
                        widget.model.updateModel(value);
                      });
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding/2),
                  decoration: const BoxDecoration(
                    color: ThemeConfig.greenColor2,

                  ), height: 30,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(FeatherIcons.edit,size: ThemeConfig.headerSize,color: ThemeConfig.fourthColor,),
                      MyCustomText(text: 'Cập nhật', style: ThemeConfig.defaultStyle.copyWith(fontWeight: FontWeight.bold,color: ThemeConfig.fourthColor)),
                    ],
                  ),
                ),
              )
            ],
          ),
          PointItem(model: widget.model,onTap: false,callback: (value){
            setState(() {

            });
          },),
          SizedBox(height: ThemeConfig.defaultPadding/2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyCustomText(text: 'Danh sách hình ảnh', style: ThemeConfig.titleStyle.copyWith(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  GestureDetector(
                    onTap: ()async{
                      final List<XFile>? images = await _picker.pickMultiImage();
                      Get.dialog(const LoadingItem(size: 200));
                      List<dio.FormData> listData = [];
                      //  myHelper.customerRequest.listImage.add(imagePath);
                      if(images != null) {
                        for (XFile image in images) {
                          Uint8List bytes = await image.readAsBytes();
                          var dataImage = dio.MultipartFile.fromBytes(
                            bytes,
                            filename: image.name,
                          );
                          dio.FormData data = dio.FormData.fromMap(
                              {'image': dataImage});
                          listData.add(data);
                          // widget.model.images.add(await api.addImageToPoint({'point': widget.model.name}, data));
                        }
                      }
                      if(listData.isNotEmpty){
                        List data = await Future.wait(listData.map((e) => api.addImageToPoint({'point': widget.model.name}, e)));
                        Get.back();
                        setState(() {
                          widget.model.images.addAll((data).cast());
                        });
                      }else{
                        Get.back();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding/2),
                      decoration: const BoxDecoration(
                        color: ThemeConfig.greenColor2,

                      ), height: 30,
                      alignment: Alignment.center,
                      child: Icon(Icons.image),
                    ),
                  ),
                  SizedBox(width: ThemeConfig.defaultPadding/2,),
                  GestureDetector(
                    onTap: (){
                      Get.to(() => CaptureScreen(code: widget.model.name, callback:(value){
                        setState(() {
                          widget.model.images.add(value);
                        });
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding/2),
                      decoration: const BoxDecoration(
                        color: ThemeConfig.greenColor2,

                      ), height: 30,
                      alignment: Alignment.center,
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                  )
                ],
              )
            ],
          ),
          Expanded(child: ListImageView(listImage: widget.model.images,point: widget.model,callback: (value){
           setState(() {
             widget.model.imageShow = value;
           });
          },))
        ],
      ),
    );
  }
}