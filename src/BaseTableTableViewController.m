//
//  BaseTableTableViewController.m
//  iCodebook
//
//  Created by Yijie Li on 7/7/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import "BaseTableTableViewController.h"
#import "ModifyItemViewController.h"
#import "ModifyOtherItemViewController.h"

@interface BaseTableTableViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

// Base Table View decide how to configure cell image.
@property (nonatomic, strong) UIImage * cellImageLabel;

// Boolean values for configuration and control

@end

@implementation BaseTableTableViewController

- (instancetype) init{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _cellImageLabel = [UIImage imageNamed:@"LabelImage.png"];
        _model          = [CBModel singleton];
        _cells          = [NSMutableArray alloc];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIMainView * mainView  = [[UIMainView alloc] init];
    
    // Configure delegate and datasource
    mainView.delegate   = self;
    mainView.dataSource = self;
    
    self.tableView = mainView;
    
    [self.tableView registerClass:[RootCellView class]
           forCellReuseIdentifier:@"RootCellView"];
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Change text label color when selected.
    UITableViewCell * selected = [tableView cellForRowAtIndexPath:indexPath];
    selected.textLabel.textColor = [UIColor redColor];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Create a alert dialog view to handle query.
    UIAlertController * dialog = [UIAlertController alertControllerWithTitle:@"Essential Key Required" message:@"Please enter your essential key. Make sure you are in a secure environment." preferredStyle:UIAlertControllerStyleAlert];
    
    // Add text field.
    [dialog addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Enter your key here";
         textField.secureTextEntry = YES;
     }];
    UIAlertAction *continueAction = [UIAlertAction
                                     actionWithTitle: @"Continue"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         // Get key for input.
                                         NSString *keyInput = ((UITextField *)[dialog.textFields objectAtIndex:0]).text;
                                         NSString *textLabel = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
                                         
                                         UIAlertAction *gotit = [UIAlertAction actionWithTitle:@"Gotcha" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){}];
                                         
                                         UIAlertController * showResult;
                                         
                                         // Check key input
                                         if ([self isEmptyString:keyInput]) {
                                             showResult = [UIAlertController alertControllerWithTitle:@"Failure" message:@"Essential key cannot be empty." preferredStyle:UIAlertControllerStyleAlert];
                                             [showResult addAction:gotit];
                                             [self presentViewController:showResult animated:YES completion:nil];
                                             selected.textLabel.textColor = [UIColor blackColor];
                                             return;
                                         }
                                         
                                         // Query the database
                                         [_model setKey:keyInput];
                                         NSArray * array = [_model query:[_cells[indexPath.row] getTitle] from:[_cells[indexPath.row] getCategory]];
                                         
                                         if (![[array objectAtIndex:0] isEqualToString:@"nil"]) {
                                             showResult = [UIAlertController alertControllerWithTitle:@"Failure" message:[array objectAtIndex:0]preferredStyle:UIAlertControllerStyleAlert];
                                         } else {
                                             showResult = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Result for %@", textLabel] message:[self composeResult:array withCategory:[_cells[indexPath.row] getCategory]] preferredStyle:UIAlertControllerStyleActionSheet];
                                         }
                                         
                                         [showResult addAction:gotit];
                                         [self presentViewController:showResult animated:YES completion:nil];
                                         selected.textLabel.textColor = [UIColor blackColor];
                                     }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       selected.textLabel.textColor = [UIColor blackColor];
                                   }];
    
    [dialog addAction:continueAction];
    [dialog addAction:cancelAction];
    [self presentViewController:dialog animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cells count];
}

// Configure cell
- (void) configureCell: (UITableViewCell *) cell
        forCellContent: (TableCellContent *) content {
    return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableCellContentWithDate * cellContent = _cells[indexPath.row];
    
    RootCellView * cell = [[RootCellView alloc] initWithText:[cellContent getTitle] withImageLabel:_cellImageLabel];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created on %@", [_cells[indexPath.row] getDate]];
    
    // For further configuration
    if ([cellContent isContainExtraInfo]) {
        [self configureCell:cell forCellContent:cellContent];
    }
    
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [_model deleteData:[self.cells[indexPath.row] getTitle] from:[self.cells[indexPath.row] getCategory]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    
    deleteAction.backgroundColor = [UIColor redColor];
    
    if ([[_cells[indexPath.row] getCategory] isEqualToString: @"website"]) {
        UITableViewRowAction *modifyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Modify" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            ModifyItemViewController * modifyView = [[ModifyItemViewController alloc] init];
            
            [modifyView setModel:_model];
            
            [modifyView setItemString:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:modifyView animated:YES];
            
        }];
        modifyAction.backgroundColor = [UIColor brownColor];
        return @[deleteAction,modifyAction];
    }
    
    if ([[_cells[indexPath.row] getCategory] isEqualToString: @"other"]) {
        UITableViewRowAction *modifyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Modify" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            ModifyOtherItemViewController * modifyView = [[ModifyOtherItemViewController alloc] init];
            
            [modifyView setModel:_model];
            
            [modifyView setItemString:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:modifyView animated:YES];
            
        }];
        modifyAction.backgroundColor = [UIColor brownColor];;
        return @[deleteAction,modifyAction];
    }
    
    return @[deleteAction];
}

// helper private function to check whether a string is empty.
- (BOOL)isEmptyString:(NSString *)string {
    
    if (((NSNull *) string == [NSNull null]) || (string == nil) ) {
        return YES;
    }
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

- (NSString *) composeResult: (NSArray *) result
                withCategory: (NSString *) category {
    
    NSString * resultString = nil;
    if ([category isEqualToString:@"website"]) {
        resultString = [NSString stringWithFormat:@"Username: %@ \n Password: %@ ", result[1], result[2]];
    }
    else if ([category isEqualToString:@"creditcard"]) {
        resultString = [NSString stringWithFormat:@"Card Number: %@ \n Expiration Date: %@ \n Security Code: %@ ", result[1], result[2], result[3]];
    }
    else if ([category isEqualToString:@"other"]) {
        resultString = [NSString stringWithFormat:@"Message 1: %@ \n Message 2: %@ \n Message 3: %@ ", result[1], result[2], result[3]];
    }
    else {
        return nil;
    }
    return resultString;
}

@end
