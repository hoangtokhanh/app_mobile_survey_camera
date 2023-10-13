import 'tdt_template_platform_interface.dart';
export 'model/template/template_model.dart';
export 'template_web/list_view/list_view.dart';
export 'template_web/fields/parent_field.dart';
export 'controller/component_config.dart';
export 'controller/reload_controller.dart';
export 'model/reload_controller_model.dart';
export 'template_web/fields/field.dart';
export 'template_web/widget/selection_button_2.dart';
export 'config/list_string_config.dart';
export 'widget/custom_text.dart';
export 'widget/MyWidget.dart';
export 'widget/icon_circle.dart';
export 'template_web/widget/loading_item.dart';
export 'template_web/widget/custom_dialog.dart';
export 'template_web/import.dart';
class TdtTemplate {
  Future<String?> getPlatformVersion() {
    return TdtTemplatePlatform.instance.getPlatformVersion();
  }
}
