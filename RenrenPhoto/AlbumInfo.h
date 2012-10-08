//
//  AlbumInfo.h
//  RenrenPhoto
//
//  Created by  on 12-9-10.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumInfo : NSObject
{
    NSNumber *_aid;
    NSString *_url;
    NSNumber *_uid;
    NSString *_name;
    NSString *_createTime;
    NSString *_updateTime;
    NSString *_description;
    NSString *_location;
    NSNumber *_size;
    NSNumber *_visible;
    NSNumber *_commentCount;
    NSNumber *_type;
}
@property (nonatomic) NSNumber *aid;
@property (nonatomic) NSString *url;
@property (nonatomic) NSNumber *uid;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *createTime;
@property (nonatomic) NSString *updateTime;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *location;
@property (nonatomic) NSNumber *size;
@property (nonatomic) NSNumber *visible;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic) NSNumber *type;

-(id)initWithDictionary:(NSDictionary*)album;

@end
