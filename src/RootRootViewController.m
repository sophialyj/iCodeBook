//
//  RootRootViewController.m
//  iCodebook
//
//  Created by Yijie Li on 7/10/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "RootRootViewController.h"
#import "ViewController.h"
#import "AboutTableViewController.h"
#import "ButtonMaker.h"

@interface RootRootViewController ()

@property (nonatomic, strong) ViewController * defaultViewController;
@property (nonatomic, strong) AboutTableViewController * sideViewController;

@property (nonatomic, strong) UIBarButtonItem * vault;
@property (nonatomic, strong) UIBarButtonItem * about;


@end

@implementation RootRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.defaultViewController = [[ViewController alloc] init];
    self.sideViewController    = [[AboutTableViewController alloc] init];
    
    UITabBarItem * defaultTabItem = [[UITabBarItem alloc] initWithTitle:@"Codebook" image:[UIImage imageNamed:@"vaultDeselect.png"] tag:0];
    
    UITabBarItem * moreTabItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];
    
    _defaultViewController.tabBarItem = defaultTabItem;
    
    UINavigationController * sideView = [[UINavigationController alloc] initWithRootViewController:_sideViewController];
    
    sideView.tabBarItem    = moreTabItem;
    
    [self setViewControllers: [NSArray arrayWithObjects:_defaultViewController, sideView, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
