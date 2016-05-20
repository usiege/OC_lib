//
//  ViewController.m
//  KeyChain
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 ll. All rights reserved.
//

#import "KeyChainViewController.h"
static NSString * const KEY_IN_KEYCHAIN = @"com.wuqian.app.allinfo";// 字典在keychain中的key
static NSString * const KEY_PASSWORD = @"com.wuqian.app.password"; //  密码在字典中的key

@interface KeyChainViewController ()
{
    UITextField * _field; // 输入密码
    UILabel *_psw;        // 显示密码
}

@end

@implementation KeyChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 100, 30)];
    labelName.text = @"密码是:";
    
    
    _field = [[UITextField alloc] initWithFrame:CGRectMake(100, 80, 200, 30)];
    _field.placeholder = @"请输入密码";
    _field.borderStyle = UITextBorderStyleRoundedRect;
    
    _psw = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 200, 30)];
    _psw.backgroundColor = [UIColor yellowColor];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame =CGRectMake(100, 160, 200, 30);
    btn.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.1 alpha:0.5];
    btn.tintColor = [UIColor redColor];
    [btn setTitle:@"submit" forState:UIControlStateNormal];
    [btn setTitle:@"正在提交" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
    btn.layer.cornerRadius=8; //圆角
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 5;
    btn.layer.borderColor=(__bridge CGColorRef)([UIColor redColor]);
    
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIGestureRecognizer *tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    [self.view addGestureRecognizer:tap];
    
    
    
    [self.view addSubview:btn];
    [self.view addSubview:_field];
    [self.view addSubview:labelName];
    [self.view addSubview:_psw];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)tap:(UIGestureRecognizer*)gr
//{
//
//    
//    [_field resignFirstResponder];
//}

- (void)btnClick:(id)sender
{
    [ViewController savePassWord:_field.text];
    _psw.text = [ViewController readPassWord];

    if (![_field isExclusiveTouch]) {
        //Setting this property to YES causes the receiver to block the delivery of touch events to other views in the same window. The default value of this property is NO.
        [_field resignFirstResponder];// 收回键盘

    }
    
}

+ (void)savePassWord:(NSString *)password
{
    NSMutableDictionary *usernamepasswordKVPairs = [[NSMutableDictionary alloc] init];
    [usernamepasswordKVPairs setObject:password forKey:KEY_PASSWORD];
    [KeyChain save:KEY_IN_KEYCHAIN data:usernamepasswordKVPairs];
}

+ (id)readPassWord
{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[KeyChain load:KEY_IN_KEYCHAIN];
    
    return [usernamepasswordKVPairs objectForKey:KEY_PASSWORD];
    
}

+ (void)deletePassWord
{
    [KeyChain delete:KEY_IN_KEYCHAIN];
    
}

@end
