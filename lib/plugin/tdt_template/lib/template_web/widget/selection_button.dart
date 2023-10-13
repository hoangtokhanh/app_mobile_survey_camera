import 'package:flutter/material.dart';
import '../../../../../config/theme_config.dart';
import '../../controller/controller.dart';

class SelectionButtonCustom extends StatefulWidget {
  final List<String> data;
  late String value;
  final String title;
  final padding;
  final String prefix;
  final MenuCallback setItem;
  final String hintext;
  final bool validator;
  final bool isReload;

  SelectionButtonCustom(
      {Key? key,
      this.isReload = false,
      this.validator = true,
      this.hintext = '',
      this.prefix = '',
      this.title = '',
      this.padding,
      required this.value,
      required this.data,
      required this.setItem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SelectionButtonCustomState();
}

class SelectionButtonCustomState extends State<SelectionButtonCustom> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.padding ?? EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: TextStyle(
                    color: ThemeConfig.textColor, fontSize: ThemeConfig.smallSize, fontWeight: FontWeight.bold)),
            widget.isReload
                ? DropdownButtonFormField(
                    validator: (value) {
                      if ((value == null || value == '') && widget.validator) {
                        return 'Vui lòng điền thông tin';
                      }
                      return null;
                    },
                    value: widget.value,
                    isExpanded: true,
                    hint: Text(
                      widget.hintext,
                      style: TextStyle(fontSize: ThemeConfig.labelSize),
                    ),
                    decoration: InputDecoration(
                      errorMaxLines: 1,
                      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
                      hintText: 'Chọn',
                      contentPadding: ThemeConfig.contentPadding,
                      hintStyle: TextStyle(color: ThemeConfig.greyColor, fontSize: ThemeConfig.labelSize),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.redAccent)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: ThemeConfig.greyColor)),
                    ),
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.value = newValue!;
                        widget.setItem(newValue);
                      });
                    },
                    items: widget.data.map((String _value) {
                      return DropdownMenuItem<String>(
                        value: _value,
                        child: Text(
                          _value != '' ? '${widget.prefix}$_value' : _value,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : DropdownButtonFormField(
                    validator: (value) {
                      if ((value == null || value == '') && widget.validator) {
                        return 'Vui lòng điền thông tin';
                      }
                      return null;
                    },
                    isExpanded: true,
                    hint: Text(
                      widget.hintext,
                      style: TextStyle(fontSize: ThemeConfig.labelSize),
                    ),
                    decoration: InputDecoration(
                      errorMaxLines: 1,
                      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
                      hintText: 'Chọn',
                      contentPadding: ThemeConfig.contentPadding,
                      hintStyle: TextStyle(color: ThemeConfig.greyColor, fontSize: ThemeConfig.labelSize),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.redAccent)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: ThemeConfig.greyColor)),
                    ),
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.value = newValue!;
                        widget.setItem(newValue);
                      });
                    },
                    items: widget.data.map((String _value) {
                      return DropdownMenuItem<String>(
                        value: _value,
                        child: Text(
                          _value != '' ? '${widget.prefix}$_value' : _value,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ));
  }
}
