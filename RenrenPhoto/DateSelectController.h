//
//  DateSelectController.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-22.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateSelectDelegate <NSObject>

-(void) selectDate:(NSString*)dateString weekDay:(NSString*)weekString;

@end


@interface DateSelectController : UITableViewController
{
    __weak id<DateSelectDelegate> delegate;
}

@property (nonatomic,weak) id<DateSelectDelegate> delegate;

@end
