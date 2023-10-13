import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:get/get.dart';

import '../template_web/data_table_report.dart';

class AppController extends GetxController {
  String errorLog = '';
  RxBool isLoading = false.obs;
  List<Map<String, dynamic>> reportData = [];
  final DataGridController dataGridController = DataGridController();

  List<int> listConfigPage = [50,20,10];

  String getMoneyFormat(dynamic money, {int precision = 0}) {
    double moneyFormat = 0.0;
    if (money == null) return '0';
    if (money is String)
      moneyFormat = double.parse(money);
    else if (money is int)
      moneyFormat = money * 1.0;
    else
      moneyFormat = money;

    String prefix = '';
    if (moneyFormat < 0) prefix = '-';

    var controller = MoneyMaskedTextController(
        decimalSeparator: (precision == 0) ? '' : ',', thousandSeparator: ',', precision: precision);

    controller.updateValue(moneyFormat);

    if (money == null) return '';
    return prefix + controller.text;
  }
}

final AppController appController = AppController();
