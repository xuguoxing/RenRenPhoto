//
//  Passenger.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-1.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "Passenger.h"

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

@implementation Passenger

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (self = [super init]) {
        _passengerName = [dic objectForKey:@"passenger_name"];
        _sexCode = [dic objectForKey:@"sex_code"];
        _sexName = [dic objectForKey:@"sex_name"];
        _countryCode = [dic objectForKey:@"country_code"];
        _passengerIdTypeCode = [dic objectForKey:@"passenger_id_type_code"];
        _passengerIdTypeName = [dic objectForKey:@"passenger_id_type_name"];
        _passengerIdNo = [dic objectForKey:@"passenger_id_no"];
        _passengerType = [dic objectForKey:@"passenger_type"];
        _passengerTypeName = [dic objectForKey:@"passenger_type_name"];
        
        _firstLetter = [dic objectForKey:@"first_letter"];
        _isUserSelf =  [dic objectForKey:@"isUserSelf"];
        
        _mobileNo = [dic objectForKey:@"mobile_no"];
        _phoneNo = [dic objectForKey:@"phone_no"];
        _email = [dic objectForKey:@"email"];
        _address = [dic objectForKey:@"address"];
        _postalCode = [dic objectForKey:@"postalcode"];
    }
    return self;
}

@end
