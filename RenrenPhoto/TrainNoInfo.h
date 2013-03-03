//
//  TrainNoInfo.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-11.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//G101（北京南07:00→上海虹桥12:23）
@interface TrainNoInfo : NSObject
-(id)initWithDictionary:(NSDictionary*)trainNoDic;

@property (nonatomic) NSString *trainNo;
@property (nonatomic) NSString *trainNoId;
@property (nonatomic) NSString *startStationName;
@property (nonatomic) NSString *endStationName;
@property (nonatomic) NSString *startTime;
@property (nonatomic) NSString *endTime;
@end
