#include "include/tdt_template/tdt_template_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "tdt_template_plugin.h"

void TdtTemplatePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  tdt_template::TdtTemplatePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
