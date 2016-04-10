//
//  InfoBoxView.m
//  FMMapKit
//
//  Created by Hello,world! on 15/6/5.
//  Copyright (c) 2015年 Hello,world!. All rights reserved.
//

#import "InfoBoxView.h"
#import "UIColor+DHZColor.h"

@interface InfoBoxView ()
{
    CGFloat up_down_space;
    CGFloat left_space;
    
    NSMutableArray* labelArray;
    UIImageView* quitImage;
}

@property (nonatomic,strong) UIImageView* logoView;

@property (nonatomic,strong) UIButton*  detialButton;
@property (nonatomic,strong) UIButton*  locateButton;
@property (nonatomic,strong) UIButton*  quitButton;

@property (nonatomic,strong) UIView* userView;

@end

@implementation InfoBoxView

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
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor colorWithHexString:@"fa5865"] CGColor];
        
        [self createLogoView];
        
        [self createLabels];
        
        [self createQuitButton];
        
        [self createDetialAndLocate];
        
//        [self createUserView];
    }
    return self;
}

- (void)createUserView
{
    self.userView = [[UIView alloc] initWithFrame:self.bounds];
    self.userView.backgroundColor = [UIColor whiteColor];
    self.userView.hidden = YES;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.userView.bounds.size.width/2,0, self.userView.bounds.size.width/2, self.userView.bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"userbg"];
    NSArray* titleArray = @[@"已打卡",@"未打卡"];
    UILabel* label = [[UILabel alloc] initWithFrame:imageView.bounds];
    label.frame = CGRectMake(40, 0, label.bounds.size.width, label.bounds.size.height);
    label.text = titleArray[arc4random()%2];
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [imageView addSubview:label];
    
    [self.userView addSubview:imageView];
    [self addSubview:self.userView];
    
    [self createQuitButton];
}



- (void)createDetialAndLocate
{
    NSArray* nameArray = @[@"商铺详情",@"导航到这"];
    for (int i=0; i<2; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(left_space+self.logoView.bounds.size.width+5+i*(60+15)+self.frame.size.width*450/768-100,
                                  self.frame.size.height-33,
                                  60,
                                  25);
        if (i==0) {
            button.layer.borderWidth = 1;
            button.layer.borderColor = [[UIColor colorWithHexString:@"1acf9a"] CGColor];
            [button setTitleColor:[UIColor colorWithHexString:@"1acf9a"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            
        }
        else if (i==1){
            button.layer.borderWidth = 1;
            button.layer.borderColor = [[UIColor colorWithHexString:@"fa5865"] CGColor];
            [button setTitleColor:[UIColor colorWithHexString:@"fa5865"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }
        button.layer.cornerRadius = 5;
        button.tag = 100+i;
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        
        [button setBackgroundColor:[UIColor whiteColor]];
        
        
        
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(middleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)middleButtonClick:(UIButton *)button
{
    if (button.tag == 100) {
        [self.delegate detialButtonPressed];
    }else if (button.tag == 101){
        [self.delegate naviButtonPressed];
    }
}

- (void)createLogoView
{
    UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(left_space, up_down_space, self.frame.size.height-2*up_down_space, self.frame.size.height-2*up_down_space)];
    view.image = [UIImage imageNamed:@"yuyi"];
    [self addSubview:view];
    
    self.logoView = view;
}
- (void)setIconImageWithName:(NSString *)name
{
    self.logoView.image = [UIImage imageNamed:name];
}

- (void)createLabels
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat labelWidth = (self.frame.size.width-(left_space+self.logoView.bounds.size.width+25)-left_space)/2-self.frame.size.width*150/768;
        for (int i=0; i<4; i++) {
            UILabel* label = [[UILabel alloc] initWithFrame:
                              CGRectMake(left_space+self.logoView.bounds.size.width+5+i/2*labelWidth,
                                         -5+up_down_space+i%2*35,
                                         labelWidth,
                                         35)];
            label.font = [UIFont systemFontOfSize:15];
            //        label.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            [labelArray addObject:label];
            //        label.hidden = YES;
        }
    }else{
        float labelWidth;
        for (int i=0; i<4; i++) {
            if (i/2 == 0) {
                labelWidth = 80;
            }else{
                labelWidth = 120;
            }
            UILabel* label = [[UILabel alloc] initWithFrame:
                              CGRectMake(left_space+self.logoView.bounds.size.width+5+i/2*80,
                                         -4+up_down_space+i%2*20,
                                         labelWidth,
                                         20)];
            label.font = [UIFont systemFontOfSize:10];
            //        label.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            [labelArray addObject:label];
        }
    }
    
}

- (void)setLabelsTitleWithItems:(NSArray *)array
{
    for (int i=0; i<labelArray.count; i++) {
        UILabel* label = labelArray[i];
        label.text = array[i];
    }
}

- (void)createQuitButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(self.frame.size.width-40, 0, 40, 40);
    [button addTarget:self action:@selector(quitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    quitImage = [[UIImageView alloc] initWithFrame:CGRectMake(button.bounds.size.width-20, 0, 20, 20)];
    quitImage.image = [UIImage imageNamed:@"quit1"];
    [button addSubview:quitImage];
}


- (void)quitButtonClicked:(UIButton *)button
{
    [self.delegate quitButtonPressed];
    [self animatedOut];
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









