import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
class MapScreen extends StatefulWidget{
  final String lat;
  final String long;
  const MapScreen({super.key, this.lat = '0', this.long = '0'});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController  = MapController();
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
                    MyCustomText(text: 'Map', style: ThemeConfig.titleStyle.copyWith(color: ThemeConfig.whiteColor,fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Flexible(child: _buildMap()),
            _buildConfirm(),
          ],
        )
    );
  }

  Widget _buildMap(){
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(double.tryParse(widget.lat)??0, double.tryParse(widget.long)??0),
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            ),
            MarkerLayer(markers: [
              Marker(
                width: 40,height: 40,
                anchorPos: AnchorPos.align(AnchorAlign.top),
                point: LatLng(appController.myLocation.latitude,appController.myLocation.longitude),
                builder: (context) =>Image.asset('assets/images/pin.png',width: 40,),)
            ],)
          ]
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: (){
              mapController.move(LatLng(appController.myLocation.latitude,appController.myLocation.longitude), mapController.zoom);
            },
            child: Container(
              width: 40,height: 40,
              color: Colors.grey.withOpacity(0.5),
              alignment: Alignment.center,
              child: Icon(Icons.my_location,size: ThemeConfig.titleSize,color: ThemeConfig.greyColor,),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildConfirm(){
    return Container(
      color: ThemeConfig.whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(ThemeConfig.defaultPadding/2),
            child: MyCustomText(text: 'Vị trí của tôi: ${widget.lat} - ${widget.long}', style: ThemeConfig.defaultStyle,fontWeight: FontWeight.bold,),
          ),
          Container(
            alignment: Alignment.center,
            width: Get.width,
            height: 50,
            color: ThemeConfig.greenColor,
            child: MyCustomText(text: 'Xác nhận',style: ThemeConfig.defaultStyle,fontWeight: FontWeight.bold,color: ThemeConfig.fourthColor,),
          )
        ],
      ),
    );
  }
}