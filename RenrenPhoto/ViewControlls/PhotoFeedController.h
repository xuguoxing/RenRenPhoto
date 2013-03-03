//
//  PhotoFeedController.h
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-19.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoFeedCell.h"
#import "MWTapDetectingImageView.h"
@interface PhotoFeedController : UIViewController<UITableViewDataSource,UITableViewDelegate,PhotoFeedCellDelegate,MWTapDetectingImageViewDelegate>

@end
