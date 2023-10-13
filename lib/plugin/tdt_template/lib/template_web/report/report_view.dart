import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdt_template/template_web/report/template_report.dart';
import '../../../../controller/report_controller.dart';
import 'header.dart';

class MyReportView extends StatelessWidget {
  MyReportView({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ReportController controller;
  final RxBool isEdit = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListViewHeaderReport(
            callback: (param) {
              if (param != true) {
                isEdit.value = param['is_edit'];
              }
            },
            controller: controller,
          ),
          Expanded(
              child: Obx(() => TemplateReport(
                    isEdit: isEdit.value,
                    controller: controller,
                  ))),
        ],
      ),
      // floatingActionButton: _buildActionButton(context),
    );
  }
}
