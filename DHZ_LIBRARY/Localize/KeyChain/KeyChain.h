//
//  KeyChain.h
//  KeyChain
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 ll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface KeyChain : NSObject

+ (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end
