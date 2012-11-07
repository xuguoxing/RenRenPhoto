//
//  TrainInfo.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-28.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainInfo : NSObject


@property (nonatomic) NSString *trainCode;  //T107
@property (nonatomic) NSString *startTime;
@property (nonatomic) NSString *lishi;
@property (nonatomic) NSString *arriveTime;
@property (nonatomic) NSString *trainNo; //240000D31904
@property (nonatomic) NSString *fromStationTelecode;
@property (nonatomic) NSString *toStationTelecode;
@property (nonatomic) NSString *fromStationName;
@property (nonatomic) NSString *toStationName;
@property (nonatomic) NSString *ypInfoDetail;
@property (nonatomic) NSString *mmStr;
@property (nonatomic) NSMutableArray *seatsNumArray;


-(id)initWithQueryString:(NSString*)string;
-(NSString*)ticketInfo;
@end
