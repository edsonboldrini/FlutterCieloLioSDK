#import "FlutterCieloLioSdkPlugin.h"
#if __has_include(<flutter_cielo_lio_sdk/flutter_cielo_lio_sdk-Swift.h>)
#import <flutter_cielo_lio_sdk/flutter_cielo_lio_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_cielo_lio_sdk-Swift.h"
#endif

@implementation FlutterCieloLioSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterCieloLioSdkPlugin registerWithRegistrar:registrar];
}
@end
