//
//  MenuHeaderView.h
//  StackScrollView
//
//  Created by Aaron Brethorst on 5/15/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuHeaderView : UIView
{
	UIImageView *imageView;
	UILabel *textLabel;
}
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *textLabel;
@end
