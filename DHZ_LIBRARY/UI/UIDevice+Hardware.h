/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 
 Modified by Eric Horacek for Monospace Ltd. on 2/4/13
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIDeviceFamily) {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
};

typedef enum {
    UIDeviceiPhone4 = 10,
    UIDeviceiPhone5 = 11,
    UIDeviceiPhone5S = 31,
    UIDeviceiPhone5C = 41,
    UIDeviceiPhone6 = 12,
    UIDeviceiPhone6p = 13,
    UIDeviceIpad2 = 14,
    UIDeviceIpad3 = 15,
    UIDeviceIpad4 = 16,
    UIDeviceIpadAir = 17,
    UIDeviceIpadAir2 = 18,
    UIDeviceIpadMini = 19,
    UIDeviceIpadMini2 = 20,
    UIDeviceIpadMini3 = 21,
    UIDeviceUnknown = 0,
}UIDeviceName;

#define VLC_ISO @"iso"
#define VLC_FPS @"fps"
#define TIME_SCALE @"timescale"
#define SESSION_PRESET @"sessionPreset"

@interface UIDevice (Hardware)

/**
 Returns a machine-readable model name in the format of "iPhone4,1"
 */
- (NSString *)modelIdentifier;

/**
 Returns a human-readable model name in the format of "iPhone 4S". Fallback of the the `modelIdentifier` value.
 */
- (NSString *)modelName;

/**
 Returns the device family as a `UIDeviceFamily`
 */
- (UIDeviceFamily)deviceFamily;

- (UIDeviceName)deviceName;

- (NSString *)deviceString;

- (NSDictionary *)getDeviceParameters;

- (NSDictionary *)getLocatorParameters;
@end
