//
//  TrainHTTPClient.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AFURLConnectionOperation+HTTPS.h"
@interface TrainHTTPClient : AFHTTPClient

+(TrainHTTPClient*)sharedClient;
- (AFHTTPRequestOperation *)HTTPRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;
@end
