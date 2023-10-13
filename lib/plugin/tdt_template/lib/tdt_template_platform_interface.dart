import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tdt_template_method_channel.dart';

abstract class TdtTemplatePlatform extends PlatformInterface {
  /// Constructs a TdtTemplatePlatform.
  TdtTemplatePlatform() : super(token: _token);

  static final Object _token = Object();

  static TdtTemplatePlatform _instance = MethodChannelTdtTemplate();

  /// The default instance of [TdtTemplatePlatform] to use.
  ///
  /// Defaults to [MethodChannelTdtTemplate].
  static TdtTemplatePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TdtTemplatePlatform] when
  /// they register themselves.
  static set instance(TdtTemplatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
