//
//  Renren.h
//  WeiboPhotos
//
//  Created by  on 12-8-31.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthController.h"
#import "UserInfo.h"
#import "FriendInfo.h"
#import "AlbumInfo.h"
#import "PhotoInfo.h"
#import "PhotoComment.h"
#import "PhotoFeed.h"

#define kRenRenAuthBaseURL            @"http://graph.renren.com/oauth/authorize"
#define kRenRenRedirectUri           @"http://widget.renren.com/callback.html"
#define kRenRenSessionKeyURL        @"http://graph.renren.com/renren_api/session_key"
#define kRenRenRestServerURL      @"http://api.renren.com/restserver.do"


//#define kRenRenAppKey     @"249323a3336b4b359ed3be8229c82168"
//#define kRenrenAppSecret          @"ab15b20c6d37442fab2d2f594415bdd0"


#define kRenRenAppKey     @"dc6c3606f700426db54d0dfb5cd81288"
#define kRenrenAppSecret          @"31481824d39943b7bf756aa384a7d37d"
@interface Renren : NSObject
{
    NSString *_accessToken;
    NSDate   *_expirationDate;
    
    NSString *_sessionKey;
    NSString *_sessionSecret;
    NSString *_uid;
    
    OAuthController *_controller;
}

@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSDate *expirationDate;
@property (nonatomic) NSString *sessionKey;
@property (nonatomic) NSString *sessionSecret;
@property (nonatomic) NSString *uid;
@property (nonatomic) OAuthController *controller;

@property (nonatomic) UserInfo *userInfo;
@property (nonatomic) NSMutableArray *friendsArray;

+ (Renren *)sharedRenren;
+(NSArray*)permissionArray;
-(BOOL)isSessionValid;
-(void)saveUserSessionInfo;
-(void)delUserSessionInfo;

-(void)logout;

-(UserInfo*)getUserInfoById:(NSString*)uid;
-(void)saveUserInfo:(UserInfo*)userInfo;
-(void)saveUserInfos:(NSArray*)userInfos;
-(void)saveFriendsToUserDic;

-(NSMutableArray*)getUserAlbumsById:(NSString*)uid;
-(void)saveUserAlbums:(NSMutableArray*)albums forId:(NSString*)uid;

-(NSDictionary*)authorizationParams;

//-(void)authorizationWithPermission:(NSArray*)permissions;
//认证
-(void)authorizationWithPermission:(NSArray*)permissions withCompletionBlock: (void(^)(BOOL success))completion;

-(void)getSessionKeyWithCompletionBlock:(void(^)(BOOL success))completion;

//根据uid获取用户信息
-(void) getUserInfo:(NSString*) uid withCompletionBlock:(void(^)(UserInfo *userInfo))completion failedBlock:(void(^)(NSError *error))failed;

-(void) getUserInfos:(NSArray*)uids WithCompletion:(void(^)(NSArray *userInfos))completion failed:(void(^)(NSError *error))failed;

//好友ID列表
-(void)getFriendIdsWithCompletion:(void(^)(NSArray *friendsArray))completion failed:(void(^)(NSError *error))failed;

//好友信息列表
-(void) getFriendsInfoWithCompletionBlock:(void(^)(NSArray *friendsArray))completion withFailedBlock:(void(^)(NSError *error))failed;

//用户相册列表
-(void) getUserAlbums:(NSString*) uid withCompletionBlock:(void(^)(NSArray *albumsArray))completion failedBlock:(void(^)(NSError *error))failed;

//用户相册照片列表
-(void) getPhotosUser:(NSString*) uid album:(NSString*)aid withCompletionBlock:(void(^)(NSArray *photosArray))completion failedBlock:(void(^)(NSError *error))failed;

//用户照片评论列表
-(void) getPhotoCommentsUser:(NSString*) uid pid:(NSString*)pid withCompletionBlock:(void(^)(NSArray *photosArray))completion failedBlock:(void(^)(NSError *error))failed;

-(void)getPhotoFeedsWithPage:(NSInteger)page completion:(void(^)(NSArray *feedsArray))completion failed:(void(^)(NSError *error))failed;
@end
