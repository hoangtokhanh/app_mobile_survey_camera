import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_survey_camera/all_file.dart';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
class CaptureScreen extends StatefulWidget {
  String code;
  final MenuCallback callback;

  CaptureScreen({Key? key, required this.code,required this.callback}) : super(key: key);

  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}
class _CaptureScreenState extends State<CaptureScreen> {
  late CameraController controller;
  bool showFocusCircle = false;
  double x = 0;
  double y = 0;
  XFile? image;

  @override
  void initState() {
    super.initState();
    controller = CameraController(appController.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return GestureDetector(
      onTapUp: (details) {
        _onTap(details);
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
            child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              child: CameraPreview(controller),
            ),
            if (showFocusCircle)
              Positioned(
                  top: y - 20,
                  left: x - 20,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5)),
                  )),
            IconButton(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.arrow_back),
              color: Colors.white70,
              iconSize: 52,
              padding: const EdgeInsets.all(10),
            ),
          ],
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.photo_camera),
          onPressed: () async {
            final image = await controller.takePicture();
            print("Take photo");
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                    // Pass the automatically generated path to
                    // the DisplayPictureScreen widget.
                    imagePath: image.path,
                    code: widget.code,
                    image: image,
                  callback: (param) => widget.callback(param),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);
      print("point : $point");

      // Manually focus
      await controller.setFocusPoint(point);

      // Manually set light exposure
      //controller.setExposurePoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 4)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  String code;
  XFile image;
  final MenuCallback callback;
  bool isLoading = false;
  DisplayPictureScreen(
      {super.key,
      required this.imagePath,
      required this.code,
      required this.image,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    final bottomLayout = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width / 2 - 20,
      height: 58,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(15.0)),
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child:const Text('Hủy',
                style: TextStyle(color: Colors.white, fontSize: 16.0)),
          ),
          ElevatedButton(
            onPressed: () async {
              if(!isLoading) {
                isLoading = true;
                Get.dialog(const LoadingItem(size: 200));
                //  myHelper.customerRequest.listImage.add(imagePath);
                Uint8List bytes = await image.readAsBytes();
                var dataImage = dio.MultipartFile.fromBytes(
                  bytes,
                  filename: image.name,
                );
                dio.FormData data = dio.FormData.fromMap({'image': dataImage});
                await api.addImageToPoint({'point': code}, data).then((value) {
                  if (value.isNotEmpty) {
                    callback(value);
                    Get.back();
                    int count = 0;
                    Navigator.of(context).popUntil((_) {
                      return count++ >= 2;
                    });
                  }
                  isLoading = false;
                });
              }
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(15.0)),
              backgroundColor: MaterialStateProperty.all(const Color(0xFF00A560)),
            ),
            child:Text('Lưu',
                style: const TextStyle(color: Colors.white, fontSize: 16.0)),
          ),
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Xem trước'),
          backgroundColor: const Color(0xFF065CDA),
        ),
        body: Center(
            child: Container(
          padding: const EdgeInsets.all(10),
          child: Image.file(File(imagePath)),
        )),
        bottomNavigationBar:
            Padding(padding: const EdgeInsets.all(10), child: bottomLayout));
  }
}
