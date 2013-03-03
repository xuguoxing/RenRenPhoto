//
//  NSDictionary+Additions.m
//  RenrenPhoto
//
//  Created by  on 12-9-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "NSDictionary+Additions.h"
#import "NSString+Additions.h"

@implementation NSDictionary (Additions)

-(NSString*)urlParamsEncodeString
{
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in self) {
        
        NSObject *value = [self valueForKey:key];
        if([value isKindOfClass:[NSString class]])
            [string appendFormat:@"%@=%@&", [key urlEncodedString], [((NSString*)value) urlEncodedString]];
        else
            [string appendFormat:@"%@=%@&", [key urlEncodedString], value];
    }
    
    if([string length] > 0)
        [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
    
    return string;          
}


@end
