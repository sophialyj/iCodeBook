//
//  SearchResultsViewController.m
//  iCodebook
//
//  Created by Yijie Li on 7/7/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import "SearchResultsViewController.h"

@interface SearchResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cells = [self.cells init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
