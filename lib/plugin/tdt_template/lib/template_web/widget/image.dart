import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tdt_template/config/theme_config.dart';

class ImageWidget extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double borderRadius;
  final Color? color;
  final double? borderWidth;

  const ImageWidget(
      {Key? key,
      required this.url,
      this.height = 30,
      this.width = 30,
      this.borderRadius = 30,
      this.color,
      this.borderWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: color ?? ThemeConfig.backgroundColor, width: borderWidth ?? 2)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: url.isNotEmpty
              ? url.contains('asset')
                  ? Image.asset(url, width: width, height: height, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: url,
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => SpinKitThreeBounce(
                        color: ThemeConfig.textColor,
                        size: 10.0,
                      ),
                      errorWidget: (context, url, error) {
                        print(error.toString());
                        print(url);
                        return Container(
                            decoration: BoxDecoration(
                                color: ThemeConfig.textColor, borderRadius: BorderRadius.circular(width)));
                      },
                    )
              : Container(
                  decoration: BoxDecoration(color: ThemeConfig.textColor, borderRadius: BorderRadius.circular(width)),
                  width: width,
                  height: height,
                ),
        ));
  }
}
