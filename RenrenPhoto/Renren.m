//
//  Renren.m
//  WeiboPhotos
//
//  Created by  on 12-8-31.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "Renren.h"
#import "OAuthController.h"
#import "HttpRequest.h"
#import "NSString+Additions.h"

@implementation Renren
@synthesize appId = _appId;
@synthesize accessToken = _accessToken;
@synthesize expirationDate= _expirationDate;
@synthesize sessionKey = _sessionKey;
@synthesize sessionSecret = _sessionSecret;
@synthesize uid = _uid;
@synthesize controller = _controller;
static Renren *sharedRenren = nil;

-(id)init
{
    if (self = [super init]) {
        //self.appId = kAPP_ID;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (nil != defaults){
            self.accessToken = [defaults objectForKey:@"access_Token"];
            self.expirationDate = [defaults objectForKey:@"expiration_Date"];
            self.sessionKey = [defaults objectForKey:@"session_Key"];
            self.sessionSecret = [defaults objectForKey:@"session_Secret"];
            self.uid = [defaults objectForKey:@"uid"];
        }    
    }
    return self;
}

+(Renren *)sharedRenren
{
    if (!sharedRenren) {
        sharedRenren = [[Renren alloc]init];
    }
    return sharedRenren;
}

+(NSArray*)permissionArray
{
    return [NSArray arrayWithObjects:@"read_user_blog",@"read_user_feed",@"read_user_photo",@"read_user_album",@"read_user_comment",@"photo_upload",@"create_album", nil];
}

#pragma mark -
#pragma mark private
-(NSDictionary*)baseParamsDictionary
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"JSON" forKey:@"format"];
    [params setObject:@"3.0" forKey:@"v"];
    [params setObject:@"1" forKey:@"xn_ss"];
    [params setObject:kRenRenAppKey forKey:@"api_key"];
    [params setObject:self.accessToken forKey:@"access_token"];
    [params setObject:self.sessionKey forKey:@"session_key"];    
    return params;
}

+ (NSString *)generateCallId{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

+ (NSString *)generateSig:(NSMutableDictionary *)params secretKey:(NSString *)secretKey{
    NSMutableString* joined = [NSMutableString string]; 
	NSArray* keys = [params.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (id obj in [keys objectEnumerator]) {
		id value = [params valueForKey:obj];
		if ([value isKindOfClass:[NSString class]]) {
			[joined appendString:obj];
			[joined appendString:@"="];
			[joined appendString:value];
		}
	}
	[joined appendString:secretKey];
	return [joined md5];
}

+(void)checkRenrenObject:(id)object error:(NSError**)error{
    if ([object isKindOfClass:[NSDictionary class]]) {
        __weak NSDictionary *dict = (NSDictionary*)object;
        if ([dict objectForKey:@"error_code"]) {
            NSInteger errorCode = [[dict objectForKey:@"error_code"]integerValue];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            if ([dict objectForKey:@"error_msg"]) {
                [userInfo setObject:[dict objectForKey:@"error_msg"] forKey:NSLocalizedDescriptionKey];
            }
            if ([dict objectForKey:@"request_args"]) {
                [userInfo setObject:[dict objectForKey:@"request_args"] forKey:@"request_args"];
            }
            *error = [NSError errorWithDomain:@"RenRenAPI" code:errorCode userInfo:[NSDictionary dictionaryWithDictionary:userInfo]];
        }
    }
    return;
}

#pragma mark -
#pragma mark 认证
-(BOOL)isSessionValid{
    return (self.uid != nil && self.accessToken != nil && self.sessionKey != nil && self.expirationDate != nil && NSOrderedDescending == [self.expirationDate compare:[NSDate date]]);
}

-(void)authorizationWithPermission:(NSArray*)permissions withCompletionBlock: (void(^)(BOOL success))completion
{
    if (![self isSessionValid]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:kRenRenAppKey forKey:@"client_id"];
        [params setValue:kRenRenRedirectUri forKey:@"redirect_uri"];
        [params setValue:@"token" forKey:@"response_type"];
        [params setValue:@"touch" forKey:@"display"];
        [params setValue:[Renren generateCallId] forKey:@"call_id"];
        if (permissions) {
            NSString *permissionScope = [permissions componentsJoinedByString:@","];
            [params setValue:permissionScope forKey:@"scope"];
        }
        _controller = [[OAuthController alloc]init];
        _controller.serverUrl = kRenRenAuthBaseURL;
        _controller.type = kOAuthTypeAccessToken;
        _controller.params = params;
        
        __weak OAuthController *blockController = _controller;
        __weak Renren *blockSelf = self;
        _controller.completionBlock = ^(NSDictionary *params){
            blockSelf.accessToken = [[params objectForKey:@"access_token"] urlDecodedString];
            NSString *expTime = [[params objectForKey:@"expires_in"] urlDecodedString];
            blockSelf.expirationDate = [NSDate dateWithTimeIntervalSinceNow:[expTime intValue]];
            [blockController close];
            blockSelf.controller = nil;
            [blockSelf getSessionKeyWithCompletionBlock:completion];
            /*if (completion) {
                completion(YES);  
            }*/

        };
        _controller.failedBlock = ^(NSDictionary *params){
            [blockController close];
            blockSelf.controller = nil;
            if (completion) {
                completion(NO);
            }
        };
        [_controller show];
        
    }
}



-(void)getSessionKeyWithCompletionBlock:(void(^)(BOOL success))completion
{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   _accessToken, @"oauth_token",
								   nil];  
     __strong HttpRequest *request = [HttpRequest requestWithURL:kRenRenSessionKeyURL httpMethod:@"GET" params:params];
    request.completionBlock = ^(NSData *data){
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (object && error == nil) {
            NSDictionary *result = (NSDictionary*)object;
            self.sessionKey = [[result objectForKey:@"renren_token"]objectForKey:@"session_key"];
            self.sessionSecret = [[result objectForKey:@"renren_token"]objectForKey:@"session_secret"];
            NSNumber *uid = [[result objectForKey:@"user"]objectForKey:@"id"];
            self.uid = [NSString stringWithFormat:@"%@",uid];
            [self saveUserSessionInfo];
            if (completion) {
                completion(YES);
            }
        }else {
            if (completion) {
                completion(NO);
            }
        }   
    };
    [request connect];
    
}


/**
 * 保存用户经oauth 2.0登录后的信息,到UserDefaults中。
 */
-(void)saveUserSessionInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
    if (self.accessToken) {
        [defaults setObject:self.accessToken forKey:@"access_Token"];
    }
	if (self.expirationDate) {
		[defaults setObject:self.expirationDate forKey:@"expiration_Date"];
	}	
    if (self.sessionKey) {
        [defaults setObject:self.sessionKey forKey:@"session_Key"];
    }
    if (self.sessionSecret) {
        [defaults setObject:self.sessionSecret forKey:@"session_Secret"];
    }
    if (self.uid) {
        [defaults setObject:self.uid forKey:@"uid"];
    }
    [defaults synchronize];	
}

/**
 * 删除UserDefaults中保存的用户oauth 2.0信息 
 */
-(void)delUserSessionInfo{
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"access_Token"];
	[defaults removeObjectForKey:@"expiration_Date"];
    [defaults removeObjectForKey:@"session_Key"];
    [defaults removeObjectForKey:@"session_Secret"];
    [defaults removeObjectForKey:@"uid"];
	[defaults synchronize];
}

#pragma mark -
#pragma mark REST API

//根据UID获取用户信息 http://wiki.dev.renren.com/wiki/Users.getInfo

-(void) getUserInfo:(NSString*) uid withCompletionBlock:(void(^)(UserInfo *userInfo))completion failedBlock:(void(^)(NSError *error))failed
{
    if (self.isSessionValid) {
        return [self _getUserInfo:uid withCompletionBlock:completion failedBlock:failed];
    }else {
        [self authorizationWithPermission:[Renren permissionArray] withCompletionBlock:^(BOOL success){
            if (success) {
                [self _getUserInfo:uid withCompletionBlock:completion failedBlock:failed];
            }else {
                if (failed) {
                    failed(nil);
                }
            }
        }];
    }
}

-(void) _getUserInfo:(NSString*) uid withCompletionBlock:(void(^)(UserInfo *userInfo))completion failedBlock:(void(^)(NSError *error))failed
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[self baseParamsDictionary]];
    [params setObject:@"users.getInfo" forKey:@"method"];
    [params setObject:uid forKey:@"uids"];
    [params setObject:[Renren generateSig:params secretKey:_sessionSecret] forKey:@"sig"];
    
    __strong HttpRequest *request = [HttpRequest requestWithURL:kRenRenRestServerURL httpMethod:@"POST" params:params];
    request.completionBlock = ^(NSData *data){
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (object && error == nil) {
            [Renren checkRenrenObject:object error:&error];
        }
        
        if (object && error == nil && [(NSArray*)object count] == 1) {
            if (completion) {
                NSDictionary *userInfo = [(NSArray*)object objectAtIndex:0];
                UserInfo *user = [[UserInfo alloc]initWithDictionary:userInfo];
                completion(user);
            }
        }else {
            if (failed) {
                failed(error);
            }
        }
    };
    request.failedBlock = ^(NSError *error){
        if (failed) {
            failed(error);
        }
    };
    [request connect];
}


//好友ID列表 http://wiki.dev.renren.com/wiki/Friends.get

-(void) getFriendsIdWithCompletionBlock:(void(^)(NSArray *friendsArray))completion withFailedBlock:(void(^)(NSError *error))failed
{
    if (self.isSessionValid) {
        return [self _getFriendsIdWithCompletionBlock:completion withFailedBlock:failed];
    }else {
        [self authorizationWithPermission:[Renren permissionArray] withCompletionBlock:^(BOOL success){
            if (success) {
                [self performSelector:@selector(_getFriendsIdWithCompletionBlock:withFailedBlock:) withObject:completion withObject:failed];
            }else {
                if (failed) {
                    failed(nil);
                }
            }
        }];
    }
}

-(void) _getFriendsIdWithCompletionBlock:(void(^)(NSArray *friendsArray))completion withFailedBlock:(void(^)(NSError *error))failed
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[self baseParamsDictionary]];
    [params setObject:@"friends.get" forKey:@"method"];
    [params setObject:[Renren generateSig:params secretKey:_sessionSecret] forKey:@"sig"];
    
    __strong HttpRequest *request = [HttpRequest requestWithURL:kRenRenRestServerURL httpMethod:@"POST" params:params];
    request.completionBlock = ^(NSData *data){
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (object && error == nil) {
            [Renren checkRenrenObject:object error:&error];
        }
        
        if (object && error == nil) {
            if (completion) {
                completion((NSArray*)object);
            }
        }else {
            if (failed) {
                failed(error);
            }
        }
    };
    request.failedBlock = ^(NSError *error){
        if (failed) {
            failed(error);
        }
    };
    [request connect];
}

//好友列表 http://wiki.dev.renren.com/wiki/Friends.getFriends

-(void) getFriendsInfoWithCompletionBlock:(void(^)(NSArray *friendsArray))completion withFailedBlock:(void(^)(NSError *error))failed
{
    if (self.isSessionValid) {
        return [self _getFriendsInfoWithCompletionBlock:completion withFailedBlock:failed];
    }else {
        [self authorizationWithPermission:[Renren permissionArray] withCompletionBlock:^(BOOL success){
            if (success) {
                [self performSelector:@selector(_getFriendsInfoWithCompletionBlock:withFailedBlock:) withObject:completion withObject:failed];
            }else {
                if (failed) {
                    failed(nil);
                }
            }
        }];
    }
}

-(void) _getFriendsInfoWithCompletionBlock:(void(^)(NSArray *friendsArray))completion withFailedBlock:(void(^)(NSError *error))failed
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[self baseParamsDictionary]];
    [params setObject:@"friends.getFriends" forKey:@"method"];
    [params setObject:[Renren generateSig:params secretKey:_sessionSecret] forKey:@"sig"];
    
    __strong HttpRequest *request = [HttpRequest requestWithURL:kRenRenRestServerURL httpMethod:@"POST" params:params];
    request.completionBlock = ^(NSData *data){
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (object && error == nil) {
            [Renren checkRenrenObject:object error:&error];
        }
        if (object && error == nil) {
            if (completion) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *friend in (NSArray*)object) {
                    FriendInfo *info = [[FriendInfo alloc]initWithDictionary:friend];
                    [array addObject:info];
                }
                completion((NSArray*)array);
            }
        }else {
            if (failed) {
                failed(error);
            }
        }
    };
    request.failedBlock = ^(NSError *error){
        if (failed) {
            failed(error);
        }
    };
    [request connect];
    
    
}


//相册列表 http://wiki.dev.renren.com/wiki/Photos.getAlbums

-(void) getUserAlbums:(NSString*) uid withCompletionBlock:(void(^)(NSArray *albumsArray))completion failedBlock:(void(^)(NSError *error))failed
{
    if (self.isSessionValid) {
        return [self _getUserAlbums:uid withCompletionBlock:completion failedBlock:failed];
    }else {
        [self authorizationWithPermission:[Renren permissionArray] withCompletionBlock:^(BOOL success){
            if (success) {
                [self _getUserAlbums:uid withCompletionBlock:completion failedBlock:failed];
            }else {
                if (failed) {
                    failed(nil);
                }
            }
        }];
    }
}

-(void) _getUserAlbums:(NSString*) uid withCompletionBlock:(void(^)(NSArray *albumsArray))completion failedBlock:(void(^)(NSError *error))failed
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[self baseParamsDictionary]];
    [params setObject:@"photos.getAlbums" forKey:@"method"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:[Renren generateSig:params secretKey:_sessionSecret] forKey:@"sig"];
    
    __strong HttpRequest *request = [HttpRequest requestWithURL:kRenRenRestServerURL httpMethod:@"POST" params:params];
    request.completionBlock = ^(NSData *data){
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (object && error == nil) {
            [Renren checkRenrenObject:object error:&error];
        }
        
        if (object && error == nil) {
            if (completion) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *albumInfo in (NSArray*)object) {
                    AlbumInfo *album = [[AlbumInfo alloc]initWithDictionary:albumInfo];
                    [array addObject:album];
                }
                completion((NSArray*)array);
            }
        }else {
            if (failed) {
                failed(error);
            }
        }
    };
    request.failedBlock = ^(NSError *error){
        if (failed) {
            failed(error);
        }
    };
    [request connect];
}


//相册内照片列表 http://wiki.dev.renren.com/wiki/Photos.get

-(void) getPhotosUser:(NSString*) uid album:(NSString*)aid withCompletionBlock:(void(^)(NSArray *photosArray))completion failedBlock:(void(^)(NSError *error))failed{
    if (self.isSessionValid) {
        return [self _getPhotosUser:uid album:aid withCompletionBlock:completion failedBlock:failed];
    }else {
        [self authorizationWithPermission:[Renren permissionArray] withCompletionBlock:^(BOOL success){
            if (success) {
                [self _getPhotosUser:uid album:aid withCompletionBlock:completion failedBlock:failed];
            }else {
                if (failed) {
                    failed(nil);
                }
            }
        }];
    }
}

-(void) _getPhotosUser:(NSString*) uid album:(NSString*)aid withCompletionBlock:(void(^)(NSArray *photosArray))completion failedBlock:(void(^)(NSError *error))failed
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[self baseParamsDictionary]];
    [params setObject:@"photos.get" forKey:@"method"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:aid forKey:@"aid"];
    [params setObject:@"50" forKey:@"count"];
    [params setObject:[Renren generateSig:params secretKey:_sessionSecret] forKey:@"sig"];
    
    __strong HttpRequest *request = [HttpRequest requestWithURL:kRenRenRestServerURL httpMethod:@"POST" params:params];
    request.completionBlock = ^(NSData *data){
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (object && error == nil) {
            [Renren checkRenrenObject:object error:&error];
        }
        
        if (object && error == nil) {
            if (completion) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *photoInfo in (NSArray*)object) {
                    PhotoInfo *photo = [[PhotoInfo alloc]initWithDictionary:photoInfo];
                    [array addObject:photo];
                }
                completion((NSArray*)array);
            }
        }else {
            if (failed) {
                failed(error);
            }
        }
    };
    request.failedBlock = ^(NSError *error){
        if (failed) {
            failed(error);
        }
    };
    [request connect];
    
    
}



//照片评论列表  http://wiki.dev.renren.com/wiki/Photos.getComments

-(void) getPhotoCommentsUser:(NSString*) uid pid:(NSString*)pid withCompletionBlock:(void(^)(NSArray *photosArray))completion failedBlock:(void(^)(NSError *error))failed{
    if (self.isSessionValid) {
        return [self _getPhotoCommentsUser:uid pid:pid withCompletionBlock:completion failedBlock:failed];
    }else {
        [self authorizationWithPermission:[Renren permissionArray] withCompletionBlock:^(BOOL success){
            if (success) {
                [self _getPhotoCommentsUser:uid pid:pid withCompletionBlock:completion failedBlock:failed];
            }else {
                if (failed) {
                    failed(nil);
                }
            }
        }];
    }
}

-(void) _getPhotoCommentsUser:(NSString*) uid pid:(NSString*)pid withCompletionBlock:(void(^)(NSArray *commentsArray))completion failedBlock:(void(^)(NSError *error))failed
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[self baseParamsDictionary]];
    [params setObject:@"photos.getComments" forKey:@"method"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:pid forKey:@"pid"];
    [params setObject:@"100" forKey:@"count"];
    [params setObject:[Renren generateSig:params secretKey:_sessionSecret] forKey:@"sig"];
    
    __strong HttpRequest *request = [HttpRequest requestWithURL:kRenRenRestServerURL httpMethod:@"POST" params:params];
    request.completionBlock = ^(NSData *data){
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (object && error == nil) {
            [Renren checkRenrenObject:object error:&error];
        }
        
        if (object && error == nil) {
            if (completion) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *commentInfo in (NSArray*)object) {
                    PhotoComment *comment = [[PhotoComment alloc]initWithDictionary:commentInfo];
                    [array addObject:comment];
                }
                completion((NSArray*)array);
            }
        }else {
            if (failed) {
                failed(error);
            }
        }
    };
    request.failedBlock = ^(NSError *error){
        if (failed) {
            failed(error);
        }
    };
    [request connect];
    
    
}

@end
