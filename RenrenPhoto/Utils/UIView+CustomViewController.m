//
//  UIViewController+CustomNavBar.m
//  TUSHUO
//
//  Created by  on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIView+CustomViewController.h"

@implementation UIView (CustomViewController)
-(UIViewController*)detectParentController{
	UIResponder *responder = [self nextResponder];
	while (responder) {
		if ([responder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)responder;
		}
		responder = [responder nextResponder];
	}
	return nil;
}

-(void) popViewController{
    UIViewController *viewController = [self detectParentController];
    if (viewController != nil) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }
}


@end


