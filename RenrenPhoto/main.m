//
//  main.m
//  RenrenPhoto
//
//  Created by  on 12-8-31.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "UIEventProbeApplication.h"
int main(int argc, char *argv[])
{
    @autoreleasepool {
        //return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        return UIApplicationMain(argc, argv, NSStringFromClass([UIEventProbeApplication class]), NSStringFromClass([AppDelegate class]));
    }
}
