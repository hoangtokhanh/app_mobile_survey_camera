
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
typedef void MenuCallback(ObjectKey);
class AppController extends GetxController{
  String errorLog = '';
  String token = '';
  String user = '';
  String role = '';
  RxBool allowNotification = true.obs;
  RxBool allowSound = true.obs;
  String filePath = 'sound/notification.mp3';
  bool permissionLocation  = false;
  LatLng myLocation = LatLng(10.7553411, 106.4150337);
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  late List<CameraDescription> cameras;

  @override
  void onInit() async{
    super.onInit();
  }
  void toastError([String ?mess]){
    Get.snackbar('Error', mess??errorLog, backgroundColor: Colors.red);
  }

  void toast(String message,[Color bg = ThemeConfig.greenColor]){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bg
    );
  }

  bool checkLogin(){
    return token.isNotEmpty;
  }

  Future setLoginData(data) async{
    var pref = await SharedPreferences.getInstance();
    pref.setString('user', data['user']);
    pref.setString('token', data['token']);
    pref.setString('role', data['role']);
    await getLoginData();
  }

  Future getLoginData() async {
    var pref = await SharedPreferences.getInstance();
    token = pref.getString('token')??'';
    user =  pref.getString('user')??'';
    role = pref.getString('role')??'';
  }

  Future resetLoginData() async{
    var pref = await SharedPreferences.getInstance();
    pref.clear();
    await getLoginData();
  }

  Map<String,dynamic> getHeader(){
    return {'Content-Type': 'application/json','accept':'*/*','Authorization':'Bearer $token'};
  }

  void logout() async{
    resetLoginData();
    Get.offAllNamed('/');
  }

  Future<void> checkPermission() async{
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        throw const FormatException('Location services are disabled');
      }
      permission = await _geolocatorPlatform.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _geolocatorPlatform.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          // return Future.error('Location permissions are denied');
          throw const FormatException('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        permission = await _geolocatorPlatform.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          // return Future.error('Location permissions are denied');
          throw const FormatException('Location permissions are denied');
        }
      }
      // permission = await _geolocatorPlatform.checkPermission();
      //
      // while(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      //   permission = await _geolocatorPlatform.requestPermission();
      // }
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      _geolocatorPlatform.getCurrentPosition().then((value){
        if(value == null){
          permissionLocation = false;
          myLocation = LatLng(106.4150337, 106.4150337);
        }
        else {
          permissionLocation = true;
          myLocation = LatLng(value.latitude, value.longitude);
        }
      });

    } catch (e) {
      print(e);
    }
  }


}

final AppController appController = Get.put(AppController());