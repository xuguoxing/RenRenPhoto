//
//  UserInfo.h
//  RenrenPhoto
//
//  Created by  on 12-9-10.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendInfo.h"
@interface UserInfo : NSObject
{
    NSNumber *_uid;
    NSString *_name;
    NSNumber *_sex;
    NSString *_headurl;
    NSString *_tinyurl;
    NSNumber *_vip;
    NSNumber *_star;
    NSNumber *_zidou;
    
}
@property (nonatomic) NSNumber *uid;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *sex;
@property (nonatomic) NSString *headurl;
@property (nonatomic) NSString *tinyurl;
@property (nonatomic) NSNumber *vip;
@property (nonatomic) NSNumber *star;
@property (nonatomic) NSNumber *zidou;
-(id)initWithDictionary:(NSDictionary*)userInfo;
-(id)initWithFriendInfo:(FriendInfo*)friend;
@end
