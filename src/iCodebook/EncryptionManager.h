//
//  EncryptionManager.h
//  iCodebook
//
//  EncryptionManager provides standard AES128 cryptographic
//  method to encrypt the user's secret. Two class methods:
//    encrypt, decrypt.
//
//  Created by Yijie Li on 6/29/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@interface EncryptionManager : NSObject

// Class method to encrypt the user input password
+ (NSData *)   encrypt: (NSString *) _keyString
            withPassword: (NSString *) _passCode;

// Class method to decrypt the user input password
+ (NSString *)   decrypt: (NSString *) _keyString
            withPassword: (NSData *) _encryptedCode;

@end
