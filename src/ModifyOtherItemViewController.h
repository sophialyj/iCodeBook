//
//  ModifyOtherItemViewController.h
//  iCodebook
//
//  Created by Yijie Li on 7/21/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddItemTableView.h"
#import "CBModel.h"

@interface ModifyOtherItemViewController : UITableViewController

@property (nonatomic, strong) UITextField * msg1;
@property (nonatomic, strong) UITextField * msg2;
@property (nonatomic, strong) UITextField * msg3;
@property (nonatomic, strong) UITextField * key;

-(void) setModel: (CBModel *) model;
-(void) setItemString: (NSString *) itemString;

@end
