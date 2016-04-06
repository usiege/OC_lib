//
//  DHZ_LIBRARYTests.m
//  DHZ_LIBRARYTests
//
//  Created by Hello,world! on 14/12/29.
//  Copyright (c) 2014年 Hello,world!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSString+Collection.h"


@interface DHZ_LIBRARYTests : XCTestCase

@end

@implementation DHZ_LIBRARYTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSString *my_string = @"130725199012111812";
    NSLog(@"身份证号码验证结果：%d",[NSString fitToChineseIDWithString:my_string]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
