import 'package:app_mobile_survey_camera/all_file.dart';
import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget{
  final TextEditingController ?controller;
  final String title;
  final bool password;
  final int maxLine;
  final String ?initValue;
  final MenuCallback ?callback;
  final TextInputType type;
  final bool readOnly;
  const MyTextField({super.key, this.controller, required this.title,this.password = false,this.callback,this.maxLine = 1,this.type = TextInputType.text, this.initValue,this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ThemeConfig.defaultPadding/2,horizontal: ThemeConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyCustomText(
            text:title,
            style: ThemeConfig.defaultStyle,
          ),
          SizedBox(
            height: 48,
            child: TextFormField(
              readOnly: readOnly,
              initialValue: initValue,
              minLines: maxLine,
              maxLines: maxLine,
              keyboardType: type,
              onChanged: (value){
                if(callback != null){
                  callback!(value);
                }
              },
              style: ThemeConfig.defaultStyle,
              controller: controller,
              obscureText: password,
              decoration: InputDecoration(
                filled: readOnly,
                fillColor: ThemeConfig.greyColor.withOpacity(0.5),
                border: const OutlineInputBorder(),
                hintText: title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}