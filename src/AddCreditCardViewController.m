//
//  AddCreditCardViewController.m
//  iCodebook
//
//  Created by Yijie Li on 7/16/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import "AddCreditCardViewController.h"
#import "AddItemTableView.h"

@interface AddCreditCardViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSString * itemNameString;
@property (nonatomic, strong) NSString * cardNumberString;
@property (nonatomic, strong) NSString * expireDateString;
@property (nonatomic, strong) NSString * securityCodeString;
@property (nonatomic, strong) NSString * keyString;

@property(nonatomic, strong) CBModel  * model;
@property(nonatomic, strong) UITapGestureRecognizer * tap;

@property(nonatomic, strong) UIPickerView *pickerView;

@property(nonatomic, strong) NSArray * monthArray;
@property(nonatomic, strong) NSArray * yearArray;

@end

@implementation AddCreditCardViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title             = @"Add A Credit Card Item";
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        navItem.rightBarButtonItem = doneButton;
        navItem.leftBarButtonItem = cancelButton;
        
        _monthArray = [[NSArray alloc] initWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
        
        _yearArray = [[NSArray alloc] initWithObjects:@"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", nil];
        
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
    [self textFieldDidEndEditing:_cardNumber];
    [self textFieldDidEndEditing:_securityCode];
    [self textFieldDidEndEditing:_expireDate];
    [self textFieldDidEndEditing:_key];
    // check everything here.
    if ([self isEmptyString:_itemNameString]) {
        [self makeAlertWithOnlyMessage:@"Label cannot be empty."];
        return;
    }
    
    if ([self isEmptyString:_cardNumberString]) {
        [self makeAlertWithOnlyMessage:@"Card Number cannot be empty."];
        return;
    }
    
    if ([self isEmptyString:_expireDateString]) {
        [self makeAlertWithOnlyMessage:@"Expiration Date cannot be empty."];
        return;
    }
    
    if ([self isEmptyString:_securityCodeString]) {
        [self makeAlertWithOnlyMessage:@"Security Code cannot be empty."];
        return;
    }
    
    else {
        [_model setKey:_keyString];
        
        // Set date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        // Add Data
        NSString * returnmsg = [_model addData:_itemNameString fromCategory:@"creditcard" withEncryptedMsg1:_cardNumberString withEncryptedMsg2:_expireDateString withEncryptedMsg3:_securityCodeString withDate:[formatter stringFromDate:[NSDate date]]];

        UIAlertController * msg = [UIAlertController alertControllerWithTitle:@"Add A Credit Card Item" message:returnmsg preferredStyle:UIAlertControllerStyleAlert];
        
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
    [_cardNumber resignFirstResponder];
    [_expireDate resignFirstResponder];
    [_securityCode resignFirstResponder];
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
        _cardNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        _cardNumber.placeholder = @"Enter Credit Card Number";
        _cardNumber.secureTextEntry = NO;
        _cardNumber.autocorrectionType = UITextAutocorrectionTypeNo;
        [_cardNumber setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_cardNumber setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Card Number";
        cell.accessoryView = _cardNumber;
        _cardNumber.delegate = self;
    }
    
    if (indexPath.row == 2) {
        _expireDate = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        _expireDate.placeholder = @"01/15";
        _expireDate.secureTextEntry = NO;
        _expireDate.autocorrectionType = UITextAutocorrectionTypeNo;
        [_expireDate setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_expireDate setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Expiration";
        cell.accessoryView = _expireDate;
        _expireDate.delegate = self;
    }
    
    if (indexPath.row == 3) {
        _securityCode = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        _securityCode.placeholder = @"Enter 3/4-digit security.";
        _securityCode.secureTextEntry = NO;
        _securityCode.autocorrectionType = UITextAutocorrectionTypeNo;
        [_securityCode setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_securityCode setBorderStyle:UITextBorderStyleRoundedRect];
        cell.textLabel.text = @"Security Code";
        cell.accessoryView = _securityCode;
        _securityCode.delegate = self;
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
    else if(textField == _cardNumber) {
        _cardNumberString = textField.text;
    }
    else if(textField == _expireDate){
        _expireDateString = textField.text;
    }
    else if(textField == _securityCode) {
        _securityCodeString = textField.text;
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

- (void)textFieldDidBeginEditing:(nonnull UITextField *)textField {
    
    int height = [[UIScreen mainScreen] bounds].size.height;
    int width  = [[UIScreen mainScreen] bounds].size.width;
    
    if (textField == _expireDate) {
        
        UILabel * month = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, width/2, 20)];
        [month setTextColor:[UIColor darkGrayColor]];
        month.text = @"Month";
        month.textAlignment = NSTextAlignmentCenter;
        [month setFont:[UIFont fontWithName:@"SanFranciscoRounded-Black" size:25.0]];
        
        UILabel * year = [[UILabel alloc] initWithFrame:CGRectMake(width/2, 15, width/2, 20)];
        [year setTextColor:[UIColor darkGrayColor]];
        year.text = @"Year";
        year.textAlignment = NSTextAlignmentCenter;
        [year setFont:[UIFont fontWithName:@"SanFranciscoRounded-Black" size:25.0]];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height - 190, width, 190)];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        [_pickerView setOpaque:NO];
        _pickerView.showsSelectionIndicator = YES;
        
        [_pickerView addSubview:month];
        [_pickerView addSubview:year];
        
        textField.inputView = _pickerView;
        
    }
}

// Add data picker view - data source.

- (NSInteger)pickerView:(UIPickerView *) pickerView
numberOfRowsInComponent:(NSInteger)component {
    
    if(component== 0)
    {
        return [_monthArray count];
    }
    else
    {
        return [_yearArray count];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = [[UILabel alloc] init];
    if (tView)
    {
        tView.font = [UIFont fontWithName:@"SanFranciscoRounded-Black" size:25];
        tView.textAlignment = NSTextAlignmentCenter;
    }
    if (component == 0) {
        tView.text = [_monthArray objectAtIndex:row];
        tView.textColor = [UIColor colorWithRed:0.37 green:0.34 blue:0.52 alpha:1.0];
    } else {
        tView.text = [_yearArray objectAtIndex:row];
        tView.textColor = [UIColor colorWithRed:0.37 green:0.34 blue:0.52 alpha:1.0];
    }
    return tView;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _expireDate.text = [NSString stringWithFormat:@"%@/%@", [_monthArray objectAtIndex:[pickerView selectedRowInComponent:0]], [_yearArray objectAtIndex:[pickerView selectedRowInComponent:1]]];
}


@end
