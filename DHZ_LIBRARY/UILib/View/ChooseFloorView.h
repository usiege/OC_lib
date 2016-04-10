//
//  ChooseFloorView.h
//  FMMapKit
//
//  Created by Hello,world! on 15/6/5.
//  Copyright (c) 2015年 Hello,world!. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseFloorViewDelegate <NSObject>

- (void)totalButtonClicked:(BOOL)isTotal;

- (void)floorButtonClickedWithIndex:(NSInteger)index isTotal:(BOOL)isTotal;

@end

@interface ChooseFloorView : UIView

@property (nonatomic,strong) UIButton* button;
@property (nonatomic,strong) NSMutableArray* dataArray;
@property (nonatomic,weak) id<ChooseFloorViewDelegate> delegate;

- (void)reloadTable;

@end
