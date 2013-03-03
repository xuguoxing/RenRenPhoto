//
//  OAuthController.m
//  RenrenPhoto
//
//  Created by  on 12-9-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "OAuthController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Additions.h"
#import "NSDictionary+Additions.h"
#import "IconImage.h"
#import "CommonUtils.h"
#define kPadding 10

@interface OAuthController ()

@end

@implementation OAuthController
//@synthesize completionBlock;
//@synthesize failedBlock;
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/


-(id)init
{
    if (self = [super init]) {
        self.title = @"人人账户登录"; 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.titleView = labelForNavTitle(self.title);
    
    UIButton *button = [UIButton buttonWithType:UIBarButtonItemStylePlain];
    [button setImage:[IconImage stopBtnImage] forState:UIControlStateNormal];
    [button setImage:[IconImage stopBtnHoverImage] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    webView.delegate =self;
    [self.view addSubview:webView];
    
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.center = _webView.center;
    [self.view addSubview:_indicatorView];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",_serverUrl,[_params urlParamsEncodeString]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [webView loadRequest:urlRequest];
    [_indicatorView startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma public method

-(void)close:(id)sender
{
    /*[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveLinear
                     animations:^{
                         self.view.alpha = 0.0f;
                     } completion:^(BOOL finished){
                         [self.view removeFromSuperview];
                         [_backgroundView removeFromSuperview];
                     }];*/
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSLog(@"loadUrl:%@",url.absoluteString);
    
    NSString *query = url.fragment;
    if (!query) {
        query = url.query;
    }
    NSDictionary *params = [query urlParamsDecodeDictionary];
    if ([params objectForKey:@"error"]) {
        NSString *errorDesc = [params objectForKey:@"error_description"];
        if ([errorDesc isEqualToString:@"The+end-user+denied+logon."]) {
            _isComplete = YES;
            if (self.completionBlock) {
                self.completionBlock(NO,nil);
            }
        }
        return NO;
    };

    if(_type == kOAuthTypeCode)
    {
        if ([params objectForKey:@"code"]) {
            if (self.completionBlock) {
                self.completionBlock(YES,params);
            }
            _isComplete = YES;
            return NO;
        }   
    }else if(_type == kOAuthTypeAccessToken)
    {
        if ([params objectForKey:@"access_token"]) {
            if (self.completionBlock) {
                self.completionBlock(YES,params);
            }
            _isComplete = YES;
            return NO;
        }
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicatorView stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (!_isComplete) {
        alertMessage(@"登录失败", error.localizedDescription);
    }
    
}
@end
