#import "DeviceSpacePlugin.h"
#if __has_include(<device_space/device_space-Swift.h>)
#import <device_space/device_space-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "device_space-Swift.h"
#endif

@implementation DeviceSpacePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeviceSpacePlugin registerWithRegistrar:registrar];
}
@end
