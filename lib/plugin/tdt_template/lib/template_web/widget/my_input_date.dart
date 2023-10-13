import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/app_config.dart';
import '../../../../config/theme_config.dart';
import '../../controller/controller.dart';

class MyInputDate extends StatefulWidget {
  late TextEditingController controller;
  late DateTime date;
  final String label;
  final String? hintText;
  final MenuCallback functionCallBack;
  final EdgeInsets? padding;
  final String type;

  MyInputDate(
      {Key? key,
      required this.controller,
      required this.date,
      required this.functionCallBack,
      this.label = '',
      this.padding,
      this.type = 'date',
      this.hintText})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyInputDateState();
}

class _MyInputDateState extends State<MyInputDate> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: widget.date, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != widget.date) {
      setState(() {
        widget.date = picked;
        widget.controller.text = DateFormat(AppConfig.DATE_SERVER_FOMAT).format(picked);
        widget.functionCallBack(widget.date);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });
    if (pickedTime != null) {
      //output 10:51 PM
      setState(() {
        widget.controller.text = formatTimeOfDay(pickedTime); //set the value of text field.
      });
    } else {
      print("Time is not selected");
    }
    widget.functionCallBack(widget.date);
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat('HH:mm:ss').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.type == 'date' ? _selectDate(context) : _selectTime(context),
      child: Container(
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                  color: ThemeConfig.textColor, fontSize: ThemeConfig.defaultSize, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              style: TextStyle(fontSize: ThemeConfig.defaultSize, fontWeight: FontWeight.bold),
              controller: widget.controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: ThemeConfig.whiteColor,
                enabled: false,
                hintStyle: TextStyle(fontSize: ThemeConfig.labelSize),
                hintText: widget.type == 'date' ? 'Chọn ngày' : 'Chọn thời gian',
                suffixIcon: Icon(widget.type == 'date' ? Icons.calendar_today : Icons.access_time),
                contentPadding: ThemeConfig.contentPadding,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: ThemeConfig.blackColor.withOpacity(0.5))),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: ThemeConfig.blackColor.withOpacity(0.5))),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: ThemeConfig.blackColor.withOpacity(0.5))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
