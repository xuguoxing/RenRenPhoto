//
//  LoginViewController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-18.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "LoginViewController.h"
#import "Renren.h"
#import "OAuthController.h"
#import "NSString+Additions.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()
@property (nonatomic) UIImageView *backImageView;
@end

@implementation LoginViewController

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)login:(id)sender
{
    NSDictionary *params = [[Renren sharedRenren] authorizationParams];
    NSString *url = kRenRenAuthBaseURL;
    
    
    OAuthController *controller = [[OAuthController alloc]init];
    controller.type = kOAuthTypeAccessToken;
    controller.serverUrl = url;
    controller.params = params;
    
    __weak LoginViewController *blockSelf = self;
    controller.completionBlock = ^(BOOL success,NSDictionary*params){
        if (success && params) {
            [Renren sharedRenren].accessToken = [[params objectForKey:@"access_token"] urlDecodedString];
            NSString *expTime = [[params objectForKey:@"expires_in"] urlDecodedString];
            [Renren sharedRenren].expirationDate = [NSDate dateWithTimeIntervalSinceNow:[expTime intValue]];
            [[Renren sharedRenren] getSessionKeyWithCompletionBlock:^(BOOL success){
                if (success) {
                    [blockSelf dismissModalViewControllerAnimated:YES];
                    [blockSelf showMenuController];
                }else{
                    [blockSelf dismissModalViewControllerAnimated:YES];
                }
            }];
        }else{
            [blockSelf dismissModalViewControllerAnimated:YES];
        }

    };
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentModalViewController:navController animated:YES];
}


-(void)showMenuController
{
    DDMenuController  *menuController = (DDMenuController*)((AppDelegate*)[UIApplication sharedApplication].delegate).menuController;
    MenuViewController  *leftController = (MenuViewController*)((AppDelegate*)[UIApplication sharedApplication].delegate).leftController;
    [leftController setSelectIndex:0];
    [leftController viewWillAppear:NO];
    [[UIApplication sharedApplication].keyWindow setRootViewController:menuController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:imageView];
    self.backImageView = imageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-100)/2, 200, 100, 44);
    [button setTitle:@"登录人人账户" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
