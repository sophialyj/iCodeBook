//
//  CBModel.m
//  iCodebook
//
//  Created by Yijie Li on 7/3/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import "CBModel.h"

// Our db manager singleton instance: private reference
DBManager* manager;
// key remember in mind; core key
NSString * key;

@implementation CBModel

__strong static CBModel * single = nil;

+(CBModel *)    singleton {
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        single = [[self alloc] init];
    });

    return single;
}

-(instancetype) init{
    self    = [super init];
    key     = nil;
    manager = [DBManager singleton];
    self.items = [[NSMutableArray alloc] init];
    // Initialize the cached data.
    if (self && manager) {
        [self loadDataFromDB];
    }
    return self;
}

-(BOOL)            isDuplicateItem:(NSString *) item{
    return [_items containsObject:item];
}

// This is a smart function to judge whether a return key is valid.
-(BOOL)            isReturnValueValid:(NSString *) password{
    return [password canBeConvertedToEncoding:NSASCIIStringEncoding];
}

// A wrapper class that loads/add/delete/modify data
// from our DBManager
-(void)            loadDataFromDB{
    
    _items  = [[NSMutableArray alloc] initWithArray:[manager loadData]];
    
}

-(NSString *)   addData: (NSString *) _itemName
           fromCategory: (NSString *) _category
      withEncryptedMsg1: (NSString *) _msg1
      withEncryptedMsg2: (NSString *) _msg2
      withEncryptedMsg3: (NSString *) _msg3
               withDate: (NSString *) _date {
    
    if ([self isDuplicateItem: _itemName]) {
        return @"We cannot accept a duplicate item name. One item should only have one password.";
    }
    
    BOOL isSuccess = nil;
    
    TableCellContentWithDate * cell = [[TableCellContentWithDate alloc] initWithTitle:_itemName withDescriptor:nil withDate:_date];
    
    if ([_category isEqualToString:@"website"]) {
        isSuccess = [manager insertData:_itemName withEncryptedUsernm:[EncryptionManager encrypt:key withPassword:_msg1] withEncryptedPasswd:[EncryptionManager encrypt:key withPassword:_msg2] withDate:_date];
        [cell setCategory:@"website"];
    }
    
    else if ([_category isEqualToString:@"creditcard"]) {
        isSuccess = [manager insertData:_itemName withEncryptedCreNum:[EncryptionManager encrypt:key withPassword:_msg1] withEncryptedExpDate:[EncryptionManager encrypt:key withPassword:_msg2] withSecCode:[EncryptionManager encrypt:key withPassword:_msg3] withDate:_date];
        [cell setCategory:@"creditcard"];
    }
    
    else {
        isSuccess = [manager insertData:_itemName withEncryptedMsg1:[EncryptionManager encrypt:key withPassword:_msg1] withEncryptedMsg2:[EncryptionManager encrypt:key withPassword:_msg2] withEncryptedMsg3:[EncryptionManager encrypt:key withPassword:_msg3] withDate:_date];
        [cell setCategory:@"other"];
    }
    
    key = nil;
    
    if (isSuccess) {
        [_items addObject:cell];
        return @"New password added successfully.";
    } else {
        return @"New password added failed.";
    }

    
}

-(BOOL)      deleteData:(NSString *) _itemName
                   from:(NSString *) _category{
    
    BOOL isSuccess = [manager deleteData:_itemName from:_category];
    key = nil;
    if (isSuccess) {
        for (TableCellContent * cell in _items) {
            if ([[cell getTitle] isEqualToString:_itemName]) {
                [_items removeObject:cell];
                break;
            }
        }
        return YES;
    } else {
        return NO;
    }
    
}

-(NSString *)   modifyData: (NSString *) _itemName
              fromCategory: (NSString *) _category
         withEncryptedMsg1: (NSString *) _msg1
         withEncryptedMsg2: (NSString *) _msg2
         withEncryptedMsg3: (NSString *) _msg3
                  withDate: (NSString *) _date {
    
    BOOL isSuccess = nil;
    
    if ([_category isEqualToString:@"website"]) {
        isSuccess = [manager modifiedData:_itemName withEncryptedUsernm:[EncryptionManager encrypt:key withPassword:_msg1] withEncryptedPasswd:[EncryptionManager encrypt:key withPassword:_msg2] withDate:_date];
    }
    
    else if ([_category isEqualToString:@"creditcard"]) {
        isSuccess = [manager modifiedData:_itemName withEncryptedCreNum:[EncryptionManager encrypt:key withPassword:_msg1] withEncryptedExpDate:[EncryptionManager encrypt:key withPassword:_msg2] withSecCode:[EncryptionManager encrypt:key withPassword:_msg3] withDate:_date];
    }
    
    else {
        isSuccess = [manager modifiedData:_itemName withEncryptedMsg1:[EncryptionManager encrypt:key withPassword:_msg1] withEncryptedMsg2:[EncryptionManager encrypt:key withPassword:_msg2] withEncryptedMsg3:[EncryptionManager encrypt:key withPassword:_msg3] withDate:_date];
    }
    
    key = nil;
    
    if (isSuccess) {
        return @"Password is successfully modified.";
    } else {
        return @"Password modification failure.";
    }
}

-(NSArray *)    query:(NSString *) _itemName
                 from:(NSString *) _category {
    
    NSArray * data = [manager query:_itemName from:_category];
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    if (data) {
        [result addObject:@"nil"];
        for (int i = 1; i < [data count] - 1; i++) {
            NSString * probResult = [EncryptionManager decrypt:key withPassword:data[i]];
            if ([self isReturnValueValid:probResult]) {
                [result addObject:probResult];
            } else {
                [result setObject:@"Your essential key may not be correct." atIndexedSubscript:0];
                return result;
            }
        }
    } else {
        [result addObject:@"Query data failed"];
    }
    key = nil;
    return result;
    
}

-(void)            setKey:(NSString *) newKey{
    key = newKey;
}

-(void)            dealloc {
    // cleanup and close DB
    [manager closeDB];
    manager = nil;
    key     = nil;
}

-(void)            deleteAll {
    if (manager != nil) {
        [manager deleteAll];
    }
}

@end
