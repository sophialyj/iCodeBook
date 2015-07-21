//
//  DBManager.h
//  iCodebook
//
//  Created by Yijie Li on 6/29/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

// The location of the database.
@property (nonatomic, strong) NSString * _dbPath;

// Singleton design pattern. The whole project share only one
// dbmanager instance.
+(DBManager*)   singleton;

// Methods for the DBManager
// This method initialize a db handle. The app will create a
// new db file when running the first time. Then it will just
// open the same file.
-(BOOL)         createDB;

// method to insert data.
-(BOOL)         insertData: (NSString *) _itemName
       withEncryptedUsernm: (NSData *) _username
       withEncryptedPasswd: (NSData *) _pwd
                  withDate: (NSString *) _date;

-(BOOL)         insertData: (NSString *) _itemName
       withEncryptedCreNum: (NSData *) _cardnumber
      withEncryptedExpDate: (NSData *) _expDate
               withSecCode: (NSData *) _code
                  withDate: (NSString *) _date;

-(BOOL)         insertData: (NSString *) _itemName
         withEncryptedMsg1: (NSData *) _msg1
         withEncryptedMsg2: (NSData *) _msg2
         withEncryptedMsg3: (NSData *) _msg3
                  withDate: (NSString *) _date;

// method to modify data
-(BOOL)       modifiedData: (NSString *) _itemName
       withEncryptedUsernm: (NSData *) _username
       withEncryptedPasswd: (NSData *) _pwd
                  withDate: (NSString *) _date;

-(BOOL)       modifiedData: (NSString *) _itemName
       withEncryptedCreNum: (NSData *) _cardnumber
      withEncryptedExpDate: (NSData *) _expiredate
               withSecCode: (NSData *)  _seccode
                  withDate: (NSString *) _date;

-(BOOL)       modifiedData: (NSString *) _itemName
         withEncryptedMsg1: (NSData *)  _msg1
         withEncryptedMsg2: (NSData *)  _msg2
         withEncryptedMsg3: (NSData *)  _msg3
                  withDate: (NSString *) _date;

// method to delete data
-(BOOL)         deleteData: (NSString *) _itemName
                      from: (NSString *) _category;

// method to load all the item
-(NSArray *)    loadData;

// method to delete all the items
-(BOOL)         deleteAll;

// method to query data
-(NSArray *) query:(NSString *) _itemName
              from:(NSString *) _category;

-(void)         closeDB;

@end
