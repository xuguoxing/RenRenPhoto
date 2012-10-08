//
//  MainViewController.h
//  RenrenPhoto
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Renren.h"
@interface MainViewController : UIViewController
{

    UIImageView *_headImageView;
    UILabel     *_userNameLable;
    UIButton    *_loginButton;
    UIButton    *_logoutButton;
    
    UserInfo    *_myInfo;
}
@property (nonatomic) UIImageView *headImageView;
@property (nonatomic) UILabel *userNameLable;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIButton *logoutButton;
@property (nonatomic) UserInfo *myInfo;
@end
