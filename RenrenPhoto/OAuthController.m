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
#define kPadding 10

@interface OAuthController ()

@end

@implementation OAuthController
@synthesize serverUrl = _serverUrl;
@synthesize params = _params;
@synthesize type = _type;
@synthesize completionBlock;
@synthesize failedBlock;
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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    
    _backgroundView = [[UIView alloc]initWithFrame:frame];
    
    self.view.frame = CGRectMake(kPadding, kPadding, frame.size.width-2*kPadding, frame.size.height-2*kPadding);
    self.view.backgroundColor = [UIColor clearColor];
    [self.view.layer setCornerRadius:10.0];
    self.view.clipsToBounds = YES;
    
    UIView *skinView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    skinView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    skinView.backgroundColor = [UIColor blackColor];
    skinView.alpha = 0.4f;
    [self.view addSubview:skinView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_cancelButton setImage:[UIImage imageNamed:@"close_selected.png"] forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.frame = CGRectMake((self.view.frame.size.width-35.0)/2.0, self.view.frame.size.height-35, 35, 35);
    [self.view addSubview:_cancelButton];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(kPadding, kPadding*3, self.view.frame.size.width-2*kPadding, self.view.frame.size.height-4*kPadding)];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate =self;
    [self.view addSubview:_webView];
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.center = _webView.center;
    [self.view addSubview:_indicatorView];
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

-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [[UIApplication sharedApplication].keyWindow insertSubview:_backgroundView belowSubview:self.view];
    
    _isComplete = NO;
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",_serverUrl,[_params urlParamsEncodeString]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:urlRequest];
    [_indicatorView startAnimating];
    
    self.view.alpha = 0.0;
    self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:0.2 
                     animations:^{
                         self.view.alpha = 1.0;
                         self.view.transform = CGAffineTransformScale( CGAffineTransformIdentity, 1.1, 1.1);
                     } 
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2 
                                          animations:^{
                                              self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                                          } 
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.2 animations:^{
                                                  self.view.transform = CGAffineTransformIdentity;
                                              }];
                                          }];
                     }];
}

-(void)close
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveLinear 
                     animations:^{
                         self.view.alpha = 0.0f;
                     } completion:^(BOOL finished){
                         [self.view removeFromSuperview];
                         [_backgroundView removeFromSuperview];
                     }];    
}


#pragma mark -
#pragma mark UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *query = url.fragment;
    if (!query) {
        query = url.query;
    }
    NSDictionary *params = [query urlParamsDecodeDictionary];
    if ([params objectForKey:@"error"]) {
        //错误 
        return NO;
    };

    if(_type == kOAuthTypeCode)
    {
        if ([params objectForKey:@"code"]) {
            completionBlock(params);
            _isComplete = YES;
            return NO;
        }   
    }else if(_type == kOAuthTypeAccessToken)
    {
        if ([params objectForKey:@"access_token"]) {
            completionBlock(params);
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
        failedBlock(nil); 
    }
}
@end
