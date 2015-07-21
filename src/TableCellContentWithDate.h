//
//  TableCellContentWithDate.h
//  iCodebook
//
//  Created by Yijie Li on 7/7/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "TableCellContent.h"

@interface TableCellContentWithDate : TableCellContent

-(instancetype) initWithTitle:(NSString *) title
               withDescriptor:(NSString *) descriptor
                     withDate:(NSString *) date;

-(NSString *)     getDate;
-(void)         setDate: (NSString *) date;

-(NSComparisonResult) compare: (TableCellContentWithDate *) otherCell;

@end
