//
//  RootCellView.m
//  iCodebook
//
//  Created by Yijie Li on 7/5/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import "RootCellView.h"

@implementation RootCellView

- (instancetype)initWithText: (NSString *) labelText
              withImageLabel: (UIImage *)  imageLabel {
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RootCellView"];
    
    [self.imageView setFrame:CGRectMake(5, 5, 40, 40)];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;
    [self.imageView setImage:imageLabel];
    
    // UILabel label
    NSString * firstLetter = [[labelText substringToIndex:1] uppercaseString];
    
    if ([self isReturnValueValid:firstLetter]) {
        UILabel * embedLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 40, 40)];
        embedLabel.text = firstLetter;
        embedLabel.textColor = [UIColor whiteColor];
        [embedLabel setFont:[UIFont fontWithName:@"Papyrus" size:40]];
        embedLabel.adjustsFontSizeToFitWidth = YES;
        [self.imageView addSubview:embedLabel];
    }
    
    // UILabel label item
    self.textLabel.text  = labelText;
    [self.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    self.textLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
    
    self.detailTextLabel.text = nil;
    self.detailTextLabel.textColor = [UIColor darkGrayColor];
    [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:10.0]];
    [self setNeedsLayout];
    
    return self;
}

- (instancetype) initWithText:(NSString *)labelText     withImageLabel:(UIImage *)imageLabel
                withDateAdded:(NSString *) date {
    
    self = [self initWithText:labelText withImageLabel:imageLabel];
    
    self.detailTextLabel.text = [@"Created At " stringByAppendingString:date];
    
    self.detailTextLabel.textColor = [UIColor grayColor];
    [self.detailTextLabel setFont:[UIFont fontWithName:@"GillSans" size:12.0]];
    [self setNeedsLayout];
    
    return self;
    
};

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(BOOL)            isReturnValueValid:(NSString *) password{
    return [password canBeConvertedToEncoding:NSASCIIStringEncoding];
}

@end
