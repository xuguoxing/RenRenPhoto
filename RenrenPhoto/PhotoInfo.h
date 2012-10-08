//
//  PhotoInfo.h
//  RenrenPhoto
//
//  Created by  on 12-9-11.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/*pid	表示照片的id
 aid	表示照片所在相册id
 uid	表示一张照片的所有者用户id
 url_tiny	表示一张照片超小的规格
 url_head	表示一张照片小的规格
 url_large	表示一张照片正常的规格
 caption	表示照片的描述信息
 time	表示照片的上传时间
 view_count	表示照片的查看数
 comment_count	表示照片的评论数
 source	表示照片的来源
 text	表示照片来源的名称
 href	表示照片来源的url*/
@interface PhotoInfo : NSObject
{
    NSNumber *_pid;
    NSNumber *_aid;
    NSNumber *_uid;
    NSString *_tinyUrl;
    NSString *_headUrl;
    NSString *_mainUrl;
    NSString *_largeUrl;
    NSString *_caption;
    NSString *_time;
    NSNumber *_viewCount;
    NSNumber *_commentCount;
    NSString *_sourceText;
    NSString *_sourceUrl;
}
@property (nonatomic) NSNumber *pid;
@property (nonatomic) NSNumber *aid;
@property (nonatomic) NSNumber *uid;
@property (nonatomic) NSString *tinyUrl;
@property (nonatomic) NSString *headUrl;
@property (nonatomic) NSString *mainUrl;
@property (nonatomic) NSString *largeUrl;
@property (nonatomic) NSString *caption;
@property (nonatomic) NSString *time;
@property (nonatomic) NSNumber *viewCount;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic) NSString *sourceText;
@property (nonatomic) NSString *sourceUrl;



-(id)initWithDictionary:(NSDictionary*)photoInfo;
@end
