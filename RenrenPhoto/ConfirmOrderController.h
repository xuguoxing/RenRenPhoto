//
//  ConfirmOrderController.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-30.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainTicketInfo.h"
@interface ConfirmOrderController : UITableViewController

//@property (nonatomic) NSDictionary *queryParams;
//@property (nonatomic) TrainTicketInfo *trainTicketInfo;
@property (nonatomic) NSString *leftTicket;
@property (nonatomic) NSDictionary *seatTypeNameDic;
@property (nonatomic) NSMutableArray *seatTypeNumArray;
//@property (nonatomic) NSMutableArray *passengersArray;
@end
