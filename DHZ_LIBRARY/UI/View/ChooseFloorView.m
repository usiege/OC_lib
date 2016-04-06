//
//  ChooseFloorView.m
//  FMMapKit
//
//  Created by Hello,world! on 15/6/5.
//  Copyright (c) 2015年 Hello,world!. All rights reserved.
//

#import "ChooseFloorView.h"
#import "UIColor+Color16.h"

@interface ChooseFloorView ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isTotal;
    UITableView* tableView;
    
    NSMutableArray* cellArray;
}

@property (nonatomic,strong) UITableView* m_tableView;

@end

@implementation ChooseFloorView

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
        self.layer.cornerRadius = 10;
        
        _dataArray = [NSMutableArray arrayWithArray:@[@"F3",@"F2",@"F1",@"B1",@"B2"]];
        cellArray = [NSMutableArray array];
        
        _isTotal = YES;
        [self createTableView];
        
        
        //将图层的边框设置为圆脚
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        //给图层添加一个有色边
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor colorWithHexString:@"fa5865"] CGColor];
    }
    return self;
}

- (void)createTableView
{
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.m_tableView = tableView;
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0,self.frame.size.width, 40);
    self.button.backgroundColor = [UIColor colorWithHexString:@"fa5865"];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [button setTitle:@"全部" forState:UIControlStateNormal];
//    [button setTitle:@"单层" forState:UIControlStateSelected];
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.button setImage:[UIImage imageNamed:@"total"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"single"] forState:UIControlStateSelected];
    [self.button setImageEdgeInsets:UIEdgeInsetsMake(0, 00, 0, 0)];

    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
}



- (void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    _isTotal = !button.selected;
    if ([self.delegate respondsToSelector:@selector(totalButtonClicked:)]) {
        [self.delegate totalButtonClicked:!button.selected];
    }
}

#pragma mark 分组和分行
//分row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark 行上的细节描述

//用来添加cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        //若要显示副标题,这里的类型必须是subtitle
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"ID"];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height)/_dataArray.count)];
        label.tag = 100;
        [cell addSubview:label];
        
        [cellArray addObject:cell];
    }
    //标题
//    UILabel* label = (UILabel *)[cell viewWithTag:100];
//    label.text = _dataArray[indexPath.row];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    cell.textLabel.tintColor = [UIColor colorWithHexString:@"fa5865"];
//    [cell.textLabel tintColorDidChange];
//    cell.tintColor = [UIColor colorWithHexString:@"fa5865"];
    
    //选中后的效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark Delegate有关项
//cell.accessoryButton事件
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"我是第%d行上的Button",indexPath.row);
    
}

//点击row后的事件,indexPath是该行的数
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"fa5865"];
    if ([self.delegate respondsToSelector:@selector(floorButtonClickedWithIndex:isTotal:)]) {
        [self.delegate floorButtonClickedWithIndex:indexPath.row isTotal:_isTotal];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    for(UITableViewCell * cell in cellArray){
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)reloadTable
{
    for(UITableViewCell * cell in cellArray){
        cell.textLabel.textColor = [UIColor blackColor];
    }
    [tableView reloadData];
}

@end







