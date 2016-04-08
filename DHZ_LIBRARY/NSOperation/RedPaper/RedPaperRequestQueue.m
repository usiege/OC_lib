//
//  RedPocketRequestQueue.m
//  RedPocketTest
//
//  Created by 徐坤 on 15/4/13.
//  Copyright (c) 2015年 163.COM. All rights reserved.
//
#import "RedPaperRequestQueue.h"
#import "RedPaperRequestOperation.h"
#import <libkern/OSAtomic.h>
#import "RedPaperReachability.h"

@interface RedPaperRequestQueue ()
{
    OSSpinLock _oneOperationSpinlock;
    OSSpinLock _allOperationSpinlock;
}

@property (nonatomic, strong)dispatch_queue_t operationQueue;

@end


static NSOperationQueue *_sharedRequestQueue;

@implementation RedPaperRequestQueue

+ (instancetype)sharedRequestQueue
{
    static RedPaperRequestQueue *_sharedRequestQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRequestQueue = [[[self class] alloc] init];
    });
    
    return _sharedRequestQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 创建下载队列
        _sharedRequestQueue = [NSOperationQueue new];
        [_sharedRequestQueue setName:@"com.163.httpRequestQueue"];
        _sharedRequestQueue.maxConcurrentOperationCount = 5;
      
        self.operationQueue = dispatch_queue_create("com.163.operationqueue", DISPATCH_QUEUE_SERIAL);
        // 初始化锁
        _oneOperationSpinlock = OS_SPINLOCK_INIT;
        _allOperationSpinlock = OS_SPINLOCK_INIT;
    }
    return self;
}

#pragma mark - 操作任务的的添加删除

// 添加队列
- (void)enqueueOperation:(RedPaperRequestOperation *)operation
{
  //有网络
  [_sharedRequestQueue addOperation:operation];
}

/**
 *  取消指定的队列
 *
 *  @param operation 取消的指定队列
 */
- (void)cancelSpecifiedOperation:(RedPaperRequestOperation *)operation
{
    OSSpinLockLock(&_oneOperationSpinlock);
    NSArray *runningOperations = _sharedRequestQueue.operations;
    if (runningOperations.count>0) {
        [runningOperations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (obj == operation) {
                [operation cancel];
            }
        }];
    }
    OSSpinLockUnlock(&_oneOperationSpinlock);
}

/**
 *  结束所有的请求
 */
- (void)cancelAllOperations
{
    if (!_sharedRequestQueue) {
        return;
    }
    
    OSSpinLockLock(&_allOperationSpinlock);
    
    NSArray *runningOperations = _sharedRequestQueue.operations;
    
    if (runningOperations.count>0) {
        [runningOperations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RedPaperRequestOperation *oprTmp = obj;
            [oprTmp cancel];
        }];
    }
    
    OSSpinLockUnlock(&_allOperationSpinlock);
    
}



@end
