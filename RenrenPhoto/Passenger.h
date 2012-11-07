//
//  Passenger.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-1.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/*address = "";
 "born_date" =             {
 date = 3;
 day = 3;
 hours = 0;
 minutes = 0;
 month = 3;
 seconds = 0;
 time = 481305600000;
 timezoneOffset = "-480";
 year = 85;
 };
 code = 4;
 "country_code" = CN;
 email = "xugx2007@gmail.com";
 "first_letter" = NURNBERG;
 isUserSelf = Y;
 "mobile_no" = 18666211427;
 "old_passenger_id_no" = "";
 "old_passenger_id_type_code" = "";
 "old_passenger_name" = "";
 "passenger_flag" = 0;
 "passenger_id_no" = 371525198504033718;
 "passenger_id_type_code" = 1;
 "passenger_id_type_name" = "\U4e8c\U4ee3\U8eab\U4efd\U8bc1";
 "passenger_name" = "\U5f90\U56fd\U5174";
 "passenger_type" = 1;
 "passenger_type_name" = "\U6210\U4eba";
 "phone_no" = "";
 postalcode = "";
 recordCount = 7;
 "sex_code" = M;
 "sex_name" = "\U7537";
 studentInfo = "<null>";*/
@interface Passenger : NSObject

@property (nonatomic) NSString *passengerName;  //姓名
@property (nonatomic) NSString *sexCode;        //性别码 M/F
@property (nonatomic) NSString *sexName;        //性别 男/女
@property (nonatomic) NSDate   *bornDate;       //出生日期
@property (nonatomic) NSString *countryCode;    //国家地区 CN ..
@property (nonatomic) NSString *passengerIdTypeCode;  //证件类型  1 
@property (nonatomic) NSString *passengerIdTypeName;   //证件类型 二代身份证
@property (nonatomic) NSString *passengerIdNo;  //证件号码
@property (nonatomic) NSString *passengerType;   //乘客类型 1
@property (nonatomic) NSString *passengerTypeName; //乘客类型 成人


@property (nonatomic) NSString *firstLetter;    //self:用户名 其他:姓名首字母
@property (nonatomic) NSString *isUserSelf;     //是否用户本身 Y/N


@property (nonatomic) NSString *mobileNo; //手机号码
@property (nonatomic) NSString *phoneNo;  //固定电话
@property (nonatomic) NSString *email;    //电子邮件
@property (nonatomic) NSString *address;  //地址
@property (nonatomic) NSString *postalCode; //邮编

@property (nonatomic) NSString *studentInfo; //学生信息,待确定

@property (nonatomic) NSString *passengerFlag;  // 0 ... 什么意思
@property (nonatomic) NSString *code;  //联系人索引,没啥用

-(id)initWithDictionary:(NSDictionary*)dic;











@end
