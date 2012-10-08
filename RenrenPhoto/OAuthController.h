//
//  OAuthController.h
//  RenrenPhoto
//
//  Created by  on 12-9-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum {
    kOAuthTypeUnKnown,
    kOAuthTypeCode,
    kOAuthTypeAccessToken
} OAuthType;

@interface OAuthController : UIViewController<UIWebViewDelegate>
{
    UIView *_backgroundView;
    UIButton *_cancelButton;
    UIWebView *_webView;
    UIActivityIndicatorView *_indicatorView;
    
    NSString *_serverUrl;
    NSMutableDictionary *_params;
    
    OAuthType _type;
    
    BOOL _isComplete;
    
    void(^completionBlock)(NSDictionary *params);
    void(^failedBlock)(NSDictionary *params);    
}

@property (nonatomic) NSString *serverUrl;
@property (nonatomic) NSMutableDictionary *params;
@property (nonatomic) OAuthType type;
@property (nonatomic,copy) void(^completionBlock)(NSDictionary *params);
@property (nonatomic,copy) void(^failedBlock)(NSDictionary *params);  

-(void)show;
-(void)close;

@end
