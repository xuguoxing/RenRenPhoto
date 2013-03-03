//
//  FriendCell.m
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-23.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "FriendCell.h"
#import "CommonColor.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "IconImage.h"
@implementation FriendCell
{
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *descLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 36.0, 36.0)];
        headImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.layer.borderColor = [[CommonColor darkTextColor] CGColor];
        headImageView.layer.borderWidth = 1;
        headImageView.layer.cornerRadius = 3;
        headImageView.clipsToBounds = YES;
        [self addSubview:headImageView];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+5, CGRectGetMinY(headImageView.frame), 200, 17)];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.textColor = [CommonColor blackTextColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:nameLabel];
        
        descLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+5, CGRectGetMaxY(headImageView.frame)-15, 200, 15)];
        descLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.textAlignment = UITextAlignmentLeft;
        descLabel.textColor = [CommonColor grayTextColor];
        descLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:descLabel];
        
        /*UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        actionButton.frame = CGRectMake(220, 13, 80, 30);
        [actionButton setTitle:@"查看相册" forState:UIControlStateNormal];
        [self addSubview:actionButton];
        self.actionButton = actionButton;*/
    }
    return self;
}

-(void)setUserInfo:(UserInfo *)userInfo
{
    [headImageView setImageWithURL:[NSURL URLWithString:userInfo.headurl] placeholderImage:[IconImage emptyPhotoImage]];
    nameLabel.text = userInfo.name;
    
    NSMutableString *desc = [[NSMutableString alloc]init];
    if (userInfo.universityName) {
        [desc appendString:userInfo.universityName];
        if (userInfo.department) {
            [desc appendFormat:@" %@",userInfo.department];
        }
    }
    descLabel.text = desc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
