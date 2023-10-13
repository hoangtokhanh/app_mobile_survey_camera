
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config/theme_config.dart';
class CustomDialog extends StatelessWidget {
  final List<Widget> children;
  const CustomDialog({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding/2),
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child:  Container(
            width: MediaQuery.of(context).size.width*0.8,
            padding: EdgeInsets.all(ThemeConfig.defaultPadding),
            child: Row(
              children: [
                Flexible(child: Column(
                  children: children,
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
