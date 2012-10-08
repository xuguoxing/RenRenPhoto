//
//  PhotoInfo.m
//  RenrenPhoto
//
//  Created by  on 12-9-11.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "PhotoInfo.h"

@implementation PhotoInfo
@synthesize pid = _pid;
@synthesize aid = _aid;
@synthesize uid = _uid;
@synthesize tinyUrl = _tinyUrl;
@synthesize headUrl = _headUrl;
@synthesize mainUrl = _mainUrl;
@synthesize largeUrl = _largeUrl;
@synthesize caption = _caption;
@synthesize time = _time;
@synthesize viewCount = _viewCount;
@synthesize commentCount = _commentCount;
@synthesize sourceText = _sourceText;
@synthesize sourceUrl = _sourceUrl;

-(id)initWithDictionary:(NSDictionary*)photoInfo
{
    if (self = [super init]) {
        _pid = [photoInfo objectForKey:@"pid"];
        _aid = [photoInfo objectForKey:@"aid"];
        _uid = [photoInfo objectForKey:@"uid"];
        _tinyUrl = [photoInfo objectForKey:@"url_tiny"];
        _headUrl = [photoInfo objectForKey:@"url_head"];
        _mainUrl = [photoInfo objectForKey:@"url_main"];
        _largeUrl = [photoInfo objectForKey:@"url_large"];
        _caption = [photoInfo objectForKey:@"caption"];
        _time = [photoInfo objectForKey:@"time"];
        _viewCount = [photoInfo objectForKey:@"view_count"];
        _commentCount = [photoInfo objectForKey:@"comment_count"];
        NSDictionary *souce = [photoInfo objectForKey:@"source"];
        if (souce) {
            _sourceText = [souce objectForKey:@"text"];
            _sourceUrl = [souce objectForKey:@"href"];
        }
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@-%@-%@-%@",_uid,_aid,_pid,_largeUrl];
}

@end
