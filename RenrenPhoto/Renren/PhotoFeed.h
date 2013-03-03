//
//  PhotoFeed.h
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-19.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>



/*
 {
 "actor_id" = 234971828;
 "actor_type" = user;
 attachment =     (
 {
 content = "\U6708\U5b63\U54a9";
 href = "http://photo.renren.com/photo/234971828/album-854810365";
 "media_id" = 6954003118;
 "media_type" = photo;
 "owner_id" = 234971828;
 "raw_src" = "http://fmn.rrfmn.com/fmn058/20130215/1925/large_WPzV_40240000ccf7125c.jpg";
 src = "http://fmn.rrfmn.com/fmn058/20130215/1925/head_WPzV_40240000ccf7125c.jpg";
 }
 );
 comments =     {
 count = 0;
 };
 "feed_type" = 30;
 headurl = "http://hdn.xnimg.cn/photos/hdn121/20100517/0715/h_tiny_Y2WJ_76530000d2772f74.jpg";
 href = "http://photo.renren.com/photo/234971828/album-854810365";
 likes =     {
 "friend_count" = 0;
 "total_count" = 0;
 "user_like" = 0;
 };
 name = "\U4ed8\U5e27";
 "post_id" = 21405748962;
 prefix = "\U4e0a\U4f20\U4e861\U5f20\U7167\U7247";
 "source_id" = 854810365;
 title = "\U5c0f\U59d1\U5a18";
 "update_time" = "2013-02-15 19:27:54";
 },

 */

@interface PhotoFeed : NSObject

@property (nonatomic) NSNumber *uId;
@property (nonatomic) NSNumber *ownerId;
@property (nonatomic) NSNumber *albumId;
@property (nonatomic) NSNumber *mediaId;
@property (nonatomic) NSString *src;
@property (nonatomic) NSString *rawSrc;

@property (nonatomic) NSString *content;
@property (nonatomic) NSString *updateTime;

@property (nonatomic) NSString *headUrl;

-(id)initWithDictionary:(NSDictionary*)dic;
@end
