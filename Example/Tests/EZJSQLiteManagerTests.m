//
//  EZJEZJSQLiteManagerTests.m
//  EZJUserDataCollectorLibIOS
//
//  Created by Apple on 15/12/11.
//  Copyright © 2015年 zhangjing. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZJSQLiteManager.h"

@interface EZJSQLiteManagerTests : XCTestCase

@end

@implementation EZJSQLiteManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateDatabase{
    
    XCTAssert(NO,"必须返回真");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
