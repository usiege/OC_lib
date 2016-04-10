//
//  UserInfoView.h
//  FMMapKit
//
//  Created by Hello,world! on 15/6/8.
//  Copyright (c) 2015年 Hello,world!. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserInfoViewDelegate <NSObject>

- (void)quitButtonPressed;

@end

@interface UserInfoView : UIView

@property (nonatomic,assign) id<UserInfoViewDelegate> delegate;
@property (nonatomic,strong) UIImageView* logoView;


- (void)setTitlesWithArray:(NSArray *)titleArray;
- (void)animatedIn;
- (void)animatedOut;

@end
