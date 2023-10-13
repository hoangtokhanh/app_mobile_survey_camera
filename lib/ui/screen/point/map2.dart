import 'dart:async';
import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class Map2Screen extends StatefulWidget{
  final LatLng focus;
  final String title;
  const Map2Screen({Key? key, required this.focus, required this.title}) : super(key: key);

  @override
  State<Map2Screen> createState() => _Map2ScreenState();
}

class _Map2ScreenState extends State<Map2Screen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final RxBool isLoading = false.obs;
  late LatLng center;
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  @override
  void initState() {
    // TODO: implement initState
    center = widget.focus;
    if(center.longitude != 0 && center.latitude !=0){
      addMyMarket(center);
    }else{
      center = appController.myLocation;
    }
    super.initState();
  }
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
            Flexible(child: _buildBody()),
          ],
        )
    );;
  }

  Widget _buildBody(){
    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
        color: ThemeConfig.whiteColor,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Stack(
                      children: [
                        GoogleMap(
                          onMapCreated: (GoogleMapController mapController) {
                            _mapController.complete(mapController);
                          },
                          onCameraIdle: () async {
                            isLoading.value = false;
                          },
                          onCameraMove: (detail){
                            isLoading.value = true;
                            center = detail.target;
                          },
                          myLocationButtonEnabled: true,
                          myLocationEnabled : true,
                          initialCameraPosition: CameraPosition(target: center,zoom: 16),
                          markers: Set<Marker>.of(markers.values),
                        ),
                        Column(
                          children: [
                            Expanded(
                              flex:1,
                              child: Align(alignment: Alignment.bottomCenter,child: Image.asset('assets/images/pin.png',height: 40,),),
                            ),
                            const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              _buildConfirm()
            ],
          ),
        ],
      ),
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
            child: Row(
              children: [
                MyCustomText(text: 'Vị trí của tôi: ', style: ThemeConfig.defaultStyle,fontWeight: FontWeight.bold,),
                Obx(() => isLoading.value? const Center(
                  child: SpinKitThreeBounce(
                    color: ThemeConfig.secondColor,
                    duration: Duration(seconds: 1),
                    size: 20.0,
                  ),
                ):Text(
                  '${center.latitude} - ${center.longitude}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ))
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              Get.back(result: center);
            },
            child: Container(
              alignment: Alignment.center,
              width: Get.width,
              height: 50,
              color: ThemeConfig.greenColor,
              child: MyCustomText(text: 'Xác nhận',style: ThemeConfig.defaultStyle,fontWeight: FontWeight.bold,color: ThemeConfig.fourthColor,),
            ),
          )
        ],
      ),
    );
  }

  Future<void> addMyMarket(LatLng pos) async {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    String markerIdVal = 'my_market_$markerCount';
    MarkerId markerId = MarkerId(markerIdVal);
    // final screenshotController = ScreenshotController();
    // final bytes =  await screenshotController.captureFromWidget(
    //     Material(
    //       child: ImageWidget(url: appController.user!.photoURL!,width: 30,height: 30,),));

    final Marker marker = Marker(
      markerId: markerId,
      draggable: true,
      icon: BitmapDescriptor.defaultMarker,
      position: pos,
      // icon: BitmapDescriptor.fromBytes(bytes),
      infoWindow: InfoWindow(title: 'Location:${widget.title}'),
    );
    markers[markerId] = marker;
  }
}