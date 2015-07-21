//
//  TableCellContent.h
//  iCodebook
//
//  An abstract class that represents an abstract cell content
//  In a table view object.
//  Created by Yijie Li on 7/7/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#ifndef __TABLE_CELL__
#define __TABLE_CELL__

#import <Foundation/Foundation.h>

@interface TableCellContent : NSObject

@property (nonatomic, strong) NSString * nameOfClass;

// Common constructor for a cell
-(instancetype) initWithTitle: (NSString *) title;

-(instancetype) initWithTitle: (NSString *) title
               withDescriptor: (NSString *) descriptor;

// setter and getters
-(NSString *)   getTitle;
-(void)         setTitle: (NSString *) title;

-(NSString *)   getDescriptor;
-(void)         setDescriptor: (NSString *) descriptor;

-(BOOL)         isContainExtraInfo;

// TODO: categorize item
-(NSString *)   getCategory;
-(void)         setCategory: (NSString *) category;

// TODO: Date component

@end

#endif
