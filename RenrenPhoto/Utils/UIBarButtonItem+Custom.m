//
//  UIBarButtonItem+Custom.m
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-23.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"
#import "IconImage.h"

@implementation UIBarButtonItem (Custom)


-(id)initWithViewController:(UIViewController *) controller{
    NSArray *viewControllers = controller.navigationController.viewControllers;
    NSUInteger index = [viewControllers indexOfObject:controller];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    UIButton *button = [UIButton buttonWithType:UIBarButtonItemStylePlain];
    [button setImage:[IconImage backBtnBlackImage] forState:UIControlStateNormal];
    [button setImage:[IconImage backBtnHoverImage] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 40, 40);
    
	self.customView = button;
    button.enabled = YES;
	self.target = controller;
	[button addTarget:self action:@selector(popController:) forControlEvents:UIControlEventTouchUpInside];
	return self;
}


-(void) popController:(id) sender{
	UIViewController *controller= (UIViewController *)self.target;
	if (!controller) {
		return;
	}
	UINavigationController *navController = (UINavigationController *) controller.navigationController;
	if (! navController) {
		return;
	}
	[navController popViewControllerAnimated:YES];
}


@end
