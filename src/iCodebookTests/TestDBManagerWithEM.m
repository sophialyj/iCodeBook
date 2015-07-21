//
//  TestDBManagerWithEM.m
//  iCodebook
//
//  Created by Yijie Li on 6/30/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "EncryptionManager.h"
#import "DBManager.h"

@interface TestDBManagerWithEM : XCTestCase
// We setup some (name, passwd) pairs
@property (nonatomic, strong) NSArray * pair1;
@property (nonatomic, strong) NSArray * pair2;
@property (nonatomic, strong) NSArray * pair3;
// We setup the db manager
@property (nonatomic, strong) DBManager * db;
@end

@implementation TestDBManagerWithEM

- (void)setUp {
    [super setUp];
    _db = [DBManager singleton];
    _pair1 = [[NSArray alloc] initWithObjects:@"School of Medicine1", [EncryptionManager encrypt:@"testkey" withPassword:@"12344321"],nil];
    _pair2 = [[NSArray alloc] initWithObjects:@"School of Medicine2", [EncryptionManager encrypt:@"testkey" withPassword:@"12345432"],nil];
    _pair3 = [[NSArray alloc] initWithObjects:@"School of Medicine3", [EncryptionManager encrypt:@"testkey" withPassword:@"12346543"],nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [_db closeDB];
    _db    = nil;
    _pair1 = nil;
    _pair2 = nil;
    _pair3 = nil;
}

- (void)testInsert {
    // This is an example of a functional test case.
    BOOL judge1 = [_db insertData:_pair1[0] withEncryptedPasswd:_pair1[1]];
    BOOL judge2 = [_db insertData:_pair2[0] withEncryptedPasswd:_pair2[1]];
    XCTAssertEqual(judge1 && judge2, YES, @"Not insert successful!");
}

- (void)testDelete {
    // This is an example of a functional test case.
    [_db deleteAll];
    [_db insertData:_pair1[0] withEncryptedPasswd:_pair1[1]];
    NSArray * loads = [_db loadData];
    XCTAssertEqual(loads.count, 1, @"TEST DBManager delete: insertData failed!");
    [_db deleteData:_pair1[0]];
    loads = [_db loadData];
    XCTAssertEqual(loads.count, 0, @"TEST DBManager delete: delete failed!");
}

- (void)testQuery {
    [_db deleteAll];
    [_db insertData:_pair1[0] withEncryptedPasswd:_pair1[1]];
    NSData * queryR = [_db query:_pair1[0]];
    XCTAssertEqualObjects(_pair1[1], queryR);
}

- (void)testLoad {
    [_db deleteAll];
    [_db insertData:_pair1[0] withEncryptedPasswd:_pair1[1]];
    [_db insertData:_pair3[0] withEncryptedPasswd:_pair3[1]];
    NSArray * loads = [_db loadData];
    XCTAssertEqual(loads.count, 2, @"TEST DBManager loadData failed!");
    //[_db closeDB];
}

- (void)testDeleteAll {
    [_db insertData:_pair1[0] withEncryptedPasswd:_pair1[1]];
    [_db insertData:_pair3[0] withEncryptedPasswd:_pair3[1]];
    [_db deleteAll];
    NSArray * loads = [_db loadData];
    XCTAssertEqual(loads.count, 0, @"TEST DBManager loadData failed!");
    //[_db closeDB];
}

- (void)testOverAll {
    [_db deleteAll];
    [_db insertData:_pair1[0] withEncryptedPasswd:_pair1[1]];
    [_db insertData:_pair3[0] withEncryptedPasswd:_pair3[1]];
    NSData * queryR = [_db query:_pair1[0]];
    NSString * passCode = [EncryptionManager decrypt:@"testkey" withPassword:queryR];
    NSLog(@"%@", queryR);
    NSLog(@"%@",passCode);
    XCTAssertEqualObjects(passCode, @"12344321");
    [_db deleteAll];
    NSArray * loads = [_db loadData];
    XCTAssertEqual(loads.count, 0, @"TEST DBManager loadData failed!");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
