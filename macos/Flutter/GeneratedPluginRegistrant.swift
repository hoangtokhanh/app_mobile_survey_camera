//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import file_saver
import file_selector_macos
import geolocator_apple
import path_provider_foundation
import shared_preferences_foundation
import sqflite
import tdt_template

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FileSaverPlugin.register(with: registry.registrar(forPlugin: "FileSaverPlugin"))
  FileSelectorPlugin.register(with: registry.registrar(forPlugin: "FileSelectorPlugin"))
  GeolocatorPlugin.register(with: registry.registrar(forPlugin: "GeolocatorPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  TdtTemplatePlugin.register(with: registry.registrar(forPlugin: "TdtTemplatePlugin"))
}
