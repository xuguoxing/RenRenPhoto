//
//  UIApplication+LogStackTrace.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-8.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "UIApplication+LogStackTrace.h"

@implementation UIApplication (LogStackTrace)

//http://stackoverflow.com/questions/1373858/easy-way-to-print-current-stack-trace-of-an-app
+(void)logStackTrace{
    @try{
        [[NSException exceptionWithName:@"StackTrace" reason:@"Testing" userInfo:nil] raise];
    }@catch(NSException *e){
        NSLog(@"%@",[e callStackSymbols]);
    }
}
@end
