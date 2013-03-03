//
//  MessageInterceptor.h
//  NeteaseLottery
//
//  Created by  on 12-8-2.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInterceptor : NSObject
{
    __unsafe_unretained id receiver;
    __unsafe_unretained id middleMan;
}
@property (nonatomic, assign) id receiver;
@property (nonatomic, assign) id middleMan;
@end
