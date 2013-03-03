//
//  PhotoFeedCell.h
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-20.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoFeed.h"
@class PhotoFeedCell;
@protocol PhotoFeedCellDelegate <NSObject>

-(void)headerTouched:(PhotoFeedCell*)cell;
-(void)photoTouched:(PhotoFeedCell*)cell;

@end

@interface PhotoFeedCell : UITableViewCell
@property (nonatomic) UIImageView *photoImageView;

+(CGFloat)heightForPhotoFeed:(PhotoFeed*)feed;

-(void)setPhotoFeed:(PhotoFeed*)feed;

@end
