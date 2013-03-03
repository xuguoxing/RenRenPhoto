//
//  PhotoComment.h
//  RenrenPhoto
//
//  Created by  on 12-9-11.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/*uidt	表示回复者的用户id
namet	表示回复者的名字
headurlt	表示回复者的头像
comment_idt	表示回复的id
timet	表示回复的时间
textt	表示回复的内容
is_whispert	表示回复是否为悄悄话
sourcet	表示回复的来源，“mobile”表示来源于手机*/
@interface PhotoComment : NSObject
{
    NSNumber *_uid;
    NSString *_name;
    NSString *_headUrl;
    NSNumber *_commentId;
    NSString *_time;
    NSString *_text;
    NSNumber *_isWhisper;
    NSString *_source;
}
@property (nonatomic) NSNumber *uid;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *headUrl;
@property (nonatomic) NSNumber *commentId;
@property (nonatomic) NSString *time;
@property (nonatomic) NSString *text;
@property (nonatomic) NSNumber *isWhisper;
@property (nonatomic) NSString *source;

-(id)initWithDictionary:(NSDictionary*)photoComment;

@end
