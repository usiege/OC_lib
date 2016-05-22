//
//  KeyChain.m
//  KeyChain
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 ll. All rights reserved.
//
/**
 *__bridge_transfer , __bridge_retained c和oc类型之间转换，，可统一使用__bridge替换
 */
#import "KeyChain.h"
static NSString *serviceName = @"com.mycompany.myAppServiceName";

@implementation KeyChain

+ (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier
{
    
    NSMutableDictionary * searchDictionary = [[NSMutableDictionary alloc] init];
    NSData *encodeInditifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:(__bridge_transfer id)kSecClassGenericPassword
                         forKey:(__bridge_transfer id)kSecClass];
    [searchDictionary setObject:encodeInditifier forKey:(__bridge_transfer id)kSecAttrGeneric];
    [searchDictionary setObject:encodeInditifier forKey:(__bridge_transfer id)kSecAttrAccount];
    [searchDictionary setObject:(__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock
                         forKey:(__bridge_transfer id)kSecAttrAccessible];
    
    //[searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

+(void)save:(NSString *)service data:(id)data
{
    NSMutableDictionary *keyChainQuery = [self newSearchDictionary:service];
    /**
     *  delete old
     */
    SecItemDelete((__bridge_retained CFDictionaryRef)keyChainQuery);
    [keyChainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data]
                      forKey:(__bridge_transfer id)kSecValueData];
    /**
     *  add new
     */
    SecItemAdd((__bridge_retained CFDictionaryRef)keyChainQuery, nil);
    
}

+(id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keyChainQuery = [self newSearchDictionary:service];
    [keyChainQuery setObject:(id)kCFBooleanTrue
                      forKey:(__bridge_transfer id)kSecReturnData];
    [keyChainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne
                      forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keyChainQuery, (CFTypeRef*)&keyData) == noErr)
    {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData*)keyData];
    }
    
//    if (keyData) {
//        
//        CFRelease(keyData);
//    }
//    
    
    return ret;
}

+(void)delete:(NSString *)service
{
    NSMutableDictionary *keyChainQuery = [self newSearchDictionary:service];
    
    SecItemDelete((__bridge_retained CFDictionaryRef)keyChainQuery);
    
}


@end
