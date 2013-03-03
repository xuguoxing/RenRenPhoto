//
//  QueryViewController.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-21.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationSelectController.h"
#import "DateSelectController.h"
#import "TrainNoSelectController.h"
#import "TrainSession.h"
@interface QueryViewController : UIViewController<StationSelectDelegate,UITableViewDataSource,UITableViewDelegate,DateSelectDelegate,TrainNoSelectDelegate>
{
    UITableView *_tableView;
    
    //NSString *fromStationTelecode;
    //NSString *fromStationTelecodeName;
    
    //NSString *toStationTelecode;
    //NSString *toStationTelecodeName;
    
    //NSString *startDate;
    //NSString *startDateWeek;
    //UITextField *startDateField;
        
    //NSString *startTime;
    
    /*NSString *trainNo;
    NSString *trainNoDesc;
    UITextField *trainNoField;
    
    NSString *trainClass;    
    NSString *trainPassType;
    
    NSString *seatTypeNum;
    NSString *includeStudent;   */ 
}
@property (nonatomic) NSMutableDictionary *queryParams;
@property (nonatomic) NSMutableArray *queryTrainsArray;

@end
