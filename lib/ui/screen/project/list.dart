import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ListProjectView extends StatefulWidget{
  const ListProjectView({super.key});

  @override
  State<ListProjectView> createState() => _ListProjectViewState();
}

class _ListProjectViewState extends State<ListProjectView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getListProject(),
      builder: (BuildContext context, AsyncSnapshot<List<ProjectModel>> snapshot) {
      if(snapshot.hasData){
        return RefreshIndicator(
          onRefresh: ()async{
            setState(() {});
          },
          child:  ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: snapshot.data!.map((e) => ProjectItem(model: e)).toList(),
          ),
        );
      }else{
        return const LoadingItem(size: 200);
      }
    },);
  }
}