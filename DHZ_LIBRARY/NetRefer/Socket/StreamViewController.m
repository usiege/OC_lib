//
//  StreamViewController.m
//  DHZ_LIBRARY
//
//  Created by 先锋电子技术 on 16/5/31.
//  Copyright © 2016年 Hello,world!. All rights reserved.
//

#import "StreamViewController.h"

@interface StreamViewController ()<NSStreamDelegate>
{
    NSInputStream*      _inputStream;
    NSOutputStream*     _outputStream;
}
@end

@implementation StreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    _inputStream = nil;
    _outputStream = nil;
}

- (void)connectToHostUseStreamWithIP:(NSString *)host port:(int)port data:(NSData *)data{
    // 1.建立连接
    // 定义C语言输入输出流
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
    
    // 把C语言的输入输出流转化成OC对象
    _inputStream = (__bridge NSInputStream *)(readStream);
    _outputStream = (__bridge NSOutputStream *)(writeStream);
    
    // 设置代理
    _inputStream.delegate = self;
    _outputStream.delegate = self;
    
    // 把输入输入流添加到运行循环
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    // 打开输入输出流
    [_inputStream open];
    [_outputStream open];
    
    //发送数据
    [[NSRunLoop currentRunLoop] run];
}

- (void)stopConnect{
    
    // 从运行循环移除
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    // 关闭输入输出流
    [_inputStream close];
    [_outputStream close];
    
    _inputStream = nil;
    _outputStream = nil;
    
    NSLog(@"Socket 连接已断开！");
}

#pragma mark -Stream callback

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"%@",[NSThread currentThread]);
    //    NSStreamEventOpenCompleted = 1UL << 0,//输入输出流打开完成
    //    NSStreamEventHasBytesAvailable = 1UL << 1,//有字节可读
    //    NSStreamEventHasSpaceAvailable = 1UL << 2,//可以发放字节
    //    NSStreamEventErrorOccurred = 1UL << 3,// 连接出现错误
    //    NSStreamEventEndEncountered = 1UL << 4// 连接结束
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"输入输出流打开完成");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"有字节可读");

            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"可以发送字节");

            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"socket连接出现错误");

            break;
        case NSStreamEventEndEncountered:
            NSLog(@"socket连接结束");
            
            // 从运行循环移除
            [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            
            // 关闭输入输出流
            [_inputStream close];
            [_outputStream close];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
