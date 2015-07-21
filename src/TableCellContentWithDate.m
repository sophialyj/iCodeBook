//
//  TableCellContentWithDate.m
//  iCodebook
//
//  Created by Yijie Li on 7/7/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "TableCellContentWithDate.h"

@interface TableCellContentWithDate ()

@property (nonatomic, strong) NSString * date;

@end

@implementation TableCellContentWithDate

//Override SuperClass init methods
-(instancetype) initWithTitle:(NSString *)title withDescriptor:(NSString *)descriptor withDate:(NSString *)date{
    self = [super initWithTitle:title withDescriptor:descriptor];
    self.date = date;
    self.nameOfClass = @"TableCellContentWithDate";
    return self;
}

-(NSString *)     getDate{
    return _date;
}

-(NSComparisonResult) compare: (TableCellContentWithDate *) otherCell {
    return [[self getTitle] caseInsensitiveCompare:[otherCell getTitle]];
}

@end
