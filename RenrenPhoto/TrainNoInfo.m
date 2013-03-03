//
//  TrainNoInfo.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-11.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "TrainNoInfo.h"

@implementation TrainNoInfo
//[{"end_station_name":"上海虹桥","end_time":"12:23","id":"240000G10102","start_station_name":"北京南","start_time":"07:00","value":"G101"},
-(id)initWithDictionary:(NSDictionary *)trainNoDic
{
    if (self = [super init]) {
        _startStationName = [trainNoDic objectForKey:@"start_station_name"];
        _startTime = [trainNoDic objectForKey:@"start_time"];
        _endStationName = [trainNoDic objectForKey:@"end_station_name"];
        _endTime = [trainNoDic objectForKey:@"end_time"];
        _trainNoId = [trainNoDic objectForKey:@"id"];
        _trainNo = [trainNoDic objectForKey:@"value"];
    }
    return self;
}
@end
