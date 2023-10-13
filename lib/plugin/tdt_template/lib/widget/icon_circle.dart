import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import '../config/theme_config.dart';

class IconCircle extends StatelessWidget {
  final Color color;
  final String icon;
  final double? size;
  final Color? colorIcon;

  const IconCircle({Key? key, required this.color, required this.icon, this.size, this.colorIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.all(ThemeConfig.defaultPadding / 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: CachedNetworkImage(
          imageUrl: icon,
          width: size ?? 30,
          height: size ?? 30,
          color: colorIcon ?? ThemeConfig.whiteColor,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            padding: const EdgeInsets.all(5),
            width: size ?? 30,
            height: 30,
            child: const SizedBox(),
          ),
          errorWidget: (context, url, error) => Container(
              color: color,
              padding: const EdgeInsets.all(5),
              width: size ?? 30,
              height: size ?? 30,
              child: Image.asset(
                'assets/images/sun.png',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                color: colorIcon ?? ThemeConfig.whiteColor,
              )),
        ));
  }
}
