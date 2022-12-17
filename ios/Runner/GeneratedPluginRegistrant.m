//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<device_info_plus/FLTDeviceInfoPlusPlugin.h>)
#import <device_info_plus/FLTDeviceInfoPlusPlugin.h>
#else
@import device_info_plus;
#endif

#if __has_include(<device_information/DeviceInformationPlugin.h>)
#import <device_information/DeviceInformationPlugin.h>
#else
@import device_information;
#endif

#if __has_include(<flutter_barometer/FlutterBarometerPlugin.h>)
#import <flutter_barometer/FlutterBarometerPlugin.h>
#else
@import flutter_barometer;
#endif

#if __has_include(<permission_handler_apple/PermissionHandlerPlugin.h>)
#import <permission_handler_apple/PermissionHandlerPlugin.h>
#else
@import permission_handler_apple;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTDeviceInfoPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTDeviceInfoPlusPlugin"]];
  [DeviceInformationPlugin registerWithRegistrar:[registry registrarForPlugin:@"DeviceInformationPlugin"]];
  [FlutterBarometerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBarometerPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
}

@end
