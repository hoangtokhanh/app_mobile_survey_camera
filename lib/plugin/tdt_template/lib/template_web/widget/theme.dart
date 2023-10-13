import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme_config.dart';
import 'loading_screen.dart';

class MyTheme extends StatelessWidget {
  final Widget body;
  final Widget? header;
  final Widget? action;
  final Widget? leading;
  final Widget? background;
  final Widget? onTop;
  final RxBool isLoading;
  final Color? backgroundColor;

  const MyTheme(
      {Key? key,
      this.backgroundColor,
      this.onTop,
      required this.body,
      this.header,
      required this.isLoading,
      this.background,
      this.leading,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            body,
            Obx(() => _buildStateLoading()),
          ],
        ),
      ),
    );
  }

  Widget _buildStateLoading() {
    return isLoading.value
        ? Opacity(
            opacity: 0.3,
            child: Container(
              width: Get.width,
              height: Get.height,
              color: ThemeConfig.backgroundColor,
              child: const Center(
                child: LoadingScreen(),
              ),
            ),
          )
        : Container();
  }

  Widget _buildMain() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: body),
      ],
    );
  }
}
