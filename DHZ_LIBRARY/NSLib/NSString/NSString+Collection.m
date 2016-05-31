//
//  NSString+Identity.m
//  DHZ_LIBRARY
//
//  Created by Hello,world! on 14/12/29.
//  Copyright (c) 2014年 Hello,world!. All rights reserved.
//

#import "NSString+Collection.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

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

+ (NSStringEncoding)GBKCoding{
    //Gbk编码
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return encode;
}

/**
 64编码
 */
+(NSString *)base64Encoding:(NSData*) text
{
    if (text.length == 0)
        return @"";
    
    char *characters = malloc(text.length*3/2);
    
    if (characters == NULL)
        return @"";
    
    int end = text.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[text bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[text bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == text.length - 2)
    {
        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[text bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == text.length - 1)
    {
        int d = ((int)(((char *)[text bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
}

/**
 字节转化为16进制数
 */
+(NSString *)parseByte2HexString:(Byte *)bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return hexStr;
}


/**
 字节数组转化16进制数
 */
+(NSString *) parseByteArray2HexString:(Byte[]) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return [hexStr uppercaseString];
}

//NSdata 转成 十六进制
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


+(NSData*)hexString2Data:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}



/*
 将16进制数据转化成NSData数组
 */
+(NSData*) parseHexToByteArray:(NSString*)hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}

+ (NSString*) data2HexString:(NSData *) data
{
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    NSUInteger nbBytes = [data length];
    NSUInteger strLen = 2*nbBytes;
    
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    for(NSUInteger i=0; i<nbBytes; ) {
        [hex appendFormat:@"%02X", bytes[i]];
        ++i;
    }
    
    return hex;
}


// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
    
    
}

//普通字符串转换为十六进制的
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


@end
