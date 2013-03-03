//
//  LoginViewController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-15.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "LoginViewController.h"
#import "GDataXMLNode.h"
#import "TFHpple.h"
#import "HttpRequest.h"
#import "AFNetworking.h"
#import "QueryViewController.h"
#import "AFURLConnectionOperation+HTTPS.h"
#import "Constants.h"
#import "TrainSession.h"
#import "MineTrainController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

-(void)queryButtonPressed:(id)sender
{
    QueryViewController *controller = [[QueryViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)loginButtonPressed:(id)sender{    
    if (userNameField.text == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户名不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (passWordField.text == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (verifyCodeField.text == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证码不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }    
    popView = [[PopUpView alloc] init];
	popView.hintLabel.text = @"正在登录";
	[popView showInView:self.view];
    
    [TrainSession sharedSession].userName = userNameField.text;
    [TrainSession sharedSession].passWord = passWordField.text;
    [TrainSession sharedSession].loginVerifyCode = verifyCodeField.text;
    [[TrainSession sharedSession] loginWithCompletion:^(BOOL success, NSError *error) {
        [popView destory];
        popView = nil;
        if (success) {
            MineTrainController *controller = [[MineTrainController alloc]initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            NSLog(@"Error:%@",error);
        }
    }];
}

-(void)imageView:(UIImageView *)imageView singleTapDetected:(CGPoint)touchPoint
{
    [[TrainSession sharedSession]refreshVerifyCodeImageType:0 withCompletion:^(UIImage *image, NSError *err) {
        imageView.image = image;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25, 40, 60, 30)];
    label.text = @"登陆名:";
    [self.view addSubview:label];
    userNameField = [[UITextField alloc]initWithFrame:CGRectMake(100, 40, 150, 30)];
    userNameField.borderStyle = UITextBorderStyleBezel;
    userNameField.text = @"xugx2007@gmail.com";
    [self.view addSubview:userNameField];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(25, 75, 60, 30)];
    label.text = @"密码:";
    [self.view addSubview:label];
    passWordField = [[UITextField alloc]initWithFrame:CGRectMake(100, 75, 150, 30)];
    passWordField.borderStyle = UITextBorderStyleLine;
    passWordField.text = @"397321642";
    [self.view addSubview:passWordField];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(25, 110, 60, 30)];
    label.text = @"验证码";
    [self.view addSubview:label];
    verifyCodeField = [[UITextField alloc]initWithFrame:CGRectMake(100, 110, 100, 30)];
    verifyCodeField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:verifyCodeField];
    
    verifyCodeImageView = [[TapDetectingImageView alloc]initWithFrame:CGRectMake(200, 110, 60, 30)];
    verifyCodeImageView.tapDelegate = self;
    [self imageView:verifyCodeImageView singleTapDetected:CGPointZero];
    [self.view addSubview:verifyCodeImageView];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(100, 150, 60, 30);
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIButton *queryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [queryButton setTitle:@"查询" forState:UIControlStateNormal];
    queryButton.frame = CGRectMake(100, 200, 60, 30);
    [queryButton addTarget:self action:@selector(queryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
