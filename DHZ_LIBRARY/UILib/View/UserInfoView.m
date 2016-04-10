//
//  UserInfoView.m
//  FMMapKit
//
//  Created by Hello,world! on 15/6/8.
//  Copyright (c) 2015年 Hello,world!. All rights reserved.
//

#import "UserInfoView.h"
#import "UIColor+DHZColor.h"

@interface UserInfoView ()
{
    CGFloat up_down_space;
    CGFloat left_space;
    
    NSMutableArray* labelArray;
}
@property (nonatomic,strong) UIView*  userView;

@end

@implementation UserInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        left_space = 18;
        up_down_space = 10;
        labelArray = [NSMutableArray array];
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [[UIColor colorWithHexString:@"fa5865"] CGColor];
        
        [self createUserView];
        [self createQuitButton];
        [self createLogoView];
        [self createTitleLabels];
    }
    return self;
}

- (void)createTitleLabels
{
    NSArray* titleArray = @[@[@"姓名：张大山",@"职务：保安",@"签到：？"]
                            ,@[@"姓名：李伟",@"职务：保洁员",@"签到：？"]
                            ,@[@"姓名：吴芳芳",@"职务：收银",@"签到：？"]
                            ,@[@"姓名：张晓月",@"职务：保安",@"签到：？"]
                            ,@[@"姓名：王大川",@"职务：护士",@"签到：？"]];
    for (int i=0; i<3; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(self.logoView.bounds.size.width+40,
                                                                  0+i*self.bounds.size.height/3,
                                                                  200,
                                                                   self.bounds.size.height/3)];
        label.text = titleArray[arc4random()%titleArray.count][i];
        label.font = [UIFont systemFontOfSize:13];
//        label.backgroundColor = [UIColor blueColor];
        [labelArray addObject:label];
        [self addSubview:label];
    }
}

- (void)setTitlesWithArray:(NSArray *)titleArray
{
    for (int i=0; i<titleArray.count; i++) {
        UILabel* label = labelArray[i];
        label.text = titleArray[i];
    }
}

- (void)createLogoView
{
    UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(left_space, up_down_space, self.frame.size.height-2*up_down_space, self.frame.size.height-2*up_down_space)];
    view.image = [UIImage imageNamed:@"nurse"];
    [self addSubview:view];
    
    self.logoView = view;
}
- (void)setIconImageWithName:(NSString *)name
{
    self.logoView.image = [UIImage imageNamed:name];
}


- (void)createUserView
{
    self.userView = [[UIView alloc] initWithFrame:self.bounds];
    self.userView.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.userView.bounds.size.width/3*2-20,10, self.userView.bounds.size.width/3, self.userView.bounds.size.height-20)];
    imageView.layer.cornerRadius = 10;
    imageView.image = [UIImage imageNamed:@"userbg"];
    NSArray* titleArray = @[@"已打卡",@"未打卡"];
    UILabel* label = [[UILabel alloc] initWithFrame:imageView.bounds];
    label.frame = CGRectMake(5+40/768*([UIScreen mainScreen].bounds.size.width), 0, label.bounds.size.width, label.bounds.size.height);
    label.text = titleArray[arc4random()%2];
    label.font = [UIFont systemFontOfSize:23];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [imageView addSubview:label];
    
    [self.userView addSubview:imageView];
    [self addSubview:self.userView];
}

- (void)quitButtonClicked:(UIButton *)button
{
    [self animatedOut];
    [self.delegate quitButtonPressed];
}


- (void)createQuitButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(self.frame.size.width-40, 0, 40, 40);
    [button addTarget:self action:@selector(quitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(button.bounds.size.width-20, 0, 20, 20)];
//    image.backgroundColor = [UIColor orangeColor];
    image.image = [UIImage imageNamed:@"quit1"];
    [button addSubview:image];
}


#pragma mark - Animated Mthod
- (void)animatedIn
{
    self.hidden = NO;
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}

@end
