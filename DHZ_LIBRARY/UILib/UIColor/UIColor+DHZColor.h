//
//  UIColor+DHZColor.h
//  FMMapKit
//
//  Created by Hello,world! on 15/6/30.
//  Copyright (c) 2015年 Hello,world!. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DHZColor)

+ (UIColor *) colorWithHexString: (NSString *)color;

/** Creates and returns a color object using the specific hex value.
 @param hex The hex value that will decide the color.
 @return The `UIColor` object.
 */
+ (UIColor *) colorWithHex:(unsigned int)hex;

/** Creates and returns a color object using the specific hex value.
 @param hex The hex value that will decide the color.
 @param alpha The opacity of the color.
 @return The `UIColor` object.
 */
+ (UIColor *) colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;

/** Creates and returns a color object with a random color value. The alpha property is 1.0.
 @return The `UIColor` object.
 */
+ (UIColor *)colorWithHexRGB:(NSString *)hexRGBString;

+ (UIColor *) randomColor;
+ (UIColor *)whiteTranslucentColor;
+ (UIColor *)blackTranslucentColor;

+ (UIColor *)skyBlueColor;
+ (UIColor *)lightBlueColor;
+ (UIColor *)darkGreenColor;
+ (UIColor *)pinkColor;

+ (UIColor *)lightGrayBGColor;/*浅灰内容背景色*/
+ (UIColor *)lightSeparatorColor;/*细分割线纹理*/
+ (UIColor *)separatorColor;/*分割线纹理*/

@end
