import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tdt_template_platform_interface.dart';

/// An implementation of [TdtTemplatePlatform] that uses method channels.
class MethodChannelTdtTemplate extends TdtTemplatePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tdt_template');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
