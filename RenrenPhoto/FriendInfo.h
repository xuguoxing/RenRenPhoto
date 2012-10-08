//
//  FriendInfo.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-9-16.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendInfo : NSObject
{
    NSNumber *_id;
    NSString *_name;
    NSNumber *_sex;
    NSString *_headurl;
    NSString *_logoHeadurl;
    NSString *_logoTinyurl;
}
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *sex;
@property (nonatomic) NSString *headurl;
@property (nonatomic) NSString *logHeadurl;
@property (nonatomic) NSString *logoTinyurl;

-(id)initWithDictionary:(NSDictionary*)friendInfo;

@end
