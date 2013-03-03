//
//  DateUtils.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-22.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "DateUtils.h"


NSString* getDateString(NSDate* date){
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formater stringFromDate:date];
    return dateString;
}

NSString *getWeekString(NSDate *date){
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    NSArray * weekdays = [formater weekdaySymbols];
    int weekday = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];
    NSString *weekString = [weekdays objectAtIndex:weekday-1];
    return weekString;
}