import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map2.dart';
class UpdatePointScreen extends StatefulWidget{
  final PointModel model;
  final bool isCreate;

  const UpdatePointScreen({super.key, required this.model, this.isCreate = false});

  @override
  State<UpdatePointScreen> createState() => _UpdatePointScreenState();
}

class _UpdatePointScreenState extends State<UpdatePointScreen> {
  bool isLoading = false;
  TextEditingController lng = TextEditingController();
  TextEditingController lat = TextEditingController();
  @override
  void initState() {
    lng.text = widget.model.longitude;
    lat.text = widget.model.latitude;
    super.initState();
  }
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
                    MyCustomText(text: widget.isCreate?'Thêm điểm':'Cập nhật điểm', style: ThemeConfig.titleStyle.copyWith(color: ThemeConfig.whiteColor,fontWeight: FontWeight.bold)),
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
    return Column(
      children: [
        Expanded(child: _buildForm()),
        _buildAction()
      ],
    );
  }

  Widget _buildForm(){
    return ListView(
      children: [
        MyTextField(
          readOnly: !widget.isCreate,
          title: 'Tên',
          initValue: widget.model.name,
          callback: (value){
            widget.model.name = value;
          },
        ),
        MyTextField(
          initValue: widget.model.des,
          title: 'Mô tả',
          callback: (value){
            widget.model.des = value;
          },
        ),
        MyTextField(
          initValue: widget.model.note,
          title: 'Ghi chú',
          callback: (value){
            widget.model.note = value;
          },
        ),
        MyTextField(
          title: 'Vĩ độ',
          type: TextInputType.number,
          callback: (value){
            widget.model.latitude = value;
          },
          controller: lat,
        ),
        MyTextField(
          title: 'Kinh độ',
          type: TextInputType.number,
          callback: (value){
            widget.model.longitude = value;
          },
          controller: lng,
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => Get.to(() => Map2Screen(focus: LatLng(double.tryParse(widget.model.latitude)??0,double.tryParse(widget.model.longitude)??0),title: widget.model.name,))?.then((value){
              if(value != null){
                widget.model.latitude = (value as LatLng).latitude.toString();
                widget.model.longitude = value.longitude.toString();
                lat.text = widget.model.latitude;
                lng.text = widget.model.longitude;
                setState(() {
                });
              }
            }),
            child: Container(
              margin: EdgeInsets.only(bottom: ThemeConfig.defaultPadding/2,right: ThemeConfig.defaultPadding),
              height: 48,width: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ThemeConfig.borderRadius/2),
                  border: Border.all(color: Colors.grey)
              ),
              child: const Icon(FeatherIcons.map,color: ThemeConfig.greyColor,),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAction(){
    return GestureDetector(
      onTap: (){
        if(!isLoading && widget.model.checkValidate()){
          if(widget.isCreate){
            createPoint();
          }else{
            updatePoint();
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding,horizontal: ThemeConfig.defaultPadding),
        height: 48,
        decoration: BoxDecoration(
          color: ThemeConfig.greenColor,
          borderRadius: BorderRadius.circular(ThemeConfig.borderRadius/2)
        ),
        alignment: Alignment.center,
        child: MyCustomText(text: 'Xác nhận',style: ThemeConfig.defaultStyle,color: ThemeConfig.fourthColor,fontWeight: FontWeight.bold,),
      ),
    );
  }

  Future<bool> createPoint() async {
    isLoading = true;
    Get.dialog(const LoadingItem(size: 200),barrierDismissible: false);
    bool result = await api.createPoint(widget.model.toJsonCreate());
    Get.back();
    if(result){
      await api.addPointToProject(widget.model.toJsonAddProject());
      Get.back(result:  true);
      appController.toast('Thêm điểm thành công');
    }else{
      appController.toast('Thêm điểm thất bại',ThemeConfig.redColor);
    }
    isLoading = false;
    return result;
  }

  Future<bool> updatePoint() async {
    isLoading = true;
    Get.dialog(const LoadingItem(size: 200),barrierDismissible: false);
    bool result = await api.updatePoint(widget.model.toJsonCreate());
    Get.back();
    if(result){
      Get.back(result:  widget.model);
      appController.toast('Cập nhật điểm thành công');
    }else{
      appController.toast('Cập nhật thất bại',ThemeConfig.redColor);
    }
    isLoading = false;
    return result;
  }
}