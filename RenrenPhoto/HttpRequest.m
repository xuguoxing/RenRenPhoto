//
//  HttpRequest.m
//  RenrenPhoto
//
//  Created by  on 12-9-5.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "HttpRequest.h"
#import "NSDictionary+Additions.h"

static const NSTimeInterval kTimeoutInterval = 60.0;
static NSString* kStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3";

@implementation HttpRequest
@synthesize url = _url;
@synthesize httpMethod = _httpMethod;
@synthesize params = _params;
@synthesize completionBlock;
@synthesize failedBlock;

+(HttpRequest *)requestWithURL:(NSString *)url httpMethod:(NSString *)httpMethod params:(NSDictionary *)params
{
    HttpRequest *request = [[HttpRequest alloc]init];
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    return request;
}
                 
-(NSString*)serializeURL
{
    if ([_httpMethod isEqualToString:@"GET"]) {
        return [NSString stringWithFormat:@"%@?%@",_url,[_params urlParamsEncodeString]];
    }
    return _url;
}

-(BOOL)isMultipartPost
{
    if (![_httpMethod isEqualToString:@"POST"]) {
        return NO;
    }
    for (id obj in [_params allValues]) {
        if ([obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    return NO;
}

-(NSData*)multiPartPostBody
{
    NSMutableData *body = [NSMutableData data];
    NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kStringBoundary];
    NSString *bodySuffixString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kStringBoundary];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    for (id key in [_params keyEnumerator]) 
    {
        if (([[_params valueForKey:key] isKindOfClass:[UIImage class]]) || ([[_params valueForKey:key] isKindOfClass:[NSData class]]))
        {
            [dataDictionary setObject:[_params valueForKey:key] forKey:key];
            continue;
        }
        NSString *appendString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, [_params valueForKey:key]];
        [body appendData:[appendString dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dataDictionary count] > 0) 
    {
        for (id key in dataDictionary) 
        {
            NSObject *dataParam = [dataDictionary valueForKey:key];
            
            if ([dataParam isKindOfClass:[UIImage class]]) 
            {
                //take care image type jpg/png/bmp...
                NSData* imageData = UIImagePNGRepresentation((UIImage *)dataParam);
                NSString *appendString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.png\"\r\n", key];
                [body appendData:[appendString dataUsingEncoding:NSUTF8StringEncoding]];
                
                appendString = @"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n";
                [body appendData:[appendString dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
            } 
            else if ([dataParam isKindOfClass:[NSData class]]) 
            {
                NSString *appendString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
                [body appendData:[appendString dataUsingEncoding:NSUTF8StringEncoding]];
                
                appendString = @"Content-Type: content/unknown\r\nContent-Transfer-Encoding: binary\r\n\r\n";
                [body appendData:[appendString dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:(NSData*)dataParam];
            }
            [body appendData:[bodySuffixString dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return body;
}

-(void)connect
{
    NSLog(@"url:%@",self.url);
    NSLog(@"method:%@",self.httpMethod);
    NSLog(@"params:%@",self.params);
    NSString *urlString = [self serializeURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeoutInterval];
    [urlRequest setHTTPMethod:self.httpMethod];
    if ([_httpMethod isEqualToString:@"POST"]) {
        if ([self isMultipartPost]) {
            NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
            [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
            [urlRequest setHTTPBody:[self multiPartPostBody]];
            
        }else {
            NSMutableData *postBody = [NSMutableData data];
            [postBody appendData:[[_params urlParamsEncodeString] dataUsingEncoding:NSUTF8StringEncoding]];
            [urlRequest setHTTPBody:postBody];
        }
    }
    _connection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
}

-(void)disconnect
{
    [_connection cancel];
    _connection = nil;
}

-(void)dealloc
{
    [self disconnect];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponce = (NSHTTPURLResponse*)response;
    NSLog(@"receive HttpStatusCode:%d",httpResponce.statusCode);
    
    _responceData = [[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responceData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (completionBlock) {
        completionBlock(_responceData);
    }

    [_connection cancel];
    _connection = nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (failedBlock) {
        failedBlock(error);        
    }
    [_connection cancel];
    _connection = nil;
}
@end
