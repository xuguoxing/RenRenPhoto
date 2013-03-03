//
//  MessageInterceptor.m
//  NeteaseLottery
//
//  Created by  on 12-8-2.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import "MessageInterceptor.h"

@implementation MessageInterceptor
@synthesize receiver;
@synthesize middleMan;

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([middleMan respondsToSelector:aSelector]) { return middleMan; }
    if ([receiver respondsToSelector:aSelector]) { return receiver; }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([middleMan respondsToSelector:aSelector]) { return YES; }
    if ([receiver respondsToSelector:aSelector]) { return YES; }
    return [super respondsToSelector:aSelector];
}
@end
