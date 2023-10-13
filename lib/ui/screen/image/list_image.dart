import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ListImageView extends StatefulWidget{
  final List<String> listImage;
  final PointModel point;
  final MenuCallback callback;
  const ListImageView({super.key, required this.listImage, required this.point, required this.callback});

  @override
  State<ListImageView> createState() => _ListImageViewState();
}

class _ListImageViewState extends State<ListImageView> {
  final RxInt indexPage = 0.obs;
  final PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(child: Padding(
          padding: EdgeInsets.all(ThemeConfig.defaultPadding),
          child: PageView(
            onPageChanged: (value){
              indexPage.value = value;
            },
            controller: pageController,
            children: widget.listImage.map((e) => _buildItemImage(e)).toList(),
          ),
        )),
        _buildListDot(),
        SizedBox(height: ThemeConfig.defaultPadding,)
      ],
    );
  }

  Widget _buildItemImage(String image){
    return Column(
      children: [
        Flexible(child: ImageWidget(image: '${AppConfig.ASSET_URL}$image')),
        SizedBox(height: ThemeConfig.defaultPadding/2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: ()async{
                Get.dialog(const LoadingItem(size: 200),barrierDismissible: false);
                bool result = await api.setAvatarPoint({'point':widget.point.name,'image':image});
                if(result){
                  widget.callback(image);
                }
                Get.back();
              },
              child: Container(
                alignment: Alignment.center,
                color: ThemeConfig.greenColor,
                width: 120,height: 40,
                child: MyCustomText(
                  text: 'Hình đại diện',
                  style: ThemeConfig.defaultStyle,
                  color: ThemeConfig.fourthColor,
                ),
              ),
            ),
            SizedBox(width: ThemeConfig.defaultPadding,),
            GestureDetector(
              onTap: () => _removeImage(image),
              child: Container(
                alignment: Alignment.center,
                color: ThemeConfig.redColor,
                width: 120,height: 40,
                child: MyCustomText(
                  text: 'Xóa ảnh',
                  style: ThemeConfig.defaultStyle,
                  color: ThemeConfig.fourthColor,
                ),
              ),
            )
          ],
        )
      ]
    );
  }

  Widget _buildListDot(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.listImage.map((e) => Obx(() => Container(
        height: 10,width: 10,
        margin: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding/10),
        decoration: BoxDecoration(
            color: indexPage.value == widget.listImage.indexOf(e)?ThemeConfig.primaryColor:ThemeConfig.greyColor2.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)
        ),
      ))).toList(),
    );
  }

  _removeImage(String image){
    showDialog(
      context: context,
      builder: (context) {
        return DialogConfim(
            message:'Xác nhận xóa ảnh',
            onCancel: () => Navigator.pop(context),
            onConfirm: () async{
              Get.back();
              Get.dialog(const LoadingItem(size: 200),barrierDismissible: false);
              bool result = await api.removeImagePoint({'point':widget.point.name,'image':image});
              if(result){
                widget.listImage.remove(image);
              }
              Get.back();
              indexPage.value = 0;
              setState(() {});
            }
        );
      },
    );
  }
}