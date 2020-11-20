//
//  KVOObject.m
//  DHZ_LIBRARY
//
//  Created by charles on 2020/10/26.
//  Copyright © 2020 Hello,world!. All rights reserved.
//

#import "KVOObject.h"

@interface KVOObject ()


@end

@implementation KVOObject

- (instancetype)init {
    if (self = [super init]) {
        [[self.dataArray mutableSetValueForKey:@""] addObject:@"1"];
    }
    return self;
}

@end
