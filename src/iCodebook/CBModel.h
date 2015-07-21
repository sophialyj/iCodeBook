//
//  CBModel.h
//  iCodebook
//  Data Model: Singleton design
//
//  Since multiple view may have a same model reference, we
//  use singleton design pattern for data model.
//
//  Created by Yijie Li on 7/3/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "EncryptionManager.h"
#import "CellContent.h"

@interface CBModel : NSObject

@property (nonatomic, strong) NSMutableArray * items;

// A wrapper class that loads/add/delete/modify data
// from our DBManager
+(CBModel *)       singleton;

-(void)            loadDataFromDB;

// model wrapper: addData to category
-(NSString *)   addData: (NSString *) _itemName
           fromCategory: (NSString *) _category
      withEncryptedMsg1: (NSString *) _msg1
      withEncryptedMsg2: (NSString *) _msg2
      withEncryptedMsg3: (NSString *) _msg3
               withDate: (NSString *) _date;

// method to modify data
-(NSString *)   modifyData: (NSString *) _itemName
              fromCategory: (NSString *) _category
         withEncryptedMsg1: (NSString *) _msg1
         withEncryptedMsg2: (NSString *) _msg2
         withEncryptedMsg3: (NSString *) _msg3
                  withDate: (NSString *) _date;

// method to delete data
-(BOOL)         deleteData: (NSString *) _itemName
                      from: (NSString *) _category;

// method to query data
-(NSArray *)    query:(NSString *) _itemName
                 from:(NSString *) _category;


-(void)            setKey:(NSString *) _key;
-(void)            deleteAll;

@end
