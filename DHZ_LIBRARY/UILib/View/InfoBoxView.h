//
//  InfoBoxView.h
//  FMMapKit
//
//  Created by Hello,world! on 15/6/5.
//  Copyright (c) 2015年 Hello,world!. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoBoxViewDelegate <NSObject>

- (void)quitButtonPressed;
- (void)detialButtonPressed;
- (void)naviButtonPressed;

@end


@interface InfoBoxView : UIView

@property (nonatomic,weak) id<InfoBoxViewDelegate> delegate;

- (void)setIconImageWithName:(NSString *)name;
- (void)setLabelsTitleWithItems:(NSArray *)array;
- (void)animatedIn;
- (void)animatedOut;

//添加人员信息
- (void)addUserView;
//删除人员信息
- (void)removeUserView;

@end
