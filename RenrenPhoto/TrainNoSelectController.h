//
//  TrainNoSelectController.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-23.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrainNoSelectDelegate <NSObject>

-(void)selectTrainNo:(NSString*)trainNoString desc:(NSString*)descString;

@end

@interface TrainNoSelectController : UITableViewController

@property (nonatomic) NSArray *trainNoArray;
@property (nonatomic,weak) id<TrainNoSelectDelegate> delegate;
@end
