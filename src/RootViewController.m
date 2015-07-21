//
//  RootViewController.m
//  iCodebook
//
//  Created by Yijie Li on 7/3/15.
//  Copyright (c) 2015 Yijie Li. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "RootViewController.h"
#import "TableCellContentWithDate.h"
#import "ButtonMaker.h"
#import "AboutTableViewController.h"
#import "AddTableView.h"
#import "AddOtherItemViewController.h"
#import "AddCreditCardViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

// Components
@property UITextField * alertTextField;
@property int           firstTimeLoad;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property BOOL doAddCalled;

// Search view controller
@property (nonatomic, strong) UISearchController *searchController;
// Search results table view
@property (nonatomic, strong) SearchResultsViewController *resultsTableController;

@property (nonatomic, strong) AboutTableViewController * aboutViewController;

@property (nonatomic, strong) AddTableView * addView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation RootViewController

- (instancetype)init {
    self = [super init];
    if (self) {

        self.cells      = self.model.items;
        _firstTimeLoad  = 0;
        _addView         = [[AddTableView alloc] init];
        [_addView setHidden:YES];
        
    }
    return self;
}

- (UIButton *) createAddViewButton: (NSString *) buttonTitle
                         withIndex: (int) i
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(40, 2 + 45 * i, 100, 40)];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:16.0]];
    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title             = @"Secrets Vault";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doAdd:)];
    navItem.rightBarButtonItem = rightButton;
    
    // Search Bar added.
    _resultsTableController = [[SearchResultsViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = YES; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    [self.navigationController.view addSubview:_addView];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    _doAddCalled = NO;
    
    [_tapGestureRecognizer setEnabled:NO];
    _tapGestureRecognizer.delegate = self;
    [self.navigationController.view addGestureRecognizer:_tapGestureRecognizer];
    
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    
    UIImage * websiteLogo = [UIImage imageNamed:@"WebsiteLogo.png"];
    UIImageView * websiteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 32, 32)];
    [websiteImageView setImage:websiteLogo];

    UIImage * creditLogo = [UIImage imageNamed:@"CreditCardLogo.png"];
    UIImageView * creditImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 52, 32, 32)];
    [creditImageView setImage:creditLogo];
    
    UIImage * moreLogo = [UIImage imageNamed:@"more.png"];
    UIImageView * moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 95, 32, 32)];
    [moreImageView setImage:moreLogo];

    UIButton * website = [self createAddViewButton:@"Website" withIndex:0];
    
    [website addTarget:self action:@selector(addWebSite:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * creditCard = [self createAddViewButton:@"CreditCard" withIndex:1];
    
    [creditCard addTarget:self action:@selector(addCreditCard:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * other = [self createAddViewButton:@"Other" withIndex:2];
    
    [other addTarget:self action:@selector(addOther:) forControlEvents:UIControlEventTouchDown];
    
    [_addView addSubview:website];
    [_addView addSubview:creditCard];
    [_addView addSubview:other];
    
    [_addView addSubview:websiteImageView];
    [_addView addSubview:creditImageView];
    [_addView addSubview:moreImageView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIView animateWithDuration:0.3 animations:^{
        _addView.alpha = 0;
    } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
        [_addView setHidden:finished];
        _doAddCalled = NO;
    }];
    [super viewWillDisappear:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if(_firstTimeLoad != 0) {
        [self.tableView reloadData];
        NSString * newAdded = [self.cells lastObject];
        NSUInteger oldIndex = [self.cells indexOfObject:newAdded];
        [self.cells sortUsingSelector:@selector(compare:)];
        NSUInteger newIndex = [self.cells indexOfObject:newAdded];
        
        if(newIndex != oldIndex) {
            [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:oldIndex inSection:0] toIndexPath:[NSIndexPath indexPathForRow:newIndex inSection:0]];
        }
        
        [_tapGestureRecognizer setEnabled:NO];
    }
    _firstTimeLoad ++;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)doAdd:(id)sender {
    
    if (_doAddCalled == NO) {
        [_tapGestureRecognizer setEnabled:YES];
        _doAddCalled = YES;
        
        _addView.alpha = 0;
        _addView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _addView.alpha = 1;
        }];
        
    } else {
        [_tapGestureRecognizer setEnabled:NO];
        _doAddCalled = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            _addView.alpha = 0;
        } completion: ^(BOOL finished) {
            [_addView setHidden:finished];
            _doAddCalled = NO;
        }];
        //
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void) resetFirstTimeLoad {
    _firstTimeLoad = 0;
}

#pragma mark - UISearchBarDelegate

// The following search bar functions are modified from apple's website.

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    // Hide any added view before search get the first responder
    // TODO: should be refactored to something like [resignFirstResponder];
    if (_doAddCalled) {
        [UIView animateWithDuration:0.3 animations:^{
            _addView.alpha = 0;
        } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
            [_addView setHidden:finished];
            _doAddCalled = NO;
        }];
    }
    
    // tmp var for filtering
    NSString * searchText          = searchController.searchBar.text;
    NSMutableArray * searchResults = [self.cells mutableCopy];
    
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {

        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"getTitle"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
    SearchResultsViewController *tableController = (SearchResultsViewController *)self.searchController.searchResultsController;
    tableController.cells = searchResults;
    [tableController.tableView reloadData];
    
}

#pragma mark - UIStateRestoration

// we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}

- (void) handleTapFrom: (UIGestureRecognizer *) gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded && _doAddCalled) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _addView.alpha = 0;
        } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
            [_addView setHidden:finished];
            _doAddCalled = NO;
            [_tapGestureRecognizer setEnabled:NO];
        }];
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_doAddCalled) {
        [UIView animateWithDuration:0.3 animations:^{
            _addView.alpha = 0;
        } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
            [_addView setHidden:finished];
            _doAddCalled = NO;
            [_tapGestureRecognizer setEnabled:NO];
        }];

    }
    return [super tableView:tableView editActionsForRowAtIndexPath:indexPath];
}

- (void) addWebSite: (id) sender {
    
     AddItemViewController * addView = [[AddItemViewController alloc] init];
     [addView setModel:self.model];
     [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
     [[self navigationController] pushViewController:addView animated:YES];
     [self.tabBarController.tabBar setHidden:YES];

}

- (void) addCreditCard: (id) sender {
    
    AddCreditCardViewController * addView = [[AddCreditCardViewController alloc] init];
    [addView setModel:self.model];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [[self navigationController] pushViewController:addView animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
}

- (void) addOther: (id) sender {
    
    AddOtherItemViewController * addView = [[AddOtherItemViewController alloc] init];
    [addView setModel:self.model];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [[self navigationController] pushViewController:addView animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
}

@end
