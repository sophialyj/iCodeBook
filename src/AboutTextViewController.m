//
//  AboutTextViewController.m
//  iCodebook
//
//  Created by Yijie Li on 7/11/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "AboutTextViewController.h"

@interface AboutTextViewController ()

@end

@implementation AboutTextViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"About iCodebook";
    [self.view.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.view.layer setBorderWidth:12.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.view.layer.cornerRadius = 15;
    self.view.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
