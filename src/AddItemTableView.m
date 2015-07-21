//
//  AddItemTableView.m
//  iCodebook
//
//  Created by Yijie Li on 7/4/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import "AddItemTableView.h"

@implementation AddItemTableView

UIImage * backgroundImage;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype) init {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    if (self) {
        // Set Background
        backgroundImage = [UIImage imageNamed:@"TableViewBackground.png"];
        self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        
        // Set Separator
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        // Set Mask
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    
    return self;
}

@end
