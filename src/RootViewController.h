//
//  RootViewController.h
//  iCodebook
//
//  Created by Yijie Li on 7/3/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBModel.h"
#import "AddItemViewController.h"
#import "SearchResultsViewController.h"

@interface RootViewController : BaseTableTableViewController<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

-(void) resetFirstTimeLoad;

@end
