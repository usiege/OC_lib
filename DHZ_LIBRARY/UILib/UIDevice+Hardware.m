/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 
 Modified by Eric Horacek for Monospace Ltd. on 2/4/13
 */

#include <sys/sysctl.h>
#import "UIDevice+Hardware.h"
#import <AVFoundation/AVFoundation.h>
@interface UIDevice (Hardward)

- (NSString *)modelNameForModelIdentifier:(NSString *)modelIdentifier;

@end

@implementation UIDevice (Hardware)

- (NSString *)getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *)modelIdentifier
{
    return [self getSysInfoByName:"hw.machine"];
}

- (NSString *)modelName
{
    return [self modelNameForModelIdentifier:[self modelIdentifier]];
}

- (NSString *)deviceString
{
//    UIDeviceiPhone4 = 10,
//    UIDeviceiPhone5 = 11,
//    UIDeviceiPhone5S = 31,
//    UIDeviceiPhone5C = 41,
//    UIDeviceiPhone6 = 12,
//    UIDeviceiPhone6p = 13,
//    UIDeviceIpad2 = 14,
//    UIDeviceIpad3 = 15,
//    UIDeviceIpad4 = 16,
//    UIDeviceIpadAir = 17,
//    UIDeviceIpadAir2 = 18,
//    UIDeviceIpadMini = 19,
//    UIDeviceIpadMini2 = 20,
//    UIDeviceIpadMini3 = 21,
//    UIDeviceUnknown = 0,
    NSString* deviceString = @"";
    UIDeviceName name = [self deviceName];
    switch (name) {
        case UIDeviceiPhone4:
            deviceString = @"iPhone4";
            break;
        case UIDeviceiPhone5:
            deviceString = @"iPhone5";
            break;
        case UIDeviceiPhone5S:
            deviceString = @"iPhone5S";
            break;
        case UIDeviceiPhone5C:
            deviceString = @"iPhone5C";
            break;
        case UIDeviceiPhone6:
            deviceString = @"iPhone6";
            break;
        case UIDeviceiPhone6p:
            deviceString = @"iPhone6 plus";
            break;
        case UIDeviceIpad2:
            deviceString = @"iPad2";
            break;
        case UIDeviceIpad3:
            deviceString = @"iPad3";
            break;
        case UIDeviceIpad4:
            deviceString = @"iPad4";
            break;
        case UIDeviceIpadAir:
            deviceString = @"iPad Air";
            break;
        case UIDeviceIpadAir2:
            deviceString = @"iPad Air2";
            break;
        case UIDeviceIpadMini:
            deviceString = @"iPad mini";
            break;
        case UIDeviceIpadMini2:
            deviceString = @"iPad mini2";
            break;
        case UIDeviceIpadMini3:
            deviceString = @"iPad mini3";
            break;
        case UIDeviceUnknown:
            deviceString = @"unknown";
            break;
        default:
            break;
    }
    return deviceString;
}

- (UIDeviceName)deviceName
{
    NSString *modelIdentifier = [self modelIdentifier];
    if ([modelIdentifier isEqualToString:@"iPhone3,1"])    return UIDeviceiPhone4;
    if ([modelIdentifier isEqualToString:@"iPhone3,2"])    return UIDeviceiPhone4;
    if ([modelIdentifier isEqualToString:@"iPhone3,3"])    return UIDeviceiPhone4;
    if ([modelIdentifier isEqualToString:@"iPhone4,1"])    return UIDeviceiPhone4;
    if ([modelIdentifier isEqualToString:@"iPhone5,1"])    return UIDeviceiPhone5;
    if ([modelIdentifier isEqualToString:@"iPhone5,2"])    return UIDeviceiPhone5;
    if ([modelIdentifier isEqualToString:@"iPhone5,3"])    return UIDeviceiPhone5C;
    if ([modelIdentifier isEqualToString:@"iPhone5,4"])    return UIDeviceiPhone5C;
    if ([modelIdentifier isEqualToString:@"iPhone6,1"])    return UIDeviceiPhone5S;
    if ([modelIdentifier isEqualToString:@"iPhone6,2"])    return UIDeviceiPhone5S;
    if ([modelIdentifier isEqualToString:@"iPhone7,1"])    return UIDeviceiPhone6p;
    if ([modelIdentifier isEqualToString:@"iPhone7,2"])    return UIDeviceiPhone6;
    
    if ([modelIdentifier isEqualToString:@"iPad2,1"])      return UIDeviceIpad2;
    if ([modelIdentifier isEqualToString:@"iPad2,2"])      return UIDeviceIpad2;
    if ([modelIdentifier isEqualToString:@"iPad2,3"])      return UIDeviceIpad2;
    if ([modelIdentifier isEqualToString:@"iPad2,4"])      return UIDeviceIpad2;
    if ([modelIdentifier isEqualToString:@"iPad3,1"])      return UIDeviceIpad3;
    if ([modelIdentifier isEqualToString:@"iPad3,2"])      return UIDeviceIpad3;
    if ([modelIdentifier isEqualToString:@"iPad3,3"])      return UIDeviceIpad3;
    if ([modelIdentifier isEqualToString:@"iPad3,4"])      return UIDeviceIpad4;
    if ([modelIdentifier isEqualToString:@"iPad3,5"])      return UIDeviceIpad4;
    if ([modelIdentifier isEqualToString:@"iPad3,6"])      return UIDeviceIpad4;
    
    if ([modelIdentifier isEqualToString:@"iPad4,1"])      return UIDeviceIpadAir;
    if ([modelIdentifier isEqualToString:@"iPad4,2"])      return UIDeviceIpadAir;
    if ([modelIdentifier isEqualToString:@"iPad5,3"])      return UIDeviceIpadAir2;
    if ([modelIdentifier isEqualToString:@"iPad5,4"])      return UIDeviceIpadAir2;
    
    // iPad Mini http://theiphonewiki.com/wiki/IPad_mini
    
    if ([modelIdentifier isEqualToString:@"iPad2,5"])      return UIDeviceIpadMini;
    if ([modelIdentifier isEqualToString:@"iPad2,6"])      return UIDeviceIpadMini;
    if ([modelIdentifier isEqualToString:@"iPad2,7"])      return UIDeviceIpadMini;
    if ([modelIdentifier isEqualToString:@"iPad4,4"])      return UIDeviceIpadMini2;
    if ([modelIdentifier isEqualToString:@"iPad4,5"])      return UIDeviceIpadMini2;
    if ([modelIdentifier isEqualToString:@"iPad4,7"])      return UIDeviceIpadMini3;
    if ([modelIdentifier isEqualToString:@"iPad4,8"])      return UIDeviceIpadMini3;
    if ([modelIdentifier isEqualToString:@"iPad4,9"])      return UIDeviceIpadMini3;
    
    return UIDeviceUnknown;
}

- (NSString *)modelNameForModelIdentifier:(NSString *)modelIdentifier
{
    // iPhone http://theiphonewiki.com/wiki/IPhone
    
    if ([modelIdentifier isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([modelIdentifier isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([modelIdentifier isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([modelIdentifier isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([modelIdentifier isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev A)";
    if ([modelIdentifier isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([modelIdentifier isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([modelIdentifier isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([modelIdentifier isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (Global)";
    if ([modelIdentifier isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([modelIdentifier isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (Global)";
    if ([modelIdentifier isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([modelIdentifier isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (Global)";
    if ([modelIdentifier isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([modelIdentifier isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    // iPad http://theiphonewiki.com/wiki/IPad
    
    if ([modelIdentifier isEqualToString:@"iPad1,1"])      return @"iPad 1G";
    if ([modelIdentifier isEqualToString:@"iPad2,1"])      return @"iPad 2 (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([modelIdentifier isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([modelIdentifier isEqualToString:@"iPad2,4"])      return @"iPad 2 (Rev A)";
    if ([modelIdentifier isEqualToString:@"iPad3,1"])      return @"iPad 3 (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM)";
    if ([modelIdentifier isEqualToString:@"iPad3,3"])      return @"iPad 3 (Global)";
    if ([modelIdentifier isEqualToString:@"iPad3,4"])      return @"iPad 4 (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([modelIdentifier isEqualToString:@"iPad3,6"])      return @"iPad 4 (Global)";
    
    if ([modelIdentifier isEqualToString:@"iPad4,1"])      return @"iPad Air (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([modelIdentifier isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    
    // iPad Mini http://theiphonewiki.com/wiki/IPad_mini
    
    if ([modelIdentifier isEqualToString:@"iPad2,5"])      return @"iPad mini 1G (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad2,6"])      return @"iPad mini 1G (GSM)";
    if ([modelIdentifier isEqualToString:@"iPad2,7"])      return @"iPad mini 1G (Global)";
    if ([modelIdentifier isEqualToString:@"iPad4,4"])      return @"iPad mini 2G (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad4,5"])      return @"iPad mini 2G (Cellular)";
    if ([modelIdentifier isEqualToString:@"iPad4,7"])      return @"iPad mini 3G (Wi-Fi)";
    if ([modelIdentifier isEqualToString:@"iPad4,8"])      return @"iPad mini 3G (Cellular)";
    if ([modelIdentifier isEqualToString:@"iPad4,9"])      return @"iPad mini 3G (Cellular)";
    
    // iPod http://theiphonewiki.com/wiki/IPod
    
    if ([modelIdentifier isEqualToString:@"iPod1,1"])      return @"iPod touch 1G";
    if ([modelIdentifier isEqualToString:@"iPod2,1"])      return @"iPod touch 2G";
    if ([modelIdentifier isEqualToString:@"iPod3,1"])      return @"iPod touch 3G";
    if ([modelIdentifier isEqualToString:@"iPod4,1"])      return @"iPod touch 4G";
    if ([modelIdentifier isEqualToString:@"iPod5,1"])      return @"iPod touch 5G";
    
    // Simulator
    if ([modelIdentifier hasSuffix:@"86"] || [modelIdentifier isEqual:@"x86_64"])
    {
        BOOL smallerScreen = ([[UIScreen mainScreen] bounds].size.width < 768.0);
        return (smallerScreen ? @"iPhone Simulator" : @"iPad Simulator");
    }
    
    return modelIdentifier;
}

- (UIDeviceFamily) deviceFamily
{
    NSString *modelIdentifier = [self modelIdentifier];
    if ([modelIdentifier hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([modelIdentifier hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([modelIdentifier hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    return UIDeviceFamilyUnknown;
}


- (NSDictionary *)getDeviceParameters
{
    NSDictionary *dictionary = nil;
    UIDeviceName device = [[UIDevice currentDevice] deviceName];
    switch (device) {
        case UIDeviceiPhone5:
        {
            dictionary = @{VLC_ISO:@"800",
                           TIME_SCALE:@"30000",
                           VLC_FPS:@"20",
                           SESSION_PRESET:AVCaptureSessionPreset1280x720};
            break;
        }
        case UIDeviceiPhone5S:
        {
            dictionary = @{VLC_ISO:@"1500",
                           TIME_SCALE:@"30000",
                           VLC_FPS:@"20",
                           SESSION_PRESET:AVCaptureSessionPreset1280x720};
            break;
        }
        case UIDeviceiPhone5C:
        {
            dictionary = @{VLC_ISO:@"1500",//135 400
                           TIME_SCALE:@"30000",//32000
                           VLC_FPS:@"20",
                           SESSION_PRESET:AVCaptureSessionPreset1280x720};
            break;
        }
        case UIDeviceiPhone6:
        {
            dictionary = @{VLC_ISO:@"200",
                           TIME_SCALE:@"32000",
                           VLC_FPS:@"30",
                           SESSION_PRESET:AVCaptureSessionPreset1280x720};
            break;
        }
        case UIDeviceiPhone6p:
        {
            dictionary = @{VLC_ISO:@"500",
                           TIME_SCALE:@"30000",
                           VLC_FPS:@"30",
                           SESSION_PRESET:AVCaptureSessionPreset1280x720};
            break;
        }
        case UIDeviceIpadMini:
        {
            dictionary = @{VLC_ISO:@"100",
                           TIME_SCALE:@"30000",
                           VLC_FPS:@"30",
                           SESSION_PRESET:AVCaptureSessionPreset640x480};
            break;
        }
        case UIDeviceIpadMini2:
        {
            dictionary = @{VLC_ISO:@"800",
                           TIME_SCALE:@"30000",
                           VLC_FPS:@"20",
                           SESSION_PRESET:AVCaptureSessionPreset1280x720};
            break;
        }
        default:
            break;
    }
    return dictionary;
}

- (NSDictionary *)getLocatorParameters
{
    NSDictionary *dictionary = nil;
    UIDeviceName device = [[UIDevice currentDevice] deviceName];
    switch (device) {
        case UIDeviceIpadMini2:
        {
            dictionary = @{@"CAMERA_FOCAL_X_LENGHT":@"1152",
                           @"CAMERA_FOCAL_Y_LENGHT":@"1152",
                           @"CAMERA_CENTER_X":@"640",
                           @"CAMERA_CENTER_Y":@"390",
                           @"CAMERA_BAND_MIN":@"1",
                           @"CAMERA_BAND_MAX":@"2",
                           @"CAMERA_BAND_FIX":@"1.660714",
			   };
            break;
        }
        case UIDeviceIpadMini:
        {
            dictionary = @{@"CAMERA_FOCAL_X_LENGHT":@"621.7",
                           @"CAMERA_FOCAL_Y_LENGHT":@"621.7",
                           @"CAMERA_CENTER_X":@"315",
                           @"CAMERA_CENTER_Y":@"227",
                           @"CAMERA_BAND_MIN":@"1",
                           @"CAMERA_BAND_MAX":@"2",
                           @"CAMERA_BAND_FIX":@"1.285714"};
            break;
        }
        case UIDeviceiPhone5:
        {
            dictionary = @{@"CAMERA_FOCAL_X_LENGHT":@"1079.6",
                           @"CAMERA_FOCAL_Y_LENGHT":@"1079.6",
                           @"CAMERA_CENTER_X":@"665",
                           @"CAMERA_CENTER_Y":@"340",
                           @"CAMERA_BAND_MIN":@"1",
                           @"CAMERA_BAND_MAX":@"2",
                           @"CAMERA_BAND_FIX":@"1.607143"
                           };
            break;
        }
        case UIDeviceiPhone5C:
        {
            dictionary = @{@"CAMERA_FOCAL_X_LENGHT":@"1079.6",
                           @"CAMERA_FOCAL_Y_LENGHT":@"1079.6",
                           @"CAMERA_CENTER_X":@"610",
                           @"CAMERA_CENTER_Y":@"340",
                           @"CAMERA_BAND_MIN":@"1",
                           @"CAMERA_BAND_MAX":@"2",
                           @"CAMERA_BAND_FIX":@"1.535714"
                           };
            break;
        }  case UIDeviceiPhone5S:
        {
            dictionary = @{@"CAMERA_FOCAL_X_LENGHT":@"1079.6",
                           @"CAMERA_FOCAL_Y_LENGHT":@"1079.6",
                           @"CAMERA_CENTER_X":@"610",
                           @"CAMERA_CENTER_Y":@"340",
                           @"CAMERA_BAND_MIN":@"1",
                           @"CAMERA_BAND_MAX":@"2",
                           @"CAMERA_BAND_FIX":@"1.5"};
            break;
        }
        case UIDeviceiPhone6:
        {
            dictionary = @{@"CAMERA_FOCAL_X_LENGHT":@"1123",
                           @"CAMERA_FOCAL_Y_LENGHT":@"1123",
                           @"CAMERA_CENTER_X":@"650 ",
                           @"CAMERA_CENTER_Y":@"370",
                           @"CAMERA_BAND_MIN":@"3",
                           @"CAMERA_BAND_MAX":@"4",
                           @"CAMERA_BAND_FIX":@"3.446429"
                           };
            break;
        }
        case UIDeviceiPhone6p:
        {
            dictionary = @{@"CAMERA_FOCAL_X_LENGHT":@"1093.4",
                           @"CAMERA_FOCAL_Y_LENGHT":@"1093.4",
                           @"CAMERA_CENTER_X":@"650 ",
                           @"CAMERA_CENTER_Y":@"370",
                           @"CAMERA_BAND_MIN":@"3",
                           @"CAMERA_BAND_MAX":@"4",
                           @"CAMERA_BAND_FIX":@"3.428571",
                           };
            break;
        }
        default:
            break;
    }
    return dictionary;
}

@end
