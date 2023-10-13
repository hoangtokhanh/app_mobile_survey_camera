import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class ImageWidget extends StatelessWidget{
  final String image;
  final double ?height;
  final double ?width;
  const ImageWidget({Key? key, required this.image, this.height, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CachedNetworkImage(
      imageUrl: image,
      width: width,
      height: height,
      fit: BoxFit.contain,
      placeholder: (context, url) => const SpinKitThreeBounce(
        color: ThemeConfig.primaryColor,
        size: 20.0,
      ),
      errorWidget: (context, url, error) => const Icon(FeatherIcons.image,color: ThemeConfig.primaryColor),
    );
  }
}