//
//  MenuTableViewCell.m
//  StackScrollView
//
//  Created by Aaron Brethorst on 5/15/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "IconImage.h"
@implementation MenuTableViewCell
@synthesize glowView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		self.clipsToBounds = YES;
		
		/*UIView* bgView = [[UIView alloc] init];
		bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.25f];
		self.selectedBackgroundView = bgView;*/
				
		self.textLabel.font = [UIFont systemFontOfSize:15];
		
		self.imageView.contentMode = UIViewContentModeCenter;
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 214, 1)];
		topLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.25];
		[self.textLabel.superview addSubview:topLine];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 214, 1)];
		bottomLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
		[self.textLabel.superview addSubview:bottomLine]; 
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(188, (CGRectGetHeight(self.frame)-9)/2, 9, 16)];
        arrowImageView.image = [IconImage leftMenuCornerRightImage];
        [self addSubview:arrowImageView];
		
		/*glowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 43)];
		glowView.image = [UIImage imageNamed:@"glow.png"];
		glowView.hidden = YES;
		[self addSubview:glowView];*/
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.textLabel.frame = CGRectMake(70, 3, 125, 43);
	self.imageView.frame = CGRectMake(0, 3, 65, 43);
}



- (void)setSelected:(BOOL)sel animated:(BOOL)animated
{
	[super setSelected:sel animated:animated];
		
	if (sel)
	{
        self.textLabel.textColor = [UIColor colorWithRed:0.27f green:0.73f blue:0.90f alpha:1.00f];
        self.imageView.image = self.highlightImage;
	}
	else
	{
        self.textLabel.textColor = [UIColor whiteColor];
        self.imageView.image = self.image;
	}
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.textLabel.textColor = [UIColor colorWithRed:0.27f green:0.73f blue:0.90f alpha:1.00f];
        self.imageView.image = self.highlightImage;
    }else{
        self.textLabel.textColor = [UIColor whiteColor];
        self.imageView.image = self.image;
    }
}

@end
