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

    //@"266",@"loginRand", @"N",@"refundLogin",@"Y",@"refundFlag",@"xugx2007@gmail.com",@"loginUser.user_name",@"",@"nameErrorFocus",@"397321642",@"user.password",@"",@"passwordErrorFocus",@"XE8J",@"randCode",@"",@"randErrorFocus",nil];
-(id)init
{
    if (self = [super init]) {
        //responceData = [NSMutableData data];
        refundFlag = @"Y";
        refundLogin = @"N";
        nameErrorFocus = @"";
        passwordErrorFocus = @"";
        randErrorFocus = @"";
    }
    return self;
}

-(void)loginIn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:loginRand forKey:kLoginRandField];
    [params setObject:refundLogin forKey:kRefundLoginField];
    [params setObject:refundFlag forKey:kRefundFlagField];
    [params setObject:userName forKey:kUserNameField];
    [params setObject:nameErrorFocus forKey:kUserNameErrorFocusField];
    [params setObject:password forKey:kPasswordField];
    [params setObject:passwordErrorFocus forKey:kPasswordErrorFocusField];
    [params setObject:randCode forKey:kRandCodeField];
    [params setObject:randErrorFocus forKey:kRandCodeErrorFocusField];
    
    HttpRequest *request = [HttpRequest requestWithURL:@"https://dynamic.12306.cn/otsweb/loginAction.do?method=login" httpMethod:@"POST" params:params];
        
    [request setCompletion:^(NSMutableData *data){
        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
        [webView loadHTMLString:result baseURL:nil];
        [self.view addSubview:webView];
        
        [popView destory];
        popView = nil;
        //NSLog(@"findData:%@",result);
    }failure:^(NSError *error){
        NSLog(@"error:%@",error);
        [popView destory];
        popView = nil;
        
    }];
    [request connect];
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
    userName = userNameField.text;
    if (passWordField.text == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    password = passWordField.text;
    
    if (verifyCodeField.text == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证码不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    randCode = verifyCodeField.text;
    
    popView = [[PopUpView alloc] init];
	popView.hintLabel.text = @"正在登录";
	[popView showInView:self.view];
    
    [TrainSession sharedSession].userName = userNameField.text;
    [TrainSession sharedSession].passWord = passWordField.text;
    [TrainSession sharedSession].loginVerifyCode = verifyCodeField.text;
    [[TrainSession sharedSession] loginWithCompletion:^(NSString *msg, NSError *error) {
        if ([@"OK" isEqualToString:msg]) {
            MineTrainController *controller = [[MineTrainController alloc]initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            NSLog(@"Error:%@",error);
        }
    }];
    
  /*  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn:443/otsweb/loginAction.do?method=loginAysnSuggest"]];
    AFJSONRequestOperation *loginAysnSuggestRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request , NSHTTPURLResponse *response , id JSON){
        if ([[JSON objectForKey:@"randError"] isEqualToString:@"Y"]) {
            self->loginRand = [JSON objectForKey:@"loginRand"];
            [self loginIn];
        }

    } failure:^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON){
        NSLog(@"loginAysnSuggest Error:%@",error);
    }];
    [loginAysnSuggestRequest start];*/
    
    /*HttpRequest *loginAysnSuggestRequest = [HttpRequest requestWithURL:@"https://dynamic.12306.cn:443/otsweb/loginAction.do?method=loginAysnSuggest" httpMethod:@"POST" params:nil];
    
    [loginAysnSuggestRequest setCompletion:^(NSMutableData *data){
        NSError *error;
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (![object isKindOfClass:[NSDictionary class]]) {
            NSLog(@"object:%@ is not dictionary",object);
            return;
        }
        NSDictionary *dictionary = (NSDictionary*)object;
        NSString *randErrorValue = [dictionary objectForKey:@"randError"];
        if (randErrorValue && [randErrorValue isEqualToString:@"Y"]) {
            self->loginRand = [dictionary objectForKey:@"loginRand"];
            [self loginIn];            
        }else{
            NSLog(@"randError:%@",randErrorValue);
        }
    } failure:^(NSError *error){
        [popView destory];
        popView = nil;
    }];
    [loginAysnSuggestRequest connect];*/
    
}

-(void)imageView:(UIImageView *)imageView singleTapDetected:(CGPoint)touchPoint
{
    [[TrainSession sharedSession]refreshVerifyCodeImageType:0 withCompletion:^(UIImage *image, NSError *err) {
        imageView.image = image;
    }];
    /*NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=sjrand"]];
    
    AFHTTPRequestOperation *randCodeRequest = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [randCodeRequest setHttpsAuth];
    
    [randCodeRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        UIImage *image = [UIImage imageWithData:responseObject];
        if (image) {
            imageView.image = image;
        }else{
            NSLog(@"image error:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"randCode Error:%@",error);
    }];
    [randCodeRequest start];*/
    
   /* HttpRequest *randCodeRequest = [HttpRequest requestWithURL:@"https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=sjrand" httpMethod:@"GET" params:nil];
    [randCodeRequest setCompletion:^(NSMutableData *data){
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            imageView.image = image;
        }else{
            NSLog(@"image error:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    } failure:^(NSError* error){
        NSLog(@"randCode Error:%@",error);
    }];
    [randCodeRequest connect];*/
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
    
    /*NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/loginAction.do?method=init"]];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [urlConnection start];*/

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
-(void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didCancelAuthenticationChallenge:%@",challenge);
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse:%@",response);
    responceData = [NSMutableData data];
    //[responceData re]
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responceData appendData:data];
    //NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"didReceiveData:%@",result);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    NSString *result = [[NSString alloc]initWithData:responceData encoding:NSUTF8StringEncoding];
    NSLog(@"connectionDidFinishLoading:%@",result);
    
    TFHpple *hpple = [[TFHpple alloc]initWithHTMLData:responceData];
    NSLog(@"hpple:%@",hpple);
    //NSArray *forms = [hpple searchWithXPathQuery:@"//form"];
    //NSLog(@"forms:%@",forms);
    

}
@end
