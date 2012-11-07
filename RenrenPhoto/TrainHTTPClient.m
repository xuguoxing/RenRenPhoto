//
//  TrainHTTPClient.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "TrainHTTPClient.h"

@implementation TrainHTTPClient


+(TrainHTTPClient*)sharedClient
{
    static TrainHTTPClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TrainHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://dynamic.12306.cn/"]];
    });
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        
    }
    return self;
}

- (AFHTTPRequestOperation *)HTTPRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
    AFHTTPRequestOperation *httpRequest = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [httpRequest setHttpsAuth];
    return httpRequest;    
}
@end
