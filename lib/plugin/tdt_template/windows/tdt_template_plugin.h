#ifndef FLUTTER_PLUGIN_TDT_TEMPLATE_PLUGIN_H_
#define FLUTTER_PLUGIN_TDT_TEMPLATE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace tdt_template {

class TdtTemplatePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  TdtTemplatePlugin();

  virtual ~TdtTemplatePlugin();

  // Disallow copy and assign.
  TdtTemplatePlugin(const TdtTemplatePlugin&) = delete;
  TdtTemplatePlugin& operator=(const TdtTemplatePlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace tdt_template

#endif  // FLUTTER_PLUGIN_TDT_TEMPLATE_PLUGIN_H_
