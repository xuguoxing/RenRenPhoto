//
//  AlbumInfo.m
//  RenrenPhoto
//
//  Created by  on 12-9-10.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "AlbumInfo.h"

@implementation AlbumInfo
@synthesize aid = _aid;
@synthesize url = _url;
@synthesize uid = _uid;
@synthesize name = _name;
@synthesize createTime = _createTime;
@synthesize updateTime = _updateTime;
@synthesize description = _description;
@synthesize location = _location;
@synthesize size = _size;
@synthesize visible = _visible;
@synthesize commentCount = _commentCount;
@synthesize type = _type;


-(id)initWithDictionary:(NSDictionary*)album
{
    if (self = [super init]) {
        _aid = [album objectForKey:@"aid"];
        _url = [album objectForKey:@"url"];
        _uid = [album objectForKey:@"uid"];
        _name = [album objectForKey:@"name"];
        _createTime = [album objectForKey:@"create_time"];
        _updateTime = [album objectForKey:@"update_time"];
        _description = [album objectForKey:@"description"];
        _location = [album objectForKey:@"location"];
        _size = [album objectForKey:@"size"];
        _visible = [album objectForKey:@"visible"];
        _commentCount = [album objectForKey:@"comment_count"];
        _type = [album objectForKey:@"type"];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@-%@-%@",_uid,_aid,_name];
}

@end
