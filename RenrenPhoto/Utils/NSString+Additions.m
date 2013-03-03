//
//  NSString+Additions.m
//  RenrenPhoto
//
//  Created by  on 12-9-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];      
}

+ (NSString*) uniqueString
{
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);
	NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return uuidString;
}

- (NSString*) urlEncodedString {
    
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                          (__bridge CFStringRef) self, 
                                                                          nil,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "), 
                                                                          kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];    
    
    if(!encodedString)
        encodedString = @"";    
    
    return encodedString;
}

- (NSString*) urlDecodedString {
    
    CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, 
                                                                                          (__bridge CFStringRef) self, 
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    
    // We need to replace "+" with " " because the CF method above doesn't do it
    NSString *decodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) decodedCFString];    
    return (!decodedString) ? @"" : [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

-(NSMutableDictionary*)urlParamsDecodeDictionary
{
    NSArray *pairs =[self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *key = [kv objectAtIndex:0];
            NSString *value = [kv objectAtIndex:1];
            [params setObject:value forKey:key];
        }
    }
    return params;
}

@end
