//
//  SeatType.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-15.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeatType : NSObject
@property (nonatomic) NSString *seatTypeCode;
@property (nonatomic) NSString *seatTypeName;
@property (nonatomic) NSString *seatPrice;

-(id)initWithCode:(NSString*)code name:(NSString*)name;
@end
