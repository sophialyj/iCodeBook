//
//  AddOtherItemViewController.m
//  iCodebook
//
//  Created by Yijie Li on 7/16/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "AddOtherItemViewController.h"
#import "AddItemTableView.h"

@interface AddOtherItemViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSString * itemNameString;
@property (nonatomic, strong) NSString * encrypted1String;
@property (nonatomic, strong) NSString * encrypted2String;
@property (nonatomic, strong) NSString * encrypted3String;
@property (nonatomic, strong) NSString * keyString;
@property (nonatomic, strong) NSDate * expiredDate;

@property(nonatomic, strong) CBModel  * model;
@property(nonatomic, strong) UITapGestureRecognizer * tap;

@end

@implementation AddOtherItemViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title             = @"Add A Secret Item";
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        navItem.rightBarButtonItem = doneButton;
        navItem.leftBarButtonItem = cancelButton;
    }
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
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:_tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeAlertWithOnlyMessage: (NSString *) message {
    UIAlertController * msg = [UIAlertController alertControllerWithTitle:@"Add A Secret Item" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * quit    = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    
    [msg addAction:quit];
    
    [self presentViewController:msg animated:YES completion:^{return;}];
}

- (void)done: (id)sender{
    [self textFieldDidEndEditing:_itemName];
    [self textFieldDidEndEditing:_encrypted1];
    [self textFieldDidEndEditing:_encrypted2];
    [self textFieldDidEndEditing:_encrypted3];
    [self textFieldDidEndEditing:_key];
    // check everything here.
    if ([self isEmptyString:_itemNameString]) {
        [self makeAlertWithOnlyMessage:@"Label cannot be empty."];
        return;
    }
    
    if (([self isEmptyString:_encrypted1String] && [self isEmptyString:_encrypted2String] && [self isEmptyString:_encrypted3String])) {
        [self makeAlertWithOnlyMessage:@"You should enter at least 1 encrypted message."];
        return;
    }
    
    else {
        [_model setKey:_keyString];
        
        // Set date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        // Add Data
        NSString * returnmsg = [_model addData:_itemNameString fromCategory:@"other" withEncryptedMsg1:_encrypted1String withEncryptedMsg2:_encrypted2String withEncryptedMsg3:_encrypted3String withDate:[formatter stringFromDate:[NSDate date]]];

        UIAlertController * msg = [UIAlertController alertControllerWithTitle:@"Add A Secret Item" message:returnmsg preferredStyle:UIAlertControllerStyleAlert];
        
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
    [_itemName resignFirstResponder];
    [_encrypted1 resignFirstResponder];
    [_encrypted2 resignFirstResponder];
    [_encrypted3 resignFirstResponder];
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
    
    int width = [[UIScreen mainScreen] bounds].size.width - 150;
    
    if (indexPath.row == 0) {
        _itemName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        _itemName.placeholder = @"Enter Itemname";
        _itemName.autocorrectionType = UITextAutocorrectionTypeNo;
        [_itemName setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_itemName setBorderStyle:UITextBorderStyleRoundedRect];
        cell.accessoryView = _itemName;
        cell.textLabel.text = @"Label";
        _itemName.delegate = self;
    }
    
    if (indexPath.row == 1) {
        _encrypted1 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        _encrypted1.placeholder = @"Enter Encrypted Message";
        _encrypted1.secureTextEntry = YES;
        _encrypted1.autocorrectionType = UITextAutocorrectionTypeNo;
        [_encrypted1 setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_encrypted1 setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Encrypted Line 1";
        cell.accessoryView = _encrypted1;
        _encrypted1.delegate = self;
    }
    
    if (indexPath.row == 2) {
        _encrypted2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        _encrypted2.placeholder = @"Enter Encrypted Message";
        _encrypted2.secureTextEntry = YES;
        _encrypted2.autocorrectionType = UITextAutocorrectionTypeNo;
        [_encrypted2 setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_encrypted2 setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Encrypted Line 2";
        cell.accessoryView = _encrypted2;
        _encrypted2.delegate = self;
    }
    
    if (indexPath.row == 3) {
        _encrypted3 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        _encrypted3.placeholder = @"Enter Encrypted Message";
        _encrypted3.secureTextEntry = YES;
        _encrypted3.autocorrectionType = UITextAutocorrectionTypeNo;
        [_encrypted3 setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_encrypted3 setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Encrypted Line 3";
        cell.accessoryView = _encrypted3;
        _encrypted3.delegate = self;
    }
    
    if (indexPath.row == 4) {
        _key = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        _key.placeholder = @"Enter Key";
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
    if (textField == _itemName) {
        _itemNameString = textField.text;
    }
    else if(textField == _encrypted1) {
        _encrypted1String = textField.text;
    }
    else if(textField == _encrypted2){
        _encrypted2String = textField.text;
    }
    else if(textField == _encrypted3) {
        _encrypted3String = textField.text;
    }
    else if(textField == _key) {
        _keyString = textField.text;
    } else {
        return;
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

@end
