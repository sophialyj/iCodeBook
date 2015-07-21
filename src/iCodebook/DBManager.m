//
//  DBManager.m
//  iCodebook
//
//  TODO: v2.0 - change itemName to TableContentCell
//  to support multiple categories of cell.
//  Created by Yijie Li on 6/29/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import "DBManager.h"
#import "CellContent.h"

// private fields:
//   dbHandle : the database handle
//   dbManager: the singleton shared object
//   loadDataStmt: the stmt used by loading data

static sqlite3   * dbHandle        = nil;
static DBManager * dbManager       = nil;
static sqlite3_stmt * sqlStmt      = nil;

static NSString * _dbFileName = @"iCodeBook-newnew.db";

// sql statements const
const NSString * createTableStmt = @"create table if not exists ";

// State boolean
static BOOL tableCreated = NO;

@implementation DBManager

+(DBManager*)   singleton {
    if (!dbManager) {
        dbManager = [[super allocWithZone:NULL] init];
        BOOL successOrNot = [dbManager createDB];
        NSAssert(successOrNot, @"DBManager cannot be initialized.");
    }
    return dbManager;
}

-(BOOL) createDB {
    NSArray * paths      = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * directory = paths[0];
    
    self._dbPath         = [[NSString alloc]
                            initWithString:
                            [directory
                             stringByAppendingPathComponent:
                             _dbFileName]];
    
    BOOL isSuccess       = YES;
    const char * dbpath = [self._dbPath UTF8String];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self._dbPath]) {
        tableCreated = YES;
    }
    
    if (sqlite3_open(dbpath, &dbHandle) != SQLITE_OK) {
        NSLog(@"Cannot open the database storage file.");
        return NO;
    }
    
    // Doesn't put table creation lazy since it cost almost none.
    if (!tableCreated) {
        char * errMsg   =  nil;
        // Create tables at the very beginning
        char * sql_stmt =
        "create table if not exists passwd (name text primary key, username blob, passwd blob, date text)";
        
        if (sqlite3_exec(dbHandle, sql_stmt, NULL, NULL, &errMsg)
            != SQLITE_OK)
        {
            isSuccess = NO;
            NSLog(@"SQL: Failed to create table");
            return isSuccess;
        }
        
        sql_stmt = "create table if not exists creditcard (name text primary key, cardnumber blob, expiredate blob, seccode blob, date text)";
        
        if (sqlite3_exec(dbHandle, sql_stmt, NULL, NULL, &errMsg)
            != SQLITE_OK)
        {
            isSuccess = NO;
            NSLog(@"SQL: Failed to create table");
            return isSuccess;
        }
        
        sql_stmt = "create table if not exists otherthing (name text primary key, msg1 blob, msg2 blob, msg3 blob, date text)";
        
        if (sqlite3_exec(dbHandle, sql_stmt, NULL, NULL, &errMsg)
            != SQLITE_OK)
        {
            isSuccess = NO;
            NSLog(@"SQL: Failed to create table");
            return isSuccess;
        }

    }
    return isSuccess;
    
}

// methods to insert data.
-(BOOL) insertData:(NSString *) _itemName
withEncryptedUsernm: (NSData *) _username
withEncryptedPasswd: (NSData *) _pwd
           withDate: (NSString *) _date {
    
    BOOL isSuccess = NO;
    
    if (!dbHandle) {
        NSLog(@"While inserting data, db ref lost.");
        return isSuccess;
    }
    
    // build our insert statement.
    const char * insertStmt = "insert into passwd(name, username, passwd, date) values (?,?,?,?)";
    
    if (sqlite3_prepare_v2(dbHandle, insertStmt, -1, &sqlStmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(sqlStmt, 1, [_itemName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_blob(sqlStmt, 2, [_username bytes], (int)[_username length], SQLITE_TRANSIENT);
        sqlite3_bind_blob(sqlStmt, 3, [_pwd bytes], (int)[_pwd length], SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStmt, 4, [_date UTF8String], -1, SQLITE_TRANSIENT);
        // execute our sql statement
        sqlite3_step(sqlStmt);
        // clean up
        sqlite3_finalize(sqlStmt);
        isSuccess = YES;
    } else {
        NSLog(@"sql: insert statement preparation failed.");
    }
    return isSuccess;
}

-(BOOL) insertData:(NSString *) _itemName
withEncryptedCreNum: (NSData *) _cardnumber
withEncryptedExpDate: (NSData *) _expDate
       withSecCode:(NSData *) _code
          withDate: (NSString *) _date {
    
    BOOL isSuccess = NO;
    
    if (!dbHandle) {
        NSLog(@"While inserting data, db ref lost.");
        return isSuccess;
    }
    
    // build our insert statement.
    const char * insertStmt = "insert into creditcard(name, cardnumber, expiredate, seccode, date) values (?,?,?,?,?)";
    
    if (sqlite3_prepare_v2(dbHandle, insertStmt, -1, &sqlStmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(sqlStmt, 1, [_itemName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_blob(sqlStmt, 2, [_cardnumber bytes], (int)[_cardnumber length], SQLITE_TRANSIENT);
        sqlite3_bind_blob(sqlStmt, 3, [_expDate bytes], (int)[_expDate length], SQLITE_TRANSIENT);
        sqlite3_bind_blob(sqlStmt, 4, [_code bytes], (int)[_expDate length], SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStmt, 5, [_date UTF8String], -1, SQLITE_TRANSIENT);
        // execute our sql statement
        sqlite3_step(sqlStmt);
        // clean up
        sqlite3_finalize(sqlStmt);
        isSuccess = YES;
    } else {
        NSLog(@"sql: insert statement preparation failed.");
    }
    return isSuccess;
}

-(BOOL) insertData:(NSString *) _itemName
withEncryptedMsg1: (NSData *) _msg1
withEncryptedMsg2: (NSData *) _msg2
withEncryptedMsg3:(NSData *) _msg3
withDate: (NSString *) _date {
    
    BOOL isSuccess = NO;
    
    if (!dbHandle) {
        NSLog(@"While inserting data, db ref lost.");
        return isSuccess;
    }
    
    // build our insert statement.
    const char * insertStmt = "insert into otherthing(name, msg1, msg2, msg3, date) values (?,?,?,?,?)";
    
    if (sqlite3_prepare_v2(dbHandle, insertStmt, -1, &sqlStmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(sqlStmt, 1, [_itemName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_blob(sqlStmt, 2, [_msg1 bytes], (int)[_msg1 length], SQLITE_TRANSIENT);
        sqlite3_bind_blob(sqlStmt, 3, [_msg2 bytes], (int)[_msg2 length], SQLITE_TRANSIENT);
        sqlite3_bind_blob(sqlStmt, 4, [_msg3 bytes], (int)[_msg3 length], SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStmt, 5, [_date UTF8String], -1, SQLITE_TRANSIENT);
        // execute our sql statement
        sqlite3_step(sqlStmt);
        // clean up
        sqlite3_finalize(sqlStmt);
        isSuccess = YES;
    } else {
        NSLog(@"sql: insert statement preparation failed.");
    }
    return isSuccess;
}

// method to modify data
-(BOOL) modifiedData:(NSString *) _itemName
 withEncryptedUsernm: (NSData *) _username
 withEncryptedPasswd: (NSData *) _pwd
            withDate: (NSString *) _date {
    BOOL first = [dbManager deleteData:_itemName from:@"website"];
    BOOL second = [dbManager insertData:_itemName withEncryptedUsernm:_username withEncryptedPasswd:_pwd withDate:_date];
    if (first && second){
        return YES;
    } else {
        NSLog(@"The passwd is not successfully modified!");
        return NO;
    }
}

-(BOOL)     modifiedData:(NSString *) _itemName
     withEncryptedCreNum: (NSData *) _cardnumber
    withEncryptedExpDate: (NSData *) _expiredate
             withSecCode:(NSData *)  _seccode
                withDate: (NSString *) _date {
    
    BOOL first = [dbManager deleteData:_itemName from:@"creditcard"];
    BOOL second = [dbManager insertData:_itemName withEncryptedCreNum:_cardnumber withEncryptedExpDate:_expiredate withSecCode:_seccode withDate:_date];
    
    if (first && second){
        return YES;
    } else {
        NSLog(@"The passwd is not successfully modified!");
        return NO;
    }
    
}

-(BOOL)     modifiedData: (NSString *) _itemName
       withEncryptedMsg1: (NSData *)  _msg1
       withEncryptedMsg2: (NSData *)  _msg2
       withEncryptedMsg3: (NSData *)  _msg3
                withDate: (NSString *) _date {
    
    BOOL first = [dbManager deleteData:_itemName from:@"other"];
    BOOL second = [dbManager insertData:_itemName withEncryptedMsg1:_msg1 withEncryptedMsg2:_msg2 withEncryptedMsg3:_msg3 withDate:_date];
    
    if (first && second){
        return YES;
    } else {
        NSLog(@"The passwd is not successfully modified!");
        return NO;
    }
    
}

// method to delete data
-(BOOL) deleteData:(NSString *) _itemName
              from:(NSString *) _category {
    
    NSString * stmt = nil;
    
    if ([_category isEqualToString:@"website"]) {
        stmt  = [NSString
                 stringWithFormat:@"delete from passwd where name=\"%@\"", _itemName];
    } else if ([_category isEqualToString:@"creditcard"]) {
        stmt  = [NSString
                 stringWithFormat:@"delete from creditcard where name=\"%@\"", _itemName];
    } else if ([_category isEqualToString:@"other"]){
        stmt  = [NSString
                 stringWithFormat:@"delete from otherthing where name=\"%@\"", _itemName];
    } else {
        return NO;
    }
    
    char * errMsg    = nil;
    if(sqlite3_exec(dbHandle, [stmt UTF8String], NULL, NULL,&errMsg) == SQLITE_OK)
    {
        return YES;
    } else {
        NSLog(@"SQL delete error: %@", [NSString stringWithUTF8String:errMsg]);
        return NO;
    }
    
}

// method to load all the item
-(NSArray *) loadData{
    // build our insert statement.
    if (!dbHandle) {
        NSLog(@"While loading data, db ref lost.");
        return nil;
    }
    char * loadStmt = "select name, date from passwd";
    NSMutableArray * items  = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(dbHandle, loadStmt, -1, &sqlStmt, NULL) == SQLITE_OK) {
        // execute our sql statement
        while (sqlite3_step(sqlStmt) == SQLITE_ROW)
        {
            
            NSString * itemName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(sqlStmt, 0)];
            NSString * date = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(sqlStmt, 1)];
            
            TableCellContentWithDate * content = [[TableCellContentWithDate alloc] initWithTitle:itemName withDescriptor:nil withDate:date];
            
            [content setCategory:@"website"];
            [items addObject:content];
        }
        sqlite3_finalize(sqlStmt);
    }
    
    loadStmt = "select name, date from creditcard";
    
    if (sqlite3_prepare_v2(dbHandle, loadStmt, -1, &sqlStmt, NULL) == SQLITE_OK) {
        // execute our sql statement
        while (sqlite3_step(sqlStmt) == SQLITE_ROW)
        {
            NSString * itemName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(sqlStmt, 0)];
            NSString * date = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(sqlStmt, 1)];
            
            TableCellContentWithDate * content = [[TableCellContentWithDate alloc] initWithTitle:itemName withDescriptor:nil withDate:date];
            
            [content setCategory:@"creditcard"];
            [items addObject:content];
        }
        sqlite3_finalize(sqlStmt);
    }
    
    loadStmt = "select name, date from otherthing";
    
    if (sqlite3_prepare_v2(dbHandle, loadStmt, -1, &sqlStmt, NULL) == SQLITE_OK) {
        // execute our sql statement
        while (sqlite3_step(sqlStmt) == SQLITE_ROW)
        {
            NSString * itemName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(sqlStmt, 0)];
            NSString * date = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(sqlStmt, 1)];
            
            TableCellContentWithDate * content = [[TableCellContentWithDate alloc] initWithTitle:itemName withDescriptor:nil withDate:date];
            
            [content setCategory:@"other"];
            [items addObject:content];
        }
        sqlite3_finalize(sqlStmt);
    }
    else {
        NSLog(@"sql: load data statement preparation failed.");
    }
    
    [items sortUsingSelector:@selector(compare:)];
    
    return items;
}

-(BOOL) deleteAll {
    
    char * stmt  = "delete from passwd";
    char * errMsg    = nil;
    if(sqlite3_exec(dbHandle, stmt, NULL, NULL, &errMsg) != SQLITE_OK)
    {
        NSLog(@"SQL deleteAll error: %@", [NSString stringWithUTF8String:errMsg]);
        return NO;
    }
    
    stmt  = "delete from creditcard";
    errMsg    = nil;
    if(sqlite3_exec(dbHandle, stmt, NULL, NULL, &errMsg) != SQLITE_OK)
    {
        NSLog(@"SQL deleteAll error: %@", [NSString stringWithUTF8String:errMsg]);
        return NO;
    }
    
    stmt  = "delete from otherthing";
    if(sqlite3_exec(dbHandle, stmt, NULL, NULL, &errMsg) == SQLITE_OK)
    {
        return YES;
    } else {
        NSLog(@"SQL deleteAll error: %@", [NSString stringWithUTF8String:errMsg]);
        return NO;
    }
    
}

// method to query data
// If multiple records are found,
// We only send back the first one found.
-(NSArray *) query:(NSString *) _itemName
              from:(NSString *) _category {
    
    if (!dbHandle) {
        NSLog(@"While querying data, db ref lost.");
        return nil;
    }
    
    NSString * stmt = nil;
    int colNumber   = 0;
    
    if ([_category isEqualToString:@"website"]) {
        stmt  = [NSString
                 stringWithFormat:@"select * from passwd where name=\"%@\"", _itemName];
        colNumber = 4;
    } else if ([_category isEqualToString:@"creditcard"]) {
        stmt  = [NSString
                 stringWithFormat:@"select * from creditcard where name=\"%@\"", _itemName];
        colNumber = 5;
    } else if ([_category isEqualToString:@"other"]){
        stmt  = [NSString
                 stringWithFormat:@"select * from otherthing where name=\"%@\"", _itemName];
        colNumber = 5;
    } else {
        return nil;
    }

    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:colNumber];
    
    if (sqlite3_prepare_v2(dbHandle, [stmt UTF8String], -1, &sqlStmt, NULL) == SQLITE_OK) {
        // execute our sql statement
        while (sqlite3_step(sqlStmt) == SQLITE_ROW)
        {
            for (int i = 0; i < colNumber; i++) {
                
                @try {
                    [result addObject:[[NSData alloc] initWithBytes:                          sqlite3_column_blob(sqlStmt, i)
                                                             length:sqlite3_column_bytes(sqlStmt, i)]];
                }
                @catch (NSException *exception) {
                    NSLog(@"Query data exception.");
                    result = nil;
                    return result;
                }
                @finally {
                }
                
            }
            break;
        }
        sqlite3_finalize(sqlStmt);
    } else {
        NSLog(@"sql: load data statement preparation failed.");
    }
    
    return result;
    
}

- (void) closeDB {
    if (dbHandle) {
        sqlite3_close(dbHandle);
        dbHandle = nil;
        dbManager = nil;
    } else {
        NSLog(@"db may not be open so can't close.");
    }
}

@end
