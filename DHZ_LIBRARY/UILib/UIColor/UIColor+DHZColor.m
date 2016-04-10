//
//  UIColor+DHZColor.m
//  FMMapKit
//
//  Created by Hello,world! on 15/6/30.
//  Copyright (c) 2015年 Hello,world!. All rights reserved.
//

#import "UIColor+DHZColor.h"

@implementation UIColor (DHZColor)

+ (id) colorWithHex:(unsigned int)hex{
    return [UIColor colorWithHex:hex alpha:1];
}

+ (id) colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha{
    
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
    
}

+ (UIColor*) randomColor{
    
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    
}
+ (UIColor *)whiteTranslucentColor
{
    return [UIColor colorWithWhite:1.0 alpha:0.9];
}

+ (UIColor *)blackTranslucentColor
{
    return [UIColor colorWithWhite:0.0 alpha:0.9];
}

+ (UIColor *)skyBlueColor
{
    return [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
}

+ (UIColor *)lightBlueColor
{
    return [UIColor colorWithRed:0.0 green:0.75 blue:1.0 alpha:1.0];
}

+ (UIColor *)darkGreenColor
{
    return [UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0];
}

+ (UIColor *)pinkColor
{
    return [UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0];
}



/*浅灰内容背景色*/
+ (UIColor *)lightGrayBGColor
{
    return [self colorWithHexRGB:@"e2e2dc"];
}

/*细分割线纹理*/
+ (UIColor *)lightSeparatorColor
{
    return [self colorWithPatternImage:[UIImage imageNamed:@"separator_light"]];
}

/*分割线纹理*/
+ (UIColor *)separatorColor
{
    return [UIColor colorWithHexRGB:@"e8e8e1"];//[UIColor colorWithHexRGB:@"e6e6e6"];//[self colorWithPatternImage:[UIImage imageNamed:@"separator"]];
}

/*由16进制字符串获取颜色*/
+ (UIColor *)colorWithHexRGB:(NSString *)hexRGBString
{
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (hexRGBString) {
        NSScanner *scanner = [NSScanner scannerWithString:hexRGBString];
        [scanner scanHexInt:&colorCode];
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    
    return [UIColor colorWithRed:(float)redByte/0xff green:(float)greenByte/0xff blue:(float)blueByte/0xff alpha:1.0];
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
