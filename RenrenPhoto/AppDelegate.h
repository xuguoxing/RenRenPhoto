//
//  AppDelegate.h
//  RenrenPhoto
//
//  Created by  on 12-8-31.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "LoginViewController.h"
#import "DDMenuController.h"
#import "MenuViewController.h"
#import "Renren.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MainViewController *mainController;
    //UINavigationController *nav;
}

@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) MenuViewController *leftController;
@property (strong,nonatomic) LoginViewController *loginController;

@property (strong, nonatomic) UIWindow *window;

@end
