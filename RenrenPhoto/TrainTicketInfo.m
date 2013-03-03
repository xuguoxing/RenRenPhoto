//
//  TrainInfo.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-28.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "TrainTicketInfo.h"
#import "RegexKitLite.h"
#import "NSString+HTML.h"
@implementation TrainTicketInfo
{
    NSArray *_ticketTypeArray;
}

//0,<span id='id_240000T1070D' class='base_txtdiv' onmouseover=javascript:onStopHover('240000T1070D#BXP#SZQ') onmouseout='onStopOut()'>T107</span>,<img src='/otsweb/images/tips/first.gif'>&nbsp;&nbsp;&nbsp;&nbsp;北京西&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;20:12,<img src='/otsweb/images/tips/last.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;深圳&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;19:50,23:38,--,--,--,--,--,<font color='darkgray'>无</font>,<font color='darkgray'>无</font>,--,<font color='darkgray'>无</font>,<font color='#008800'>有</font>,--,<input type='button' class='yuding_u' onmousemove=this.className='yuding_u_over' onmousedown=this.className='yuding_u_down' onmouseout=this.className='yuding_u' onclick=javascript:getSelected('T107#23:38#20:12#240000T1070D#BXP#SZQ#19:50#北京西#深圳#1*****30554*****00001*****00003*****0000#AEF4F177FF266D42BF3A68450306BD2E681FF511721E8E5CC11D9CC7') value='预订'></input>\n
-(id)initWithQueryString:(NSString *)string
{
    NSString *onClickParamsStr = [string stringByMatching:@"onclick=javascript:getSelected\\u0028\'(.*?)\'\\u0029" capture:1];
    //T107#23:38#20:12#240000T1070D#BXP#SZQ#19:50#北京西#深圳#1*****30554*****00001*****00003*****0000#AEF4F177FF266D42BF3A68450306BD2E681FF511721E8E5CC11D9CC7
    NSArray *paramsArray = [onClickParamsStr componentsSeparatedByString:@"#"];
    
    NSString *plainString = [string stringByConvertingHTMLToPlainText];
    //0,D319,    北京南        11:36,  上海虹桥      20:44,09:08,--,18,7,无 ,--,--,--,--,--,无 ,--,
    NSArray *showInfoArray = [plainString componentsSeparatedByString:@","];
    if ([paramsArray count] == 11 && showInfoArray.count >=16) {
        self.trainCode = [paramsArray objectAtIndex:0];
        self.lishi = [paramsArray objectAtIndex:1];
        self.startTime= [paramsArray objectAtIndex:2];
        self.trainNo= [paramsArray objectAtIndex:3];
        self.fromStationTelecode = [paramsArray objectAtIndex:4];
        self.toStationTelecode = [paramsArray objectAtIndex:5];
        self.arriveTime = [paramsArray objectAtIndex:6];
        self.fromStationName = [paramsArray objectAtIndex:7];
        self.toStationName = [paramsArray objectAtIndex:8];
        self.ypInfoDetail = [paramsArray objectAtIndex:9];
        self.mmStr = [paramsArray objectAtIndex:10];
        
        //商务座,特等座,一等座，二等座，高级软卧,软卧,硬卧,软座，硬座，无座,其他
        // 5     6     7     8      9     10  11  12   13  14   15
        self.seatsNumArray = [NSMutableArray array];
        for (int i = 5; i< 16; i++) {
            NSString* seatNum = [showInfoArray objectAtIndex:i];
            if ([seatNum hasPrefix:@"--"]) {
                [self.seatsNumArray addObject:[NSNull null]];
            }else if([seatNum hasPrefix:@"无"]){
                [self.seatsNumArray addObject:[NSNumber numberWithInteger:0]];
            }else if([seatNum hasPrefix:@"有"]){
                [self.seatsNumArray addObject:[NSNumber numberWithInteger:999]];
            }
            else{
                [self.seatsNumArray addObject:[NSNumber numberWithInteger:[seatNum integerValue]]];
            }
        }
        _ticketTypeArray = [NSArray arrayWithObjects:@"商务座",@"特等座",@"一等座",@"二等座",@"高级软卧",@"软卧",@"硬卧",@"软座",@"硬座" ,@"无座",@"其他",nil];
    }
    return self;
}

-(NSString*)ticketInfo
{
    NSMutableString *ticketInfo = [[NSMutableString alloc]init];
    for (int i =0; i< self.seatsNumArray.count; i++) {
        NSNumber *number = [self.seatsNumArray objectAtIndex:i];
        if ((id)number == [NSNull null]) {
            continue;
        }
        NSInteger seatNum = [number integerValue];
        if (seatNum == 999) {
            [ticketInfo appendFormat:@"%@(有)",[_ticketTypeArray objectAtIndex:i]];
        }else if(seatNum >0){
            [ticketInfo appendFormat:@"%@(%d)",[_ticketTypeArray objectAtIndex:i],seatNum];
        }
    }
    return [NSString stringWithString:ticketInfo];
}

@end
