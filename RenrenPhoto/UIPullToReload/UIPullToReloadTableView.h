//
//  UIPullToReloadTableView.h
//  NeteaseLottery
//
//  Created by xuguoxing on 12-6-8.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPullToReloadHeaderView.h"
#import "MessageInterceptor.h"
@interface UIPullToReloadTableView : UITableView
{
    MessageInterceptor *delegate_interceptor;
    UIPullToReloadHeaderView *pullToReloadHeaderView;
}
@property (nonatomic,strong) UIPullToReloadHeaderView *pullToReloadHeaderView;

-(void) pullDownToReloadActionFinished;
-(void) autoPullDownToRefresh;

@end
