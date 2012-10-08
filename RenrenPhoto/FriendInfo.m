//
//  FriendInfo.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-9-16.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "FriendInfo.h"
/*/*<friend>	节点表示一个好友的信息
 <id>	子节点表示好友的用户ID
 <name>	子节点表示好友的名字
 <sex>	子节点表示好友的性别，值1表示男性；值0表示女性；值为空表示用户没有该信息
 <headurl>	子节点表示好友的头像
 <headurl_with_logo>	带有校内logo的头像
 <tinyurl_with_logo>	带有校内logo的小头像*/
@implementation FriendInfo
@synthesize id = _id;
@synthesize name = _name;
@synthesize sex = _sex;
@synthesize headurl = _headurl;
@synthesize logHeadurl = _logoHeadurl;
@synthesize logoTinyurl = _logoTinyurl;

-(id)initWithDictionary:(NSDictionary*)friendInfo
{
    if (self = [super init]) {
        _id = [friendInfo objectForKey:@"id"];
        _name = [friendInfo objectForKey:@"name"];
        _sex = [friendInfo objectForKey:@"sex"];
        _headurl = [friendInfo objectForKey:@"headurl"];
        _logoHeadurl = [friendInfo objectForKey:@"headurl_with_logo"];
        _logoTinyurl = [friendInfo objectForKey:@"tinyurl_with_logo"];
    }
    return self;
}



-(NSString *)description
{
    return [NSString stringWithFormat:@"%@-%@-%@",_id,_name,_logoHeadurl];
}
@end
