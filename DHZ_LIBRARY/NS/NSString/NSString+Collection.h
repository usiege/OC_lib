//
//  NSString+Identity.h
//  DHZ_LIBRARY
//
//  Created by Hello,world! on 14/12/29.
//  Copyright (c) 2014年 Hello,world!. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Collection)
/**
 *  //身份证号码验证
 */
+ (BOOL)fitToChineseIDWithString:(NSString*)aString;

@end
