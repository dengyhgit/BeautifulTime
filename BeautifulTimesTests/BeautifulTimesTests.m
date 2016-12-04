//
//  BeautifulTimesTests.m
//  BeautifulTimesTests
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AFNetworking.h"
#import "BTNetManager+BTAddJournal.h"

#define WAIT do {\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

@interface BeautifulTimesTests : XCTestCase

@end

@implementation BeautifulTimesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

-(void)testRequest{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    // 2.发送GET请求
    [manager GET:@"http://www.weather.com.cn/adat/sk/101110101.html" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        XCTAssertNotNil(responseObject, @"返回出错");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        XCTAssertNil(error, @"请求出错");
    }];
    WAIT  //暂停
}

- (void)testWeatherInfo {
    [BTNetManager netManagerReqeustWeatherInfo:@"深圳" successCallback:^(NSDictionary *retDict) {
        NSLog(@"%@", retDict);
        XCTAssertNotNil(retDict, @"返回出错");
    } failCallback:^(NSError *error) {
        NSLog(@"Error Info: %@", error);
        return;
    }];
    WAIT
}

@end
