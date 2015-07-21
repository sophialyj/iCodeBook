//
//  ViewController.m
//  iCodebook
//
//  Created by Yijie Li on 6/29/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//
#import <LocalAuthentication/LocalAuthentication.h>
#import "ViewController.h"
#import "RootViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init {
    RootViewController *root = [[RootViewController alloc] init];
    self = [super initWithRootViewController:root];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
