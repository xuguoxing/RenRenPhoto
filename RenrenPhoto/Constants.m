//
//  Constants.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-23.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "Constants.h"

//登陆
NSString *const kLoginRandField = @"loginRand";
NSString *const kRefundLoginField = @"refundLogin";
NSString *const kRefundFlagField = @"refundFlag";
NSString *const kUserNameField = @"loginUser.user_name";
NSString *const kUserNameErrorFocusField = @"nameErrorFocus";
NSString *const kPasswordField = @"user.password";
NSString *const kPasswordErrorFocusField = @"passwordErrorFocus";
NSString *const kRandCodeField = @"randCode";
NSString *const kRandCodeErrorFocusField = @"randErrorFocus";

    /*GET https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=2012-10-23&orderRequest.from_station_telecode=BJP&orderRequest.to_station_telecode=SHH&orderRequest.train_no=&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00 HTTP/1.1*/
//查询余票
NSString *const kTrainDateField = @"orderRequest.train_date";
NSString *const kFromStationField = @"orderRequest.from_station_telecode";
NSString *const kToStationField = @"orderRequest.to_station_telecode";
NSString *const kTrainNoField = @"orderRequest.train_no";
NSString *const kTrainPassTypeField = @"trainPassType";
NSString *const kTrainClassField = @"trainClass";
NSString *const kStudentField = @"includeStudent";
NSString *const kSeatTypeNumField = @"seatTypeAndNum";
NSString *const kStartTimeField = @"orderRequest.start_time_str";
