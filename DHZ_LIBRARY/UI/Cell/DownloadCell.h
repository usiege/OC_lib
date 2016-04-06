//
//  DownloadCell.h
//  FMMapKit
//
//  Created by Hello,world! on 15/6/29.
//  Copyright (c) 2015年 Hello,world!. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progessView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
