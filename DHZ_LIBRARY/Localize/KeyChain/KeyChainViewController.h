//
//  ViewController.h
//  KeyChain
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 ll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "KeyChain.h"

@interface KeyChainViewController : BaseViewController

+ (void)savePassWord:(NSString *)password;

+ (id)readPassWord;

+ (void)deletePassWord;


@end

