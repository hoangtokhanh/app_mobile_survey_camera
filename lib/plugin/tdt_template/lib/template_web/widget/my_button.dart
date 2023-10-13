import 'package:flutter/material.dart';

import '../../../../config/theme_config.dart';

class MyButton extends StatefulWidget {
  final double? width;
  final double? height;
  final Color? color;
  final border;
  final padding;
  final margin;
  final childWidget;
  final callback;
  final double borderRadius;
  final bool validate;
  final bool isLoading;
  final bool isCompleted;

  const MyButton(
      {Key? key,
      this.callback,
      this.width,
      this.color,
      this.height,
      this.padding,
      this.margin,
      this.childWidget,
      this.validate = false,
      this.isLoading = false,
      this.isCompleted = false,
      this.border,
      this.borderRadius = 0})
      : super(key: key);

  @override
  MyButtonState createState() => MyButtonState();
}

class MyButtonState extends State<MyButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: widget.validate ? widget.callback : () {},
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: (widget.isLoading || widget.isCompleted) ? 50 : widget.width,
          height: widget.height,
          margin: widget.margin,
          padding: widget.padding,
          decoration: BoxDecoration(
              border: widget.border ?? Border.all(color: widget.color ?? Colors.transparent, width: 0),
              color: (widget.validate || widget.isCompleted) ? widget.color ?? ThemeConfig.primaryColor : widget.color,
              borderRadius: BorderRadius.circular(widget.borderRadius)),
          child: Center(
            child: !widget.isLoading
                ? !widget.isCompleted
                    ? widget.childWidget
                    : const Center(
                        child: Icon(
                          Icons.check,
                          size: 30,
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(
                    strokeWidth: 5,
                    color: ThemeConfig.whiteColor,
                  )),
          )),
    );
  }
}
