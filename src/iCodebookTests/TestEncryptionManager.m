//
//  TestEncryptionManager.m
//  iCodebook
//
//  Created by Yunlong Liu on 6/30/15.
//  Copyright (c) 2015 Yunlong Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "EncryptionManager.h"

@interface TestEncryptionManager : XCTestCase

@property (nonatomic, strong) NSData * testData;

@end

@implementation TestEncryptionManager

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testEncryptions {
    // Test Group 1
    NSData * encryptedData = [EncryptionManager encrypt:@"testKey" withPassword:@"testPassword"];
    NSString * decryptedString = [EncryptionManager decrypt:@"testKey" withPassword:encryptedData];
    
    XCTAssertEqualObjects(decryptedString, @"testPassword", @"Encryption test 1 failed");
    
    // Test Group 2
    encryptedData = [EncryptionManager encrypt:@"987654321" withPassword:@"testPassword"];
    decryptedString = [EncryptionManager decrypt:@"987654321" withPassword:encryptedData];
    
    XCTAssertEqualObjects(decryptedString, @"testPassword", @"Encryption test 2 failed");
    
    // Test Group 3
    encryptedData = [EncryptionManager encrypt:@"JHUstudent@#$" withPassword:@"testPassword"];
    decryptedString = [EncryptionManager decrypt:@"JHUstudent@#$" withPassword:encryptedData];
    
    XCTAssertEqualObjects(decryptedString, @"testPassword", @"Encryption test 3 failed");
    
    // Test Group 4
    encryptedData = [EncryptionManager encrypt:@"JHUstudent@#$" withPassword:@"SuperLongSuperLong@password"];
    decryptedString = [EncryptionManager decrypt:@"JHUstudent@#$" withPassword:encryptedData];
    
    XCTAssertEqualObjects(decryptedString, @"SuperLongSuperLong@password", @"Encryption test 4 failed");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
