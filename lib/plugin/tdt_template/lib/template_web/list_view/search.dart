import 'package:flutter/material.dart';
import '../../../../config/theme_config.dart';
import '../../controller/controller.dart';

class SearchListView extends StatelessWidget {
  final MenuCallback callback;

  SearchListView({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildSearch();
  }

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ThemeConfig.defaultPadding / 2),
      child: TextField(
        onChanged: (value) {
          callback(value);
        },
        style: TextStyle(fontSize: ThemeConfig.defaultSize),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          contentPadding: ThemeConfig.contentPadding,
          counter: Container(),
          hintText: 'Search...',
          hintStyle: TextStyle(color: ThemeConfig.greyColor, fontSize: ThemeConfig.smallSize),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.redAccent)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: ThemeConfig.greyColor)),
        ),
      ),
    );
  }
}
