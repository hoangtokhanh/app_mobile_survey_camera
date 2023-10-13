import 'dart:async';
import 'package:tdt_template/model/reload_controller_model.dart';

import '';

class ReloadControllerStream {
  ReloadControllerModel value = ReloadControllerModel(data: []);
  StreamController listController =  StreamController<ReloadControllerModel>.broadcast();

  Stream get rebuildStream =>
      listController.stream.transform(rebuildTransformer);

  var rebuildTransformer =
  StreamTransformer<ReloadControllerModel, ReloadControllerModel>.fromHandlers(handleData: (data, sink) {
    sink.add(data);
  });

  void reloadData(ReloadControllerModel data) {
    value = data;
    listController.sink.add(data);
  }

  void dispose() {
    listController.close();
  }
}
