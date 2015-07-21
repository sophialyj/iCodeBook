//
//  ModifyOtherItemViewController.m
//  iCodebook
//
//  Created by Yijie Li on 7/21/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "ModifyOtherItemViewController.h"

@interface ModifyOtherItemViewController () <UITextFieldDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property(nonatomic, strong) NSString * itemNameString;
@property(nonatomic, strong) NSString * msg1String;
@property(nonatomic, strong) NSString * msg2String;
@property(nonatomic, strong) NSString * msg3String;
@property(nonatomic, strong) NSString * keyString;
@property(nonatomic, strong) CBModel  * model;
@property(nonatomic, strong) UITapGestureRecognizer * tap;

@end

@implementation ModifyOtherItemViewController

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
    [self textFieldDidEndEditing:_msg1];
    [self textFieldDidEndEditing:_msg2];
    [self textFieldDidEndEditing:_msg3];
    [self textFieldDidEndEditing:_key];
    // check everything here.
    if ([self isEmptyString:_msg1String] && [self isEmptyString:_msg2String] && [self isEmptyString:_msg3String]) {
        [self makeAlertWithOnlyMessage:@"At least one message should be non empty."];
        return;
    }
    else if ([self isEmptyString:_keyString]) {
        [self makeAlertWithOnlyMessage:@"Please enter your essential key"];
        return;
    }
    else {
        [_model setKey:_keyString];
        
        // Set date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"mm/dd/yyyy"];
        
        NSString * returnmsg = [_model modifyData:_itemNameString fromCategory:@"other" withEncryptedMsg1:_msg1String withEncryptedMsg2:_msg2String withEncryptedMsg3:_msg3String withDate:[formatter stringFromDate:[NSDate date]]];
        
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
    [_msg1 resignFirstResponder];
    [_msg2 resignFirstResponder];
    [_msg3 resignFirstResponder];
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
        _msg1 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
        _msg1.placeholder = @"Message Line 1";
        _msg1.secureTextEntry = YES;
        _msg1.autocorrectionType = UITextAutocorrectionTypeNo;
        [_msg1 setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_msg1 setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Message 1";
        cell.accessoryView = _msg1;
        _msg1.delegate = self;
    }
    
    if (indexPath.row == 2) {
        _msg2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
        _msg2.placeholder = @"Message Line 2";
        _msg2.secureTextEntry = YES;
        _msg2.autocorrectionType = UITextAutocorrectionTypeNo;
        [_msg2 setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_msg2 setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Message 2";
        cell.accessoryView = _msg2;
        _msg2.delegate = self;
    }
    
    if (indexPath.row == 3) {
        _msg3 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
        _msg3.placeholder = @"Message Line 3";
        _msg3.secureTextEntry = YES;
        _msg3.autocorrectionType = UITextAutocorrectionTypeNo;
        [_msg3 setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_msg3 setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Message 3";
        cell.accessoryView = _msg3;
        _msg3.delegate = self;
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
    if(textField == _msg1) {
        _msg1String = textField.text;
    }
    else if(textField == _msg2){
        _msg2String = textField.text;
    }
    else if(textField == _msg3) {
        _msg3String = textField.text;
    }
    else if(textField == _key) {
        _keyString = textField.text;
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