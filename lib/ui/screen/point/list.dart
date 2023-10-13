import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
class ListPointView extends StatefulWidget{
  final ProjectModel model;
  const ListPointView({super.key, required this.model});

  @override
  State<ListPointView> createState() => _ListPointViewState();
}

class _ListPointViewState extends State<ListPointView> {
  final RxString user = appController.user.obs;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getListPointProject({'project':widget.model.name}),
      builder: (BuildContext context, AsyncSnapshot<List<PointModel>> snapshot) {
        if(snapshot.hasData){
          return RefreshIndicator(
            onRefresh: ()async{
              setState(() {});
            },
            child:  Column(
              children: [
                MyCustomDropdown(
                  value: user.value,
                    callback: (value){
                  user.value = value;
                }, data: {
                appController.user:'Của tôi',
                  '':'Tất cả'
                }),
                snapshot.data!.isNotEmpty?Expanded(child: Obx(() => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: snapshot.data!.where((element) => element.user.contains(user.value)).map((e){
                    e.project = widget.model.name;
                    return PointItem(model: e,callback:(value){
                      setState(() {});
                    },);
                  }).toList(),
                ))):const SizedBox()
              ],
            ),
          );
        }else{
          return const LoadingItem(size: 200);
        }
      },);
  }
}