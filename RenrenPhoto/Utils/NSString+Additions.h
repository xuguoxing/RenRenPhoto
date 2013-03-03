//
//  NSString+Additions.h
//  RenrenPhoto
//
//  Created by  on 12-9-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)
- (NSString *) md5;
+ (NSString*) uniqueString;
- (NSString*) urlEncodedString;
- (NSString*) urlDecodedString;
-(NSMutableDictionary*)urlParamsDecodeDictionary;
@end
