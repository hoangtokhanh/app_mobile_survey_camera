import 'package:flutter/material.dart';
import '../../../../config/theme_config.dart';

class CustomScaffold extends StatefulWidget {
  final Widget body;
  final AppBar? appbar;
  final bottomNavigationBar;
  final floatingActionButtonLocation;
  final floatingActionButton;

  const CustomScaffold(
      {Key? key,
      required this.body,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.appbar})
      : super(key: key);

  @override
  _CustomScaffoldScreen createState() => _CustomScaffoldScreen();
}

class _CustomScaffoldScreen extends State<CustomScaffold> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: widget.appbar,
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButton: widget.floatingActionButton,
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding, vertical: 10),
          child: Stack(
            children: [
              widget.body,
            ],
          ),
        )),
      ),
    );
  }
}
