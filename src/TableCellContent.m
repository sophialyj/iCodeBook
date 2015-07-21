//
//  TableCellContent.m
//  iCodebook
//
//  Created by Yijie Li on 7/7/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "TableCellContent.h"

@interface TableCellContent ()

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * descriptor;

@property BOOL containExtraInfo;
@property (nonatomic, strong) NSString * category;

@end

@implementation TableCellContent

// Common constructor for a cell
-(instancetype) initWithTitle: (NSString *) title {
    self = [super init];
    self.title = title;
    self.containExtraInfo = NO;
    self.nameOfClass = @"TableCellCount";
    return self;
}

-(instancetype) initWithTitle: (NSString *) title
               withDescriptor: (NSString *) descriptor{
    self = [super init];
    self.title = title;
    self.descriptor = descriptor;
    return self;
}

// setter and getters
-(NSString *)   getTitle{
    return _title;
}
-(void)         setTitle: (NSString *) title{
    _title = title;
}

-(NSString *)   getDescriptor{
    return _descriptor;
}

-(void)         setDescriptor: (NSString *) descriptor{
    _descriptor = descriptor;
}

-(BOOL)         isContainExtraInfo {
    return _containExtraInfo;
}

-(NSString *)          getCategory {
    return _category;
}

-(void)         setCategory:(NSString *)category {
    _category = category;
}

@end
