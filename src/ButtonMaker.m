//
//  ButtonMaker.m
//  iCodebook
//
//  Created by Yijie Li on 7/10/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "ButtonMaker.h"

@implementation ButtonMaker

+ (UIButton *) makeVaultButton{
    
    ButtonMaker * maker = [[super alloc] init];
    return [maker makeButton:@"Vault" withImage:nil];
    
}

+ (UIButton *) makeAboutButton{
    
    ButtonMaker * maker = [[super alloc] init];
    return [maker makeButton:@"About" withImage:nil];
    
}

- (UIButton *) makeButton: (NSString *) title
                withImage: (UIImage *) image {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.titleLabel.font = [UIFont fontWithName:@"Copperplate" size:14];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    //button.autoresizesSubviews = YES;
    //button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    
    button.showsTouchWhenHighlighted = YES;
    
    return button;
    
}

@end
