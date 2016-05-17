//
//  OperationViewController.m
//  DHZ_LIBRARY
//
//  Created by Hello,world! on 16/4/5.
//  Copyright © 2016年 Hello,world!. All rights reserved.
//

#import "OperationViewController.h"


@interface OperationViewController ()
<UITableViewDataSource,UITableViewDelegate>


@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


- (void)baseOperationQueue
{
    //非主队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2;
    
    //自动异步执行，并发
    NSBlockOperation* opeation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片-----1:%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation* opeation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片-----2:%@",[NSThread currentThread]);
    }];
    
    [queue addOperation:opeation1];
    [queue addOperation:opeation2];
    [queue addOperationWithBlock:^{
        NSLog(@"下载图片-----3:%@",[NSThread currentThread]);
    }];
}

- (void)blockOperation
{
    NSBlockOperation* opertion = [[NSBlockOperation alloc] init];
    [opertion addExecutionBlock:^{
        
    }];
    
    [opertion start];
    
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:opertion];
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
