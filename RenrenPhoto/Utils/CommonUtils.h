//
//  CommonUtils.h
//  TrainTicket
//
//  Created by xuguoxing on 12-12-8.
//  Copyright (c) 2012年 xuguoxing. All rights reserved.
//

#import <Foundation/Foundation.h>

void alertMessage(NSString *title ,NSString *message);
void alertView(NSString *title);

UITextField *createPlainTextFiled(CGRect frame);

BOOL openURL(NSURL *url);

BOOL openURLString(NSString *urlString);

UILabel *labelForNavTitle(NSString *title);

void alertMessage(NSString *title ,NSString *message);