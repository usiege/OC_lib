//
//  KVOViewController.m
//  DHZ_LIBRARY
//
//  Created by charles on 2020/10/26.
//  Copyright © 2020 Hello,world!. All rights reserved.
//

#import "KVOViewController.h"
#import <objc/runtime.h>

@interface KVOViewController ()
{
    @public
    NSInteger sss;
    
    /**
     1. 对于集合类型，键值观察会比较特殊；
     2. 只对属性进行观察，不对成员变量进行观察；
     3. 中间类 isa 发生了变化 isa-swizzing NSKVONotifying_KVOObject
     */
}

@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //以下这个方法可以触发KVO
    [[self.kvoObject mutableArrayValueForKey:@"dataArray"] addObject:@"1111"];
    
    
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
