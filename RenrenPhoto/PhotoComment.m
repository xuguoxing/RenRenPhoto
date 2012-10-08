//
//  PhotoComment.m
//  RenrenPhoto
//
//  Created by  on 12-9-11.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "PhotoComment.h"

@implementation PhotoComment
@synthesize uid = _uid;
@synthesize name = _name;
@synthesize headUrl = _headUrl;
@synthesize commentId = _commentId;
@synthesize time = _time;
@synthesize text = _text;
@synthesize isWhisper = _isWhisper;
@synthesize source = _source;

-(id)initWithDictionary:(NSDictionary*)photoComment
{
    if (self = [super init]) {
        _uid = [photoComment objectForKey:@"uid"];
        _name = [photoComment objectForKey:@"name"];
        _headUrl = [photoComment objectForKey:@"headurl"];
        _commentId = [photoComment objectForKey:@"comment_id"];
        _time = [photoComment objectForKey:@"time"];
        _text = [photoComment objectForKey:@"text"];
        _isWhisper = [photoComment objectForKey:@"is_whisper"];
        _source = [photoComment objectForKey:@"source"];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@-%@-%@",_uid,_name,_text];
}

@end
