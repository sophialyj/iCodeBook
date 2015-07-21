//
//  LocalAuthenticationViewController.m
//  iCodebook
//
//  Created by Yijie Li on 7/9/15.
//  Copyright © 2015 Yijie Li. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "LocalAuthenticationViewController.h"
#import "RootViewController.h"
#import "ViewController.h"
#import "RootRootViewController.h"
#import <sys/utsname.h>

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) && ((IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale) || !IS_OS_8_OR_LATER))
#define IS_STANDARD_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)
#define IS_ZOOMED_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)
#define IS_STANDARD_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_ZOOMED_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)

@interface LocalAuthenticationViewController () <UIAlertViewDelegate>

// Background Image
@property (nonatomic, strong) UIImage * backgroundImage;
@property (nonatomic, strong) RootViewController * root;

@property (nonatomic, strong) NSString * reason;
@property int loadTime;
@property BOOL presenting;

@end

@implementation LocalAuthenticationViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        /*
        UINavigationItem *navItem = self.navigationItem;
        navItem.title             = @"Authentication";
        navItem.rightBarButtonItem = nil;
        navItem.leftBarButtonItem  = nil;
        */
        
        _root     = [[RootViewController alloc] init];
        [_root resetFirstTimeLoad];
        _loadTime = 0;
        _reason   = @"Please authenticate before you enter this secure app.";
        _presenting = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    if (_loadTime > 0) {
        _reason = @"Please authenticate while reloading this app.";
        _presenting = NO;
    }
    [self enterAppAuthentication];
    _loadTime ++;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * nullView  = [[UIView alloc] init];
    UIImage * image    = [UIImage imageNamed:@"launchscreen-1.png"];
    UIImageView * img  = [[UIImageView alloc] initWithImage:image];
    
    [nullView addSubview:img];
    
    self.view = nullView;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Local Authentication Methods.
- (void)enterAppAuthentication {
    LAContext *authContext = [[LAContext alloc] init];
    NSError   *authError   = nil;
    
    if ((IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) && (!IS_ZOOMED_IPHONE_6) && (!IS_ZOOMED_IPHONE_6_PLUS)) {
        RootRootViewController * tabBarViewController = [[RootRootViewController alloc] init];
        [self presentViewController:tabBarViewController animated:YES completion:nil];
        return;
    }
    
    @autoreleasepool {
    // Start calling touch ID or password for authentication.
    if ([authContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        [authContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:_reason reply:^(BOOL success, NSError *error) {
            if (success) {
                
                /*
                //[self.navigationController pushViewController:_root animated:YES];
                ViewController * main = [[ViewController alloc] initWithRootViewController:_root];
                _presenting = YES;
                [self presentViewController:main animated:YES completion:nil];
                 */
                RootRootViewController * tabBarViewController = [[RootRootViewController alloc] init];
                [self presentViewController:tabBarViewController animated:YES completion:nil];
            
            } else {
                if (error.code == LAErrorAuthenticationFailed) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertUser:@"Authentication failed. Exit."];
                    });
    
                } else if (error.code == LAErrorUserCancel) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertUser:@"You gave up... Some time when stored touch ids doesn't work, you can add a new one."];
                    });
                } else if (error.code == LAErrorUserFallback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertUser:@"In this version, we didn't implement a secure passcode to our application. Please try to add a new touch ID if those old ones don't work instead."];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertUser:@"Sorry, something goes wrong. I just quit."];
                    });
                }
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertUser:@"Your biometrics are more safe than a four-digit code. Please add one to use this app. Exit."];
        });
    }
    }
    // End Authentication
}

- (void)alertUser: (NSString *) alertMsg {
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Authentication Failed." message:alertMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)  // 0 == the cancel button
    {
        //home button press programmatically
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        //exit app when app is in background
        exit(0);
    }
}

@end
