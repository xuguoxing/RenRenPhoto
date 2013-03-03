//
//  MyHTTPClient.m
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-19.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "MyHTTPClient.h"
@implementation MyHTTPClient
+(MyHTTPClient*)sharedClient
{
    static MyHTTPClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MyHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    });
    return _sharedClient;
}

- (AFHTTPRequestOperation *)HTTPRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
    AFHTTPRequestOperation *httpRequest = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    return httpRequest;
}
@end
