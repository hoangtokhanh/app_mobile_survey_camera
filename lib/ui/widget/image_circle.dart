import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/material.dart';

class ImageCircle extends StatelessWidget{
  final String image;
  final double size;
  const ImageCircle({Key? key, required this.image,required this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: ThemeConfig.secondColor,
          borderRadius: BorderRadius.circular(size),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size),
          child: image.isNotEmpty?CachedNetworkImage(
            imageUrl: image,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
                padding: const EdgeInsets.all(5),
                width: size,
                height: size,
                child: const SpinKitThreeBounce(
                  color: ThemeConfig.primaryColor,
                  size: 20.0,
                )),
            errorWidget: (context, url, error) => Icon(FeatherIcons.image,color: ThemeConfig.whiteColor,size: ThemeConfig.defaultSize,),
          ): Icon(FeatherIcons.image,color: ThemeConfig.whiteColor,size: ThemeConfig.defaultSize,),
        )
    );
  }
}