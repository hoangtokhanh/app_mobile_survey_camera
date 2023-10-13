import 'package:flutter_test/flutter_test.dart';
import 'package:tdt_template/tdt_template.dart';
import 'package:tdt_template/tdt_template_platform_interface.dart';
import 'package:tdt_template/tdt_template_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTdtTemplatePlatform 
    with MockPlatformInterfaceMixin
    implements TdtTemplatePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TdtTemplatePlatform initialPlatform = TdtTemplatePlatform.instance;

  test('$MethodChannelTdtTemplate is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTdtTemplate>());
  });

  test('getPlatformVersion', () async {
    TdtTemplate tdtTemplatePlugin = TdtTemplate();
    MockTdtTemplatePlatform fakePlatform = MockTdtTemplatePlatform();
    TdtTemplatePlatform.instance = fakePlatform;
  
    expect(await tdtTemplatePlugin.getPlatformVersion(), '42');
  });
}
