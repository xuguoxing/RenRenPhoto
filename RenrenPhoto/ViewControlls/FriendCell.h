//
//  FriendCell.h
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-23.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@interface FriendCell : UITableViewCell

@property (nonatomic) UIButton *actionButton;

-(void)setUserInfo:(UserInfo*)userInfo;

@end
