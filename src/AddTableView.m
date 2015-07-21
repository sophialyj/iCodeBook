//
//  AddTableView.m
//  iCodebook
//
//  Created by Yijie Li on 7/15/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "AddTableView.h"

@interface AddTableView ()
@end

@implementation AddTableView

- (instancetype) init {
    
    int width  = [[UIScreen mainScreen] bounds].size.width;
    self = [super initWithFrame:CGRectMake(width - 130, 67, 120, 132)];
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    
    self.layer.shadowColor = [UIColor colorWithRed:77.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:.8].CGColor;
    self.layer.shadowRadius = 10.0;
    self.layer.shadowOffset = CGSizeMake(10.0, 10.0);
    self.layer.opacity = 1.0;
    
    [self setBackgroundColor:[UIColor colorWithRed:77.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:.8]];
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self setSeparatorColor:[UIColor colorWithRed:229.0f/255.0f green:238.0f/255.0f blue:246.0f/255.0f alpha:1.0]];
    [self setSeparatorInset: UIEdgeInsetsZero];
    return self;
    
}


@end
