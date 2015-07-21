//
//  AddItemViewController.m
//  iCodebook
//
//  This class is just created for convenience
//  Should be refactored to OOP.
//
//  Created by Yijie Li on 7/4/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import "ModifyItemViewController.h"

@interface ModifyItemViewController () <UITextFieldDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property(nonatomic, strong) NSString * itemNameString;
@property(nonatomic, strong) NSString * usernameString;
@property(nonatomic, strong) NSString * passwordString;
@property(nonatomic, strong) NSString * passwordConfirmString;
@property(nonatomic, strong) NSString * keyString;
@property(nonatomic, strong) CBModel  * model;
@property(nonatomic, strong) UITapGestureRecognizer * tap;

@end

@implementation ModifyItemViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

- (void)loadView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 20)];
    AddItemTableView * tableView = [[AddItemTableView alloc] init];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = headerView;
    tableView.allowsSelection = NO;
    self.view = tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Navigation Bar
    UINavigationItem *navItem = self.navigationItem;
    navItem.title             = @"Modify An Item";
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    navItem.rightBarButtonItem = doneButton;
    navItem.leftBarButtonItem = cancelButton;
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:_tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeAlertWithOnlyMessage: (NSString *) message {
    UIAlertController * msg = [UIAlertController alertControllerWithTitle:@"Modify An Item" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * quit    = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    
    [msg addAction:quit];
    
    [self presentViewController:msg animated:YES completion:^{return;}];
}

- (void)done: (id)sender{
    [self textFieldDidEndEditing:_password];
    [self textFieldDidEndEditing:_passwordConfirm];
    [self textFieldDidEndEditing:_key];
    // check everything here.
    if ([self isEmptyString:_usernameString]) {
        [self makeAlertWithOnlyMessage:@"New Username cannot be empty."];
        return;
    }
    if ([self isEmptyString:_passwordString]) {
        [self makeAlertWithOnlyMessage:@"New password cannot be empty."];
        return;
    }
    else if ([self isEmptyString:_passwordConfirmString]) {
        [self makeAlertWithOnlyMessage:@"Please confirm your password"];
        return;
    }
    else if ([self isEmptyString:_keyString]) {
        [self makeAlertWithOnlyMessage:@"Please enter your essential key"];
        return;
    }
    else if (![_passwordString isEqualToString:_passwordConfirmString]) {
        [self makeAlertWithOnlyMessage:@"Passwords you entered are not identical."];
        return;
    }
    else {
        [_model setKey:_keyString];
        
        // Set date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"mm/dd/yyyy"];
        
        NSString * returnmsg = [_model modifyData:_itemNameString fromCategory:@"website" withEncryptedMsg1:_usernameString withEncryptedMsg2:_passwordConfirmString withEncryptedMsg3:nil withDate:[formatter stringFromDate:[NSDate date]]];
        
        // A particular one.
        UIAlertController * msg = [UIAlertController alertControllerWithTitle:@"Modify An Item" message:returnmsg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * quit    = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        [msg addAction:quit];
        
        [self presentViewController:msg animated:YES completion:nil];
        
    }
    return;
}

- (void)cancel: (id)sender{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)setModel:(CBModel *)model {
    _model = model;
}

- (void)resignTextFieldResponder {
    [_password resignFirstResponder];
    [_passwordConfirm resignFirstResponder];
    [_key resignFirstResponder];
}

-(void)dismissKeyboard {
    [self resignTextFieldResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

    if (indexPath.row == 0) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, [[UIScreen mainScreen] bounds].size.width - 15, 40)];
        label.text      = [@"Item to modify: " stringByAppendingString:_itemNameString];
        [label setFont:[UIFont fontWithName:@"zapfino" size:14.0]];
        label.textColor = [UIColor redColor];
        [cell addSubview:label];
    }
    
    if (indexPath.row == 1) {
        _username = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
        _username.secureTextEntry = NO;
        _username.autocorrectionType = UITextAutocorrectionTypeNo;
        [_username setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_username setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Username";
        cell.accessoryView = _username;
        _username.delegate = self;
    }
    
    if (indexPath.row == 2) {
        _password = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
        _password.placeholder = @"Enter New Password";
        _password.secureTextEntry = YES;
        _password.autocorrectionType = UITextAutocorrectionTypeNo;
        [_password setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_password setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Password";
        cell.accessoryView = _password;
        _password.delegate = self;
    }
    
    if (indexPath.row == 3) {
        _passwordConfirm = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
        _passwordConfirm.placeholder = @"Confirm New Password";
        _passwordConfirm.secureTextEntry = YES;
        _passwordConfirm.autocorrectionType = UITextAutocorrectionTypeNo;
        [_passwordConfirm setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_passwordConfirm setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Confirm password";
        cell.accessoryView = _passwordConfirm;
        _passwordConfirm.delegate = self;
    }
    
    if (indexPath.row == 4) {
        _key = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
        _key.placeholder = @"Enter Your Essential Key";
        _key.secureTextEntry = YES;
        _key.autocorrectionType = UITextAutocorrectionTypeNo;
        [_key setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_key setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Key";
        cell.textLabel.textColor = [UIColor redColor];
        cell.accessoryView = _key;
        _key.delegate = self;
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16.0];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    // Collecting User's Input.
    if(textField == _password) {
        _passwordString = textField.text;
    }
    else if(textField == _passwordConfirm){
        _passwordConfirmString = textField.text;
    }
    else if(textField == _key) {
        _keyString = textField.text;
    }
    else if(textField == _username) {
        _usernameString = textField.text;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
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

- (void) setItemString:(NSString *)itemString {
    _itemNameString = itemString;
}


@end