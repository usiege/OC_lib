//
//  RunLoopViewController.m
//  DHZ_LIBRARY
//
//  Created by Hello,world! on 16/3/26.
//  Copyright © 2016年 Hello,world!. All rights reserved.
//

#import "RunLoopViewController.h"

//typedef void(^block)(int a);
//typedef void *block2(int a);

@interface RunLoopViewController ()
{
    NSThread* _thread;
    dispatch_source_t _timer;
    
}
//@property (strong, nonatomic) dispatch_source_t timer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self runloopPractise];
    
    [self gcdTest];
}

- (void)gcdTest
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"这里执行");
//    });
    
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"------queue :%@",queue);
    //创建一个定时器
    //dispatch_source_t是一个OC对象
    //不使用属性的时候这个定时器是无效的
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_t timer = _timer;
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    
    //设置定时器各种属性
    //NSEC_PER_SEC 纳秒，GCD的时间参数一般是纳秒(10的9次方)
    dispatch_time_t start = DISPATCH_TIME_NOW;
    uint64_t interval = (uint64_t)(2.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, interval, 0);
    
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"------->%@",[NSThread currentThread]);
    });
    
    //默认是暂停的,启动
    dispatch_resume(timer);
    
}


- (void)excute
{
    //while (1);
    
    //2.另外一种方法
    while(1){
        //内部也是有一个死循环的，如果内部模式不为空的时候，循环将开启，run后的方法将不再会被执行，即while循环将不再继续
        [[NSRunLoop currentRunLoop] run];
        NSLog(@"这个语句是跟着while循环走的！");
    }
}


- (void)run
{
    @autoreleasepool {
        
        NSLog(@"------run-------%@",[NSThread currentThread]);
        
        //1.可以保证线程不死
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        //启动时检查当前模式是不是空的，如果是空的直接退出，如果有sourse,timer,observer
        
        [[NSRunLoop currentRunLoop] run];
        //[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]
            
    }
    NSLog(@"方法将不会被执行！");
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
//写在这个中间的代码,都不会被编译器提示-Wdeprecated-declarations类型的警告

#pragma clang diagnostic pop

- (void)runloopPractise
{
    //常驻线程
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [_thread start];
}


#pragma mark runloop observer

- (void)runloopObserver
{
    //添加observer
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        NSLog(@"runloop状态发生改变---->%zd",activity);
        
    });
    //监听runloop状态
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    //释放observer
    CFRelease(observer);
    
    CFRetain(observer);
    CFRelease(observer);
    
    //CFRunLoopSourceRef
}

/*CF内存管理
 * 1.凡是带有create,copy,retain等字眼的函数，创建出来的对象，都需要做一次release;
 * 2.release函数，CFRelease();
 */


- (void)timer
{
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //以下两部分的作用是相同的
    NSTimer* timer2 = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
    
    NSTimer* timer3 = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];

    NSLog(@"-%@-%@-%@",timer,timer2,timer3);
}


#pragma mark other

//事件代理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"我在点击！");
//    [self performSelector:@selector(excute) onThread:_thread withObject:nil waitUntilDone:YES modes:@[NSDefaultRunLoopMode]];
    [self gcdTest];
}


//- (void)useImageView
//{
//    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@""] afterDelay:3.0 inModes:@[NSDefaultRunLoopMode,UITrackingRunLoopMode]];
//}



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
