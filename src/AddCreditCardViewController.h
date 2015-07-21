//
//  AddCreditCardViewController.h
//  iCodebook
//
//  Created by Yijie Li on 7/16/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBModel.h"

@interface AddCreditCardViewController : UITableViewController

@property (nonatomic, strong) UITextField * itemName;
@property (nonatomic, strong) UITextField * cardNumber;
@property (nonatomic, strong) UITextField * expireDate;
@property (nonatomic, strong) UITextField * securityCode;
@property (nonatomic, strong) UITextField * key;

-(void) setModel: (CBModel *) model;

@end
