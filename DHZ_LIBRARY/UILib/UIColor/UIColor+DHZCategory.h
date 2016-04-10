//
//  UIColor+TIXACategory.h
//  Lianxi
//
//  Created by Liusx on 12-6-28.
//  Copyright (c) 2012年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DHZCategory)

+ (UIColor *)colorWithHexRGB:(NSString *)hexRGBString;

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
