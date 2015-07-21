//
//  BaseTableTableViewController.h
//  iCodebook
//
//  Created by Yijie Li on 7/7/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//
#ifndef __BASE_TABLE__
#define __BASE_TABLE__

#import <UIKit/UIKit.h>
#import "UIMainView.h"
#import "RootCellView.h"
#import "TableCellContent.h"
#import "CBModel.h"

@interface BaseTableTableViewController : UITableViewController

@property (nonatomic, strong) CBModel * model;

@property (nonatomic, strong) NSMutableArray * cells;

@end

#endif
