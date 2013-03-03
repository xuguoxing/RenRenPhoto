//
//  TrainSession.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainHTTPClient.h"
#import "Passenger.h"
#import "StationInfo.h"
#import "TrainNoInfo.h"
#import "TrainTicketInfo.h"
#import "SeatType.h"
@interface TrainSession : NSObject

//常量数据
@property (nonatomic) NSMutableArray *seatTypeArray;  //座位类型数组
@property (nonatomic) NSMutableArray *seatDetailTypeArray;  //座位类型数组
@property (nonatomic) NSMutableArray *ticketTypeArray; //票类型数组 
@property (nonatomic) NSMutableArray *cardTypeArray; //票类型数组

//登录
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *passWord;
@property (nonatomic) NSString *loginRandCode;
@property (nonatomic) NSString *loginVerifyCode;

//类型 0 登陆 1 提交订单
-(void)refreshVerifyCodeImageType:(NSInteger)type withCompletion:(void(^)(UIImage *image,NSError *err))completion;
-(void)loginWithCompletion:(void(^)(BOOL success,NSError *error))completion;

//车站查询
-(void)getAllStationsWithCompletion:(void(^)(NSArray *stationsArray,NSError *error))completion;
-(void)getFavStationsWithCompletion:(void(^)(NSArray *stationsArray,NSError *error))completion;

@property (nonatomic) NSMutableArray *usualPassengersArray;
@property (nonatomic) Passenger *userInfo;

-(void)getUsualPassengersWithCompletion:(void(^)(NSMutableArray *usualPassengers,NSError *error))completion;

//车次查询
@property (nonatomic) NSString *startDate;
@property (nonatomic) NSString *startDateWeek;
@property (nonatomic) NSString *startTime;
@property (nonatomic) StationInfo *fromStation;
@property (nonatomic) StationInfo *toStation;
//@property (nonatomic) NSString *fromStationTelecode;
//@property (nonatomic) NSString *fromStationName;
//@property (nonatomic) NSString *toStationTelecode;
//@property (nonatomic) NSString *toStationName;
@property (nonatomic) NSString *trainClass;  //@"QB#D#Z#T#K#QT#"
@property (nonatomic) NSString *trainPassType;  //@"QB"
@property (nonatomic) NSString *seatTypeNum;  // @""
@property (nonatomic) NSString *includeStudent; //@"00"

@property (nonatomic) NSMutableArray *trainNoInfoArray;
@property (nonatomic) TrainNoInfo *selectTrainNoInfo;


@property (nonatomic) NSMutableArray *trainTicketInfoArray;
@property (nonatomic) TrainTicketInfo *selectTrainTicketInfo;
//查询所有车次
-(void)queryAllTrainNoWithCompletion:(void(^)(NSMutableArray* trainNoInfoArray,NSError *error))completion;
//查询剩余票数
-(void)queryLeftTicketWithCompletion:(void(^)(NSMutableArray *trainTicketInfoArray,NSError *error))completion;


@property (nonatomic) NSString *submitOrderResponce;
@property (nonatomic) NSString *leftTicket;
@property (nonatomic) NSMutableArray *ticketTypePrices;

-(void)submitOrderRequestWithCompletion:(void(^)(NSString *responseString,NSError *error))completion;

+(TrainSession*)sharedSession;

@end


@interface CodeValuePair : NSObject
@property (nonatomic) NSString *code;
@property (nonatomic) NSString *value;

-(id)initWithCode:(NSString*)code value:(NSString*)value;
@end