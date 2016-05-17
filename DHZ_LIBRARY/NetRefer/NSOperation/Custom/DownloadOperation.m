//
//  DownloadOperation.m
//  DHZ_LIBRARY
//
//  Created by Hello,world! on 16/4/11.
//  Copyright © 2016年 Hello,world!. All rights reserved.
//

#import "DownloadOperation.h"

@implementation DownloadOperation

//被添加到queue中会自动调用该方法
- (void)main
{
    //自己创建自动释放池
    @autoreleasepool {
        
        if(self.isCancelled) return;
        
        NSURL* URL = [NSURL URLWithString:self.imageURL];
        NSData* data = [NSData dataWithContentsOfURL:URL];
        UIImage* image = [UIImage imageWithData:data];
        
        if(self.isCancelled) return;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([self.delegate respondsToSelector:@selector(downloadOperation:didFinishDownload:)]) {
                [self.delegate downloadOperation:self didFinishDownload:image];
            }
        }];
    }
}

@end

