#import "TdtTemplatePlugin.h"
#if __has_include(<tdt_template/tdt_template-Swift.h>)
#import <tdt_template/tdt_template-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tdt_template-Swift.h"
#endif

@implementation TdtTemplatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTdtTemplatePlugin registerWithRegistrar:registrar];
}
@end
