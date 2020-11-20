//
//  KVOObject.h
//  DHZ_LIBRARY
//
//  Created by charles on 2020/10/26.
//  Copyright © 2020 Hello,world!. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVOObject : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end

NS_ASSUME_NONNULL_END
