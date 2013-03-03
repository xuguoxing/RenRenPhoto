//
//  PhotoFeedCell.m
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-20.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "PhotoFeedCell.h"
#import "CommonColor.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "IconImage.h"
#import "UserInfo.h"
#import "Renren.h"
#import "UIView+CustomViewController.h"
@implementation PhotoFeedCell
{
    UIView *backView;
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *descLabel;
    UIImageView *photoImageView;
    UILabel *contentLabel;
    UILabel *timeLabel;
}

@synthesize photoImageView = photoImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        backView = [[UIView alloc]initWithFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(3, 6, 3, 6))];
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        backView.userInteractionEnabled = YES;
        backView.layer.borderColor = [[CommonColor darkTextColor] CGColor];
        backView.layer.borderWidth  = 1;
        backView.layer.cornerRadius = 5;
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 36.0, 36.0)];
        headImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.layer.borderColor = [[CommonColor darkTextColor] CGColor];
        headImageView.layer.borderWidth = 1;
        headImageView.layer.cornerRadius = 3;
        headImageView.clipsToBounds = YES;
        [backView addSubview:headImageView];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+5, CGRectGetMinY(headImageView.frame), 200, 16)];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.textColor = [CommonColor blackTextColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [backView addSubview:nameLabel];
        
        descLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+5, CGRectGetMaxY(headImageView.frame)-14, 200, 14)];
        descLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.textAlignment = UITextAlignmentLeft;
        descLabel.textColor = [CommonColor grayTextColor];
        descLabel.font = [UIFont systemFontOfSize:12];
        [backView addSubview:descLabel];
        
        //50 310
        photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImageView.frame), 50, 155, 155)];
        photoImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        photoImageView.clipsToBounds = YES;
        [backView addSubview:photoImageView];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImageView.frame), CGRectGetMaxY(photoImageView.frame)+5, 300, 20)];
        contentLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.textColor = [CommonColor blackTextColor];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [backView addSubview:contentLabel];
        
        UIView *tailView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(backView.frame)-25, CGRectGetWidth(backView.frame), 25)];
        tailView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        tailView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.97f alpha:1.00f];
        [backView addSubview:tailView];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, CGRectGetWidth(tailView.frame)-6, CGRectGetHeight(tailView.frame))];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [CommonColor grayTextColor];
        [tailView addSubview:timeLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetected:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)tapDetected:(UITapGestureRecognizer*)tap
{
    UIViewController *controller = [self detectParentController];
    if (!controller) {
        return;
    }
    
    CGPoint location = [tap locationInView:backView];
    BOOL headTouched = NO;
    BOOL photoTouched = NO;
    CGRect headRect = CGRectMake(5, 5, CGRectGetWidth(backView.frame)-10, CGRectGetHeight(headImageView.frame));
    if (CGRectContainsPoint(headRect, location)) {
        headTouched = YES;
    }
    if (!headTouched) {
        if (CGRectContainsPoint(photoImageView.frame, location)) {
            photoTouched = YES;
        }
    }
    
    if (headTouched) {
        if ([controller respondsToSelector:@selector(headerTouched:)]) {
            [controller performSelector:@selector(headerTouched:) withObject:self];
        }
    }else if(photoTouched){
        if ([controller respondsToSelector:@selector(photoTouched:)]) {
            [controller performSelector:@selector(photoTouched:) withObject:self];
        }
    }
}

+(CGFloat)heightForPhotoFeed:(PhotoFeed*)feed
{
    CGFloat height = 203+10+25+6;
    NSString *content = feed.content;
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(302, 200) lineBreakMode:NSLineBreakByWordWrapping];
    return height + size.height;
}

-(void)setPhotoFeed:(PhotoFeed *)feed
{
    [headImageView setImageWithURL:[NSURL URLWithString:feed.headUrl] placeholderImage:[IconImage emptyPhotoImage]];
    [photoImageView setImageWithURL:[NSURL URLWithString:feed.rawSrc] placeholderImage:[IconImage emptyPhotoImage]];
    contentLabel.text = feed.content;
    timeLabel.text = feed.updateTime;
    
    CGSize size = [feed.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(302, 200) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = contentLabel.frame;
    frame.size.height = size.height;
    contentLabel.frame = frame;
    
    UserInfo *userInfo = [[Renren sharedRenren] getUserInfoById:[feed.uId stringValue]];
    if (userInfo) {
        nameLabel.text = userInfo.name;
    
        NSMutableString *desc = [[NSMutableString alloc]init];
        if (userInfo.universityName) {
            [desc appendString:userInfo.universityName];
            if (userInfo.department) {
                [desc appendFormat:@" %@",userInfo.department];
            }
        }
        descLabel.text = desc;
    }else{
        [[Renren sharedRenren] getUserInfo:[feed.uId stringValue] withCompletionBlock:^(UserInfo *userInfo) {
            
        } failedBlock:^(NSError *error) {
            
        }];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
