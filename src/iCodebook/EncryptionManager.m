//
//  EncryptionManager.m
//  iCodebook
//  This is an implementation of EncryptionManager
//  API function - CCcrypt is used for generating AES128
//  keys.
//  
//  Created by Yijie Li on 6/29/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import "EncryptionManager.h"

const CCAlgorithm algo      = kCCAlgorithmAES128;
const NSUInteger  keySize   = kCCKeySizeAES128;
const NSUInteger  blockSize = kCCBlockSizeAES128;
const NSUInteger  ivSize    = kCCBlockSizeAES128;
const NSUInteger  saltSize  = 8;
const NSUInteger  rounds    = 33333;

// Some private methods
static NSData *
stringToData (NSString * _keyString) {
    return [_keyString
            dataUsingEncoding:NSUTF16StringEncoding];
}

static NSString *
dataToString (NSData * _keyData) {
    return [[NSString alloc]
            initWithData:_keyData
            encoding:NSUTF16StringEncoding];
}

// Using MD5 to hash _keyString
static NSData *
createIv (NSString * _keyString) {
    const char * array = [_keyString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(array, strlen(array), digest);
    return [NSMutableData dataWithBytes:digest length:sizeof(unsigned char) * CC_MD5_DIGEST_LENGTH];
}

// Using SHA-1 to hash _keyString
static NSData *
createSalt (NSString * _keyString) {
    const char * array = [_keyString UTF8String];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(array, strlen(array), digest);
    return [[NSData dataWithBytes:digest length:sizeof(unsigned char) * CC_SHA1_DIGEST_LENGTH] subdataWithRange:NSMakeRange(0, 16)];
    
}

static NSData *
AESKeyForPassword (NSString * _keyString) {
    
    NSMutableData *
    derivedKey = [NSMutableData dataWithLength:keySize];
    
    NSData *
    salt = createSalt(_keyString);
    
    int
    result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                  _keyString.UTF8String,
                                  [_keyString lengthOfBytesUsingEncoding:NSUTF8StringEncoding], salt.bytes, salt.length, kCCPRFHmacAlgSHA1, rounds, derivedKey.mutableBytes, derivedKey.length);
    
    if (result != kCCSuccess)
        NSLog(@"Unable to generate the derived key");
    
    return derivedKey;

}

@implementation EncryptionManager

// Class method to encrypt the user input password
+ (NSData *)   encrypt: (NSString *) _keyString
            withPassword: (NSString *) _passCode {
    
    NSData * iv = createIv(_keyString);
    NSAssert(iv, @"Initial vector can't be successfully created.");
    
    NSData * dKey    = AESKeyForPassword(_keyString);
    NSData * pcData  = stringToData(_passCode);
    
    size_t outLength = 0;
    NSMutableData *
    cipherData = [NSMutableData dataWithLength:pcData.length + blockSize];
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, // operation
                     algo, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     dKey.bytes, // key
                     dKey.length, // keylength
                     iv.bytes,// iv
                     pcData.bytes, // dataIn
                     pcData.length, // dataInLength,
                     cipherData.mutableBytes, // dataOut
                     cipherData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    }
    else {
        NSLog(@"Passcode cannot be encrypted.");
        return nil;
    }
    
    return cipherData;
}

// Class method to decrypt the user input password
+ (NSString *) decrypt: (NSString *) _keyString
          withPassword: (NSData *) _encryptedCode {
    
    NSData * iv = createIv(_keyString);
    NSAssert(iv, @"Initial vector can't be successfully created.");
    
    NSData * dKey    = AESKeyForPassword(_keyString);
    
    size_t outLength = 0;
    NSMutableData *
    decipherData = [NSMutableData dataWithLength:_encryptedCode.length + blockSize];
    
    CCCryptorStatus
    result = CCCrypt(kCCDecrypt, // operation
                     algo, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     dKey.bytes, // key
                     dKey.length, // keylength
                     iv.bytes,// iv
                     _encryptedCode.bytes, // dataIn
                     _encryptedCode.length, // dataInLength,
                     decipherData.mutableBytes, // dataOut
                     decipherData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        decipherData.length = outLength;
    }
    else {
        NSLog(@"Passcode cannot be encrypted.");
        return nil;
    }
    
    return dataToString(decipherData);
    
}

@end
