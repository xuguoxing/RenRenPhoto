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

/*[{"uid":234971828,"hometown_location":{},"sex":0,"university_history":[{"department":"新闻与传播学院","name":"武汉大学","year":2007}],"work_history":[],"name":"付帧","headurl":"http://hdn.xnimg.cn/photos/hdn121/20100517/0715/h_head_s9Cs_76530000d2772f74.jpg"},{"uid":200130052,"hometown_location":{"province":"山东","city":"聊城市"},"sex":1,"university_history":[{"department":"电子信息学院","name":"武汉大学","year":2003}],"work_history":[],"name":"徐国兴","headurl":"http://hdn.xnimg.cn/photos/hdn421/20100726/1455/h_head_FV23_1b02000103572f74.jpg"},{"uid":260822099,"hometown_location":{"province":"广西","city":"桂林市"},"sex":0,"university_history":[{"department":"\344\277\241息管理学院","name":"武汉大学","year":2008}],"work_history":[],"name":"秦艳琴","headurl":"http://hdn.xnimg.cn/photos/hdn411/20090501/0040/head_dEfF_36814g204235.jpg"}]*/

-(id)initWithDictionary:(NSDictionary*)userInfo
{
    NSLog(@"urer:%@",userInfo);
    if (self = [super init]) {
        _uid = [userInfo objectForKey:@"uid"];
        _name = [userInfo objectForKey:@"name"];
        _sex = [userInfo objectForKey:@"sex"];
        _star = [userInfo objectForKey:@"star"];
        _zidou = [userInfo objectForKey:@"zidou"];
        _vip = [userInfo objectForKey:@"vip"];
        _birthday = [userInfo objectForKey:@"birthday"];
        _headurl = [userInfo objectForKey:@"headurl"];
        _tinyurl = [userInfo objectForKey:@"tinyurl"];
        _mainurl = [userInfo objectForKey:@"mainurl"];
        
        NSArray *universityHistorys = [userInfo objectForKey:@"university_history"];
        if (universityHistorys.count>0) {
            NSDictionary *university = [universityHistorys objectAtIndex:0];
            self.universityName = [university objectForKey:@"name"];
            self.department = [university objectForKey:@"department"];
            self.year = [university objectForKey:@"year"];
        }
        
        NSDictionary *homeTown = [userInfo objectForKey:@"hometown_location"];
        if (homeTown) {
            self.province = [homeTown objectForKey:@"province"];
            self.city = [homeTown objectForKey:@"city"];
        }
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