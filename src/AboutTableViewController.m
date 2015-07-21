//
//  AboutTableViewController.m
//  iCodebook
//
//  Created by Yijie Li on 7/10/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "AboutTableViewController.h"
#import "AboutTextViewController.h"
@import MessageUI;

@interface AboutTableViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation AboutTableViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        UITableView * aboutTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
        
        self.navigationItem.title = @"More...";
        
        // Set Separator
        [aboutTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
        
        // Set Mask
        aboutTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        self.tableView = aboutTable;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"About";
        [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18.0]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"Email Author To Report Bugs";
        [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18.0]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if (indexPath.section == 2) {
        cell.textLabel.text = @"Synchronize Vaults to iCloud";
        [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:18.0]];
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Open Up a About.
    if (indexPath.section == 0) {
        AboutTextViewController * aboutText = [[AboutTextViewController alloc] init];
        [self.navigationController pushViewController:aboutText animated:YES];
    }
    
    // Sending mail
    else if(indexPath.section == 1) {
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        
        [mailController setToRecipients:[NSArray arrayWithObjects:@"davislong198833@gmail.com",nil]];
        
        [mailController setSubject:@"Bug Report For iCodeBook v1.0"];
        [mailController setMessageBody:@"Please describe your bug so that we can repeat it. Thanks.\n" isHTML:NO];
        mailController.mailComposeDelegate = self;
        
        UINavigationController *myNavController = [self navigationController];
        
        if ( mailController != nil ) {
            if ([MFMailComposeViewController canSendMail]){
                [myNavController presentModalViewController:mailController animated:YES];
            }
        } else {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Bug Report" message:@"Your email account may not be setup on this iPhone." preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if(indexPath.section == 2) {
        [self invokeIcloud];
    } else {
        return;
    }
}

- (void)invokeIcloud {
    
}

- (void)mailComposeController:(nonnull MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}


@end
