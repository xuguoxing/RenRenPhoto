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
    UIWebView *_webView;
    UIActivityIndicatorView *_indicatorView;
    
    BOOL _isComplete;
    
}

@property (nonatomic) NSString *serverUrl;
@property (nonatomic) NSDictionary *params;
@property (nonatomic) OAuthType type;
@property (nonatomic,copy) void(^completionBlock)(BOOL success,NSDictionary *params);

@end
