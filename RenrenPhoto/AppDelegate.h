//
//  AppDelegate.h
//  RenrenPhoto
//
//  Created by  on 12-8-31.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MainViewController *mainController;
    UINavigationController *nav;
}

@property (strong, nonatomic) UIWindow *window;

@end
