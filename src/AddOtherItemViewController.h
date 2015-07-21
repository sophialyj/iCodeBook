//
//  AddOtherItemViewController.h
//  iCodebook
//
//  Created by Yijie Li on 7/16/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBModel.h"

@interface AddOtherItemViewController : UITableViewController

@property (nonatomic, strong) UITextField * itemName;
@property (nonatomic, strong) UITextField * encrypted1;
@property (nonatomic, strong) UITextField * encrypted2;
@property (nonatomic, strong) UITextField * encrypted3;
@property (nonatomic, strong) UITextField * key;

-(void) setModel: (CBModel *) model;

@end
