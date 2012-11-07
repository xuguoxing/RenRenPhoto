//
//  LoginViewController.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-15.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDetectingImageView.h"
#import "PopUpView.h"
@interface LoginViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,TapDetectingImageViewDelegate>
{
    NSMutableData *responceData;
    UITextField *userNameField;
    UITextField *passWordField;
    UITextField *verifyCodeField;
    TapDetectingImageView *verifyCodeImageView;
    UIButton    *loginButton;
    
    PopUpView *popView;

    
    NSString *loginRand;
    NSString *refundLogin;
    NSString *refundFlag;
    NSString *userName;
    NSString *nameErrorFocus;
    NSString *password;
    NSString *passwordErrorFocus;
    NSString *randCode;
    NSString *randErrorFocus;
}
@end
