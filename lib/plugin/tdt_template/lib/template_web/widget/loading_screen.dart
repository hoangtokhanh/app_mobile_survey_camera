import 'dart:math';
import 'package:flutter/material.dart';

import '../../config/theme_config.dart';

class LoadingScreen extends StatefulWidget {
  final double? height;
  final double? width;
  final Color? primaryColor;
  final Color? secondColor;

  const LoadingScreen({Key? key, this.height, this.width, this.primaryColor, this.secondColor}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  double circle1 = 10;
  double circle2 = 20;
  late AnimationController _controller;
  late AnimationController _rotationController;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _rotation;
  late double radius;

  @override
  void initState() {
    super.initState();
    radius = widget.width ?? 40;
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this)..repeat(reverse: true);
    _controller.forward();

    _animation1 = Tween<double>(begin: 0, end: 1).animate(_controller);

    _animation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _animation2 = Tween<double>(begin: 1, end: 0).animate(_controller);

    _animation2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _rotationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _rotation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _rotationController, curve: const Interval(0, 1, curve: Curves.linear)));
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: RotationTransition(
          turns: _rotation,
          child: Center(
            child: Stack(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //       color: ThemeConfig.whiteColor,
                //       borderRadius: BorderRadius.all(Radius.circular(getSize(widget.width??40),))
                //   ),
                //   width: getSize(widget.width??40),
                //   height: getSize(widget.width??40),
                // ),
                Transform.translate(
                  offset: Offset((radius / 2) * cos(pi / 2), (radius / 2) * sin(-pi / 2)),
                  child: ScaleTransition(
                    scale: _animation1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget.primaryColor ?? ThemeConfig.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(
                            (widget.width ?? 40),
                          ))),
                      width: (widget.width ?? 40),
                      height: (widget.width ?? 40),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset((radius / 2) * cos(pi), (radius / 2) * sin(pi)),
                  child: ScaleTransition(
                    scale: _animation2,
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget.secondColor ?? ThemeConfig.secondColor,
                          borderRadius: BorderRadius.all(Radius.circular(
                            (widget.width ?? 40),
                          ))),
                      width: (widget.width ?? 40),
                      height: (widget.width ?? 40),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
