//
//  UserInfo.h
//  RenrenPhoto
//
//  Created by  on 12-9-10.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendInfo.h"
@interface UserInfo : NSObject
{
    NSNumber *_uid;
    NSString *_name;
    NSNumber *_sex;
    NSString *_headurl;
    NSString *_tinyurl;
    NSNumber *_vip;
    NSNumber *_star;
    NSNumber *_zidou;
    
}

/*hometown_location		表示家乡信息
country(子节点)	string	表示所在国家
province(子节点)	string	表示所在省份
city(子节点)	string	表示所在城市
work_info		表示工作信息
company_name(子节点)	string	表示所在公司
description(子节点)	string	表示工作描述
start_date(子节点)	string	表示入职时间
end_date(子节点)	string	表示离职时间
university_info		表示就读大学信息
name(子节点)	string	表示大学名
year(子节点)	string	表示入学时间
department(子节点)	string	表示学院*/

@property (nonatomic) NSNumber *uid;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *sex;
@property (nonatomic) NSNumber *vip;
@property (nonatomic) NSNumber *star;
@property (nonatomic) NSNumber *zidou;
@property (nonatomic) NSString *birthday;

@property (nonatomic) NSString *headurl;
@property (nonatomic) NSString *tinyurl;
@property (nonatomic) NSString *mainurl;

@property (nonatomic) NSString *universityName;
@property (nonatomic) NSString *department;
@property (nonatomic) NSNumber *year;

@property (nonatomic) NSString *province;
@property (nonatomic) NSString *city;


-(id)initWithDictionary:(NSDictionary*)userInfo;
-(id)initWithFriendInfo:(FriendInfo*)friend;
@end

