//
//  NSString+Identity.m
//  DHZ_LIBRARY
//
//  Created by Hello,world! on 14/12/29.
//  Copyright (c) 2014年 Hello,world!. All rights reserved.
//

#import "NSString+Collection.h"

@implementation NSString (Collection)

+ (BOOL)fitToChineseIDWithString:(NSString*)aString{
    aString=[aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * regex1 = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    NSString * regex2 = @"^[1-9]\\d{5}(19|20)\\d{2}(0\\d|1[0-2])(([0|1|2]\\d)|3[0-1])\\d{3}(x|X|\\d)$";
 
    NSPredicate* pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate* pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    if ([pred1 evaluateWithObject:aString]) {
        //15位身份证号码
        NSString* strTmp;
        NSRange rg;
        //获得省代码
        rg.length = 2;
        rg.location = 0;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 41 || [strTmp intValue] < 11) {
            //省代码不合法
            return NO;
        }
        //获得月份
        rg.location = 8;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 12 || [strTmp intValue] < 1) {
            //月份不合法
            return NO;
        }
        
        //获得日
        rg.location = 10;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 31 || [strTmp intValue] < 1) {
            //日不合法
            return NO;
        }
        
        return YES;
    }
    else if ([pred2 evaluateWithObject:aString])
    {
        //18位身份证号码
        NSString* strTmp;
        NSRange rg;
        //获得省代码
        rg.length = 2;
        rg.location = 0;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 99 || [strTmp intValue] < 1) {
            //省代码不合法
            return NO;
        }
        //获得年
        rg.location = 6;
        rg.length = 4;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 2100 || [strTmp intValue] < 1900) {
            //年不合法
            return NO;
        }
        //获得月份
        rg.location = 10;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 12 || [strTmp intValue] < 1) {
            //月份不合法
            return NO;
        }
        
        //获得日
        rg.location = 12;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 31 || [strTmp intValue] < 1) {
            //日不合法
            return NO;
        }
        
        NSRange rangeLast;
        rangeLast.length = 1;
        rangeLast.location = 17;
        NSString* strLast = [aString substringWithRange:rangeLast];
        if ([strLast isEqualToString:@"x"]) {
            strLast = @"X";
        }
        
        
        int i = 0;
        int sum = 0;
        int a[17] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
        
        for (i = 0; i < 17; i++) {
            NSRange range;
            range.location = i;
            range.length = 1;
            int intValue = [[aString substringWithRange:range]intValue];
            if (intValue >= 0 && intValue <=9) {
                sum += intValue * a[i];
            }
            else
            {
                //非数字
                return NO;
            }
        }
        int y = sum % 11;
        
        NSDictionary* dicTmp = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"1",@"0",
                                @"0",@"1",
                                @"X",@"2",
                                @"9",@"3",
                                @"8",@"4",
                                @"7",@"5",
                                @"6",@"6",
                                @"5",@"7",
                                @"4",@"8",
                                @"3",@"9",
                                @"2",@"10", nil];
        NSString* strCounted = [dicTmp objectForKey:[NSString stringWithFormat:@"%d",y]];
        if ([strLast isEqualToString:strCounted]) {
            return YES;
        }
        else
            return NO;//验证码不匹配
        
    }
    else
    {
        return NO;
    }
}


@end
