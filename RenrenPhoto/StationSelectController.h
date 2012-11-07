//
//  StationSelectController.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-21.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpView.h"

@protocol StationSelectDelegate <NSObject>

-(void)selectStation:(NSString*)stationCnName teleCode:(NSString*)stationTeleCode;

@end

@interface StationSelectController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDC;
    UITableView *_tableView;
    PopUpView *popView;
    
    NSMutableArray *alphaStationsArray;
    NSMutableArray *favStationsArray;
    NSMutableArray *showStationsArray;
    NSMutableArray *indexTitlesArray;
    
    __weak id<StationSelectDelegate> delegate;
}
@property (nonatomic,weak) id<StationSelectDelegate> delegate;
@end
