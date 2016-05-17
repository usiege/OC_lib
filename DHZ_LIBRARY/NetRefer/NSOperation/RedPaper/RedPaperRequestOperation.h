//
//  RedPocketRequestOperation.h
//  RedPocketTest
//
//  Created by 徐坤 on 15/4/13.
//  Copyright (c) 2015年 163.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULTTIMEOUT 30

#pragma mark - 枚举
/**
 *  Operation 状态
 */
typedef NS_ENUM(NSInteger, RPHTTPOprerationState)
{
    RPHTTPOprerationState_Ready = 1,
    RPHTTPOprerationState_Executing,
    RPHTTPOprerationState_Finished,
};

/**
 *  HTTP Method
 */
typedef NS_ENUM(NSInteger, HTTPMETHOD)
{
    HTTP_GET = 1,
    HTTP_POST,
};


#pragma mark - BLOCK 设定

typedef void(^RPHttpConnectionBlock)(BOOL isSuccessed, NSData *data,NSError *error);


#pragma mark - 声明

@interface RedPaperRequestOperation : NSOperation


#pragma mark - Operation config

@property (nonatomic, assign)RPHTTPOprerationState state; // queue要用到

#pragma mark - 设置请求数据

@property (nonatomic, copy)NSString *url;                     // url
@property (nonatomic, assign)HTTPMETHOD method;               // 请求类型
@property (nonatomic, assign)NSTimeInterval timeoutInterval;  // 超时时间
@property (nonatomic, copy)NSMutableDictionary *headers;      // 请求头
@property (nonatomic, copy)NSMutableDictionary *parameters;   // 请求参数(用于GET请求)
@property (nonatomic, copy)NSData *requestBody;               // 请求body(用于POST请求)

@property (nonatomic, assign, getter = shouldCompleteOnMainThread)BOOL completeOnMainThread; // 回调是否在主线程

#pragma mark - 请求结果
@property (nonatomic, copy, readonly)NSURLResponse *response; // 返回结果

@property (nonatomic, copy)RPHttpConnectionBlock httpResultBlock; // 请求结果


#pragma mark - 提供方法

/**
 *  最简单的 GET 请求
 *
 *  @param url         url
 *  @param resultBlock 返回结果
 *
 *  @return UCBaseHTTPRequest 实例
 */
+ (instancetype)loadRequestWithURL:(NSString *)url resultBlock:(RPHttpConnectionBlock)resultBlock;


/**
 *  初始化一个HTTP请求，需要使用loadRequestWithResultBlock:方法来启动
 *
 *  @param url                  url
 *  @param method               方法类型
 *  @param headers              请求头，默认请求头
 *  @param parameters           请求参数（一般用于GET请求）
 *  @param requestBody          请求body(一般用于POST请求)
 *  @param timeoutInterval      超时时间（默认30s）
 *  @param completeOnMainThread 是否回调到主线程
 *
 *  @return UCBaseHTTPRequest 实例
 */
- (instancetype)initWithURL:(NSString *)url
                     method:(HTTPMETHOD)method
                     header:(NSMutableDictionary *)headers
                 parameters:(NSMutableDictionary *)parameters
                requestBody:(NSData *)requestBody
            timeOutInterval:(NSTimeInterval)timeoutInterval
       completeOnMainThread:(BOOL)completeOnMainThread;

/**
 *  去请求数据
 *
 *  @param resultBlock 回调结果 NSData *data,NSError *error
 */
- (void)loadRequestWithResultBlock:(RPHttpConnectionBlock)resultBlock;

/**
 *  取消请求
 */
- (void)cancelRequest;




@end
