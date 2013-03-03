//
//  PopUpView.h
//  Lottery
//
//  Created by wangbo on 10-10-29.
//  Copyright 2010 netease. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PopUpView : UIView {
	UIActivityIndicatorView *indicator;
	UILabel   *hintLabel;
}

@property(nonatomic) UILabel  *hintLabel;

-(void) closeAfterSeconds:(NSUInteger) seconds;
-(void) destory;
-(void) showInView:(UIView *)superView;

@end



