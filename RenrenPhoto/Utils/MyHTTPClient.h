//
//  MyHTTPClient.h
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-19.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"

@interface MyHTTPClient : AFHTTPClient
+(MyHTTPClient*)sharedClient;
- (AFHTTPRequestOperation *)HTTPRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;
@end
