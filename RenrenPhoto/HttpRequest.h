//
//  HttpRequest.h
//  RenrenPhoto
//
//  Created by  on 12-9-5.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSString *_url;
    NSString *_httpMethod;
    NSDictionary *_params;
    NSURLConnection *_connection;
    NSMutableData *_responceData;
    
    void(^completionBlock)(NSMutableData *data);
    void(^failedBlock)(NSError *error);
}

@property (nonatomic) NSString *url;
@property (nonatomic) NSString *httpMethod;
@property (nonatomic) NSDictionary *params;
@property (nonatomic,copy) void(^completionBlock)(NSMutableData *data);
@property (nonatomic,copy) void(^failedBlock)(NSError *error);


+(HttpRequest *)requestWithURL:(NSString *)url httpMethod:(NSString *)httpMethod params:(NSDictionary *)params;

-(void)connect;
-(void)disconnect;

@end
