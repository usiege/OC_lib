//
//  RedPocketRequestQueue.h
//  RedPocketTest
//
//  Created by 徐坤 on 15/4/13.
//  Copyright (c) 2015年 163.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RedPaperRequestOperation;

@interface RedPaperRequestQueue : NSObject

+ (instancetype)sharedRequestQueue;


// 添加队列
- (void)enqueueOperation:(RedPaperRequestOperation *)operation;

/**
 *  取消指定的队列
 *
 *  @param operation 取消的指定队列
 */
- (void)cancelSpecifiedOperation:(RedPaperRequestOperation *)operation;

/**
 *  结束所有的请求
 */
- (void)cancelAllOperations;

@end
