//
//  AddItemViewController.h
//  iCodebook
//
//  Created by Yijie Li on 7/4/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemTableView.h"
#import "CBModel.h"

@interface AddItemViewController : UITableViewController

@property (nonatomic, strong) UITextField * itemName;
@property (nonatomic, strong) UITextField * username;
@property (nonatomic, strong) UITextField * password;
@property (nonatomic, strong) UITextField * passwordConfirm;
@property (nonatomic, strong) UITextField * key;

-(void) setModel: (CBModel *) model;

@end
