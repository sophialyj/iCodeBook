//
//  UIMainView.m
//  iCodebook
//
//  Created by Yijie Li on 7/1/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import "UIMainView.h"

@interface UIMainView ()

// Background Image
@property (nonatomic, strong) UIImage * backgroundImage;

@end

@implementation UIMainView

- (instancetype) init {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    if (self) {
        // Set Background
        _backgroundImage = [UIImage imageNamed:@"TableViewBackground.png"];
        self.backgroundView = [[UIImageView alloc] initWithImage:_backgroundImage];
        
        // Set Separator
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        // Set Mask
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self setBackgroundColor:[UIColor whiteColor]];
}


@end
