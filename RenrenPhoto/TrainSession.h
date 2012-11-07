//
//  TrainSession.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainHTTPClient.h"
@interface TrainSession : NSObject

//登录
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *passWord;
@property (nonatomic) NSString *loginRandCode;
@property (nonatomic) NSString *loginVerifyCode;

//类型 0 登陆 1 提交订单
-(void)refreshVerifyCodeImageType:(NSInteger)type withCompletion:(void(^)(UIImage *image,NSError *err))completion;
-(void)loginWithCompletion:(void(^)(NSString* msg,NSError *error))completion;

//车站查询
-(NSArray*)getAllStationsWithCompletion:(void(^)(NSArray *stationsArray,NSError *error))completion;


+(TrainSession*)sharedSession;

@end
