//
//  PopUpView.m
//  Lottery
//
//  Created by wangbo on 10-10-29.
//  Copyright 2010 netease. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PopUpView.h"


@implementation PopUpView
@synthesize hintLabel;

- (id)init{
    if ((self = [super initWithFrame:CGRectMake(90, 160, 140, 140)])) {
        self.backgroundColor = [UIColor blackColor];
		self.alpha = 0.5f;
		self.layer.cornerRadius = 10;
		indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(55,30, 30, 30)];
		[self addSubview:indicator];
		
		hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90,120, 25)];
		hintLabel.textAlignment = UITextAlignmentCenter;
		hintLabel.backgroundColor = [UIColor clearColor];
		hintLabel.font = [UIFont boldSystemFontOfSize:15];
		hintLabel.textColor = [UIColor whiteColor];
		[self addSubview:hintLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) showInView:(UIView *)superView{
	[indicator startAnimating];
	if (! hintLabel.text) {
		hintLabel.text = @"正在加载...";
	}
	[superView addSubview:self];
	[superView bringSubviewToFront:self];
}

-(void) destory{
	[self removeFromSuperview];
}


-(void) closeAfterSeconds:(NSUInteger) seconds{
	
}									

@end
