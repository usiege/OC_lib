//
//  RedPocketRequestOperation.m
//  RedPocketTest
//
//  Created by 徐坤 on 15/4/13.
//  Copyright (c) 2015年 163.COM. All rights reserved.
//

#import "RedPaperRequestOperation.h"
#import "RedPaperRequestQueue.h"
#import <libkern/OSAtomic.h>
#import "RedPaperReachability.h"

@interface RedPaperRequestOperation () <NSURLConnectionDataDelegate>
{
    OSSpinLock _cancelHttpOperationSpinlock;

}

@property (nonatomic, assign)BOOL isCancelled;
@property (nonatomic, strong)NSURLConnection *connection; // NSURLConnection 实例
@property (nonatomic, copy)NSMutableData *responseData; // 请求的数据
@property (nonatomic, copy, readwrite)NSURLResponse *response;

@end


@implementation RedPaperRequestOperation

@synthesize state = _state;

+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    do {
        @autoreleasepool
        {
            [[NSRunLoop currentRunLoop] run];
            [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes
                                     beforeDate:[NSDate distantFuture]];
        }
    } while (YES);
    
}

+ (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
        [_networkRequestThread setName:@"COM.163.HTTPCALLBACK"];

    });
    
    return _networkRequestThread;
}


#pragma mark - Getter&&Setter

- (RPHTTPOprerationState)state
{
    return (RPHTTPOprerationState)_state;
}

- (void)setState:(RPHTTPOprerationState)newState
{
    // K-V-C 来让queue来获取最近的state来控制
    switch (newState) {
        case RPHTTPOprerationState_Ready:
            [self willChangeValueForKey:@"isReady"];
            break;
        case RPHTTPOprerationState_Executing:
            [self willChangeValueForKey:@"isReady"];
            [self willChangeValueForKey:@"isExecuting"];
            break;
        case RPHTTPOprerationState_Finished:
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            break;
    }
    
    _state = newState;
    
    switch (newState) {
        case RPHTTPOprerationState_Ready:
            [self didChangeValueForKey:@"isReady"];
            break;
        case RPHTTPOprerationState_Executing:
            [self didChangeValueForKey:@"isReady"];
            [self didChangeValueForKey:@"isExecuting"];
            break;
        case RPHTTPOprerationState_Finished:
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
            break;
    }
}


- (NSMutableData *)responseData
{
    if (!_responseData) {
        _responseData = [NSMutableData data];
    }
    
    return _responseData;
}

- (NSMutableDictionary *)headers
{
    if (!_headers) {
        _headers = [NSMutableDictionary dictionary];
    }
    
    return _headers;
}

- (NSMutableDictionary *)parameters
{
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}


#pragma mark - make queryString

- (NSString *)queryParametersURL
{
    NSString *urlString = nil;
    if (self.parameters.count > 0) {
        urlString = [NSString stringWithFormat:@"%@?%@", self.url, [self queryString]];
    } else {
        urlString = [NSString stringWithFormat:@"%@", self.url];
    }
    return urlString;
}

- (NSString *)queryString
{
    NSMutableArray *encodedParameters = [NSMutableArray arrayWithCapacity:self.parameters.count];
    
    for (NSString *key in self.parameters) {
        NSString *value = self.parameters[key];
        
        if ([value isKindOfClass:[NSString class]]) {
            NSString *encodedKey   = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *encodedValue = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [encodedParameters addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
        }
    }
    
    return [encodedParameters componentsJoinedByString:@"&"];
}

#pragma mark - NSMutableURLRequest

/**
 *  产生一个http request
 *
 *  @return NSMutableURLRequest 实例
 */
- (NSMutableURLRequest *)request
{
    if (self.parameters) {
        self.url = [self queryParametersURL];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    NSString *HttpMethodTmp = nil;
    switch (self.method) {
        case HTTP_GET:
            HttpMethodTmp = @"GET";
            break;
        case HTTP_POST:
            HttpMethodTmp = @"POST";
            break;
        default:
            HttpMethodTmp = @"GET";
            break;
    }
    
    request.HTTPMethod      = HttpMethodTmp;
    request.HTTPBody        = self.requestBody;
    request.timeoutInterval = self.timeoutInterval;
    request.cachePolicy     = NSURLRequestReloadIgnoringLocalCacheData;
    
    if (self.headers) {
        for (NSString *key in self.headers) {
            [request setValue:self.headers[key] forHTTPHeaderField:key];
        }
    }
    
    if (self.requestBody.length) {
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)self.requestBody.length] forHTTPHeaderField:@"Content-Length"];
    }
  NSLog(@"%@",request);
    return request;
}


#pragma mark - NSOperation config

-(void)main
{
    @autoreleasepool {
        [self start];
    }
}

- (void)start
{
    if(!self.isCancelled) {
      
    //启动含有runloop的线程
      [self performSelector:@selector(operationDidStart)
                     onThread:[[self class] networkRequestThread]
                   withObject:nil
                waitUntilDone:NO
                        modes:@[NSRunLoopCommonModes]];
        
        self.state = RPHTTPOprerationState_Executing;
    } else {
        self.state = RPHTTPOprerationState_Finished;
    }
}

- (void)operationDidStart
{
  //在新建立的含有runloop线程中，启动连接
    @synchronized(self) {
        self.connection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                          delegate:self
                                                  startImmediately:NO];
        [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.connection start];
    }
}

- (void)cancelConnection
{
    if (self.connection) {
        [self.connection cancel];
    }
    
    NSDictionary *userInfo = nil;
    [self performSelector:@selector(connection:didFailWithError:)
               withObject:self.connection
               withObject:[NSError errorWithDomain:NSURLErrorDomain
                                              code:NSURLErrorCancelled
                                          userInfo:userInfo]];
}


- (BOOL)isReady
{
    return (self.state == RPHTTPOprerationState_Ready && [super isReady]);
}

- (BOOL)isFinished
{
    return (self.state == RPHTTPOprerationState_Finished);
}

- (BOOL)isExecuting
{
    return (self.state == RPHTTPOprerationState_Executing);
}

- (void)cancel
{
    if([self isFinished])
        return;
    OSSpinLockLock(&_cancelHttpOperationSpinlock);
    
    [self performSelector:@selector(cancelConnection)
                 onThread:[[self class] networkRequestThread]
               withObject:nil
            waitUntilDone:NO
                    modes:@[NSRunLoopCommonModes]];
    
    self.isCancelled = YES;
   
    
    BOOL isNotFinish = (self.state == RPHTTPOprerationState_Executing ||
                        self.state == RPHTTPOprerationState_Ready);
        if(isNotFinish) {
            self.state = RPHTTPOprerationState_Finished;
        }
    
    OSSpinLockUnlock(&_cancelHttpOperationSpinlock);
    
    [super cancel];
}

// 新加

- (void)cancelRequest{
  [self cancel];
  [self cancelRequest];
}

+ (instancetype)loadRequestWithURL:(NSString *)url resultBlock:(RPHttpConnectionBlock)resultBlock
{
    RedPaperRequestOperation *ucReq = [[[self class] alloc] initWithURL:url
                                                        method:HTTP_GET
                                                        header:nil
                                                    parameters:nil
                                                   requestBody:nil
                                               timeOutInterval:DEFAULTTIMEOUT
                                          completeOnMainThread:YES];
    
    [ucReq loadRequestWithResultBlock:resultBlock];
    
    return ucReq;
}


- (instancetype)initWithURL:(NSString *)url
                     method:(HTTPMETHOD)method
                     header:(NSMutableDictionary *)headers
                 parameters:(NSMutableDictionary *)parameters
                requestBody:(NSData *)requestBody
            timeOutInterval:(NSTimeInterval)timeoutInterval
       completeOnMainThread:(BOOL)completeOnMainThread
{
    self = [super init];
    
    if (self) {
        
        self.url = url;
        self.method = method;
        self.headers = headers;
        self.parameters = parameters;
        self.requestBody = requestBody;
        self.timeoutInterval = timeoutInterval;
        self.completeOnMainThread = completeOnMainThread;
        
        self.isCancelled = NO;
        self.state = RPHTTPOprerationState_Ready;
        _cancelHttpOperationSpinlock = OS_SPINLOCK_INIT;
    }
    
    return self;
}

- (void)loadRequestWithResultBlock:(RPHttpConnectionBlock)resultBlock
{
  self.httpResultBlock = resultBlock;
  NSString *remoteHostName = @"www.baidu.com";
  RedPaperReachability *hostReachability = [RedPaperReachability reachabilityWithHostName:remoteHostName];
  RedPaperNetworkStatus netStatus = [hostReachability currentReachabilityStatus];
  // 检测网络
  if (netStatus) {
    [[RedPaperRequestQueue sharedRequestQueue] enqueueOperation:self];
  }else{
    self.state = RPHTTPOprerationState_Finished;
    self.responseData = nil;
    //此处的error传定义的好的error，现在先传nil
    [self setHttpResultWithSuccess:nil error:nil isSuccessed:NO];
  }
}


#pragma mark - Block 回调结果
/**
 *  中途断网或者网络错误会进入该回调方法，执行错误方法
 *
 *  @param error
 */
- (void)requestFailed:(NSError *)error
{
    self.state = RPHTTPOprerationState_Finished;
    self.responseData = nil;
    [self setHttpResultWithSuccess:nil error:error isSuccessed:NO];
}

- (void)responseReceived
{
    [self setHttpResultWithSuccess:self.responseData error:nil isSuccessed:YES];
}

- (void)setHttpResultWithSuccess:(NSData *)data error:(NSError *)error isSuccessed:(BOOL)isSuccessed
{
    if (self.httpResultBlock) {
        if (self.shouldCompleteOnMainThread) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                self.httpResultBlock(isSuccessed,data,error);
            });
        } else {
          self.httpResultBlock(isSuccessed,data,error);
        }
    }
    self.connection = nil;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.state = RPHTTPOprerationState_Finished;
    [self requestFailed:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [self.responseData appendData:data];
  NSLog(@"已经下载%fKB",self.responseData.length/1024.0f);
  
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([self isCancelled])
        return;
    
    self.state = RPHTTPOprerationState_Finished;
    
    [self responseReceived];
}
@end
