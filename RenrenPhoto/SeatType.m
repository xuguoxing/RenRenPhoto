//
//  SeatType.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-15.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "SeatType.h"

@implementation SeatType
-(id)initWithCode:(NSString*)code name:(NSString*)name
{
    if (self = [super init]) {
        _seatTypeCode = code;
        _seatTypeName = name;
    }
    return self;
}
@end
