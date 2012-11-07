//
//  UserInfo.m
//  RenrenPhoto
//
//  Created by  on 12-9-10.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize uid = _uid;
@synthesize name = _name;
@synthesize sex = _sex;
@synthesize headurl = _headurl;
@synthesize tinyurl = _tinyurl;
@synthesize vip = _vip;
@synthesize star = _star;
@synthesize zidou = _zidou;
-(id)initWithDictionary:(NSDictionary*)userInfo
{
    if (self = [super init]) {
        _uid = [userInfo objectForKey:@"uid"];
        _name = [userInfo objectForKey:@"name"];
        _sex = [userInfo objectForKey:@"sex"];
        _headurl = [userInfo objectForKey:@"headurl"];
        _tinyurl = [userInfo objectForKey:@"tinyurl"];
        _vip = [userInfo objectForKey:@"vip"];
        _star = [userInfo objectForKey:@"star"];
        _zidou = [userInfo objectForKey:@"zidou"];
    }
    return self;
}

-(id)initWithFriendInfo:(FriendInfo *)friend
{
    if (self = [super init]) {
        self.uid = friend.id;
        self.name = friend.name;
        self.sex = friend.sex;
        self.headurl = friend.headurl;
        self.tinyurl = friend.logoTinyurl;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"id:%@ name:%@ sex:%@ headerurl:%@",_uid,_name,_sex,_headurl];
}

@end