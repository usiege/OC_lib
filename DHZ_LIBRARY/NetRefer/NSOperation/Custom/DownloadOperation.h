//
//  DownloadOperation.h
//  DHZ_LIBRARY
//
//  Created by Hello,world! on 16/4/11.
//  Copyright © 2016年 Hello,world!. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadOperationDelegate <NSObject>
@optional
- (void)downloadOperation:(id)operation didFinishDownload:(UIImage *)image;

@end
@interface DownloadOperation : NSOperation

@property (nonatomic,copy) NSString* imageURL;

@property (nonatomic,weak) id<DownloadOperationDelegate> delegate;

@end
