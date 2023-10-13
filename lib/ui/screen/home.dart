import 'package:flutter/material.dart';
import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:get/get.dart';
class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyCustomText(text: 'Smart Look', style: ThemeConfig.titleStyle.copyWith(color: ThemeConfig.whiteColor,fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        MyCustomText(text: appController.user, style: ThemeConfig.titleStyle.copyWith(color: ThemeConfig.whiteColor,fontWeight: FontWeight.bold)),
                        SizedBox(width: ThemeConfig.defaultPadding/2,),
                        InkWell(
                          onTap: (){
                            appController.logout();
                          },
                          child: Icon(Icons.logout,size: ThemeConfig.iconSize,color: ThemeConfig.whiteColor,),
                        )
                      ],
                    )
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
          MyCustomText(text: 'Danh sách dự án của tôi', style: ThemeConfig.headerStyle.copyWith(fontWeight: FontWeight.bold)),
          const Expanded(child: ListProjectView()),
        ],
      ),
    );
  }
}
