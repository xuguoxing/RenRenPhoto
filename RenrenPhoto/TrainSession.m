//
//  TrainSession.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "TrainSession.h"
#import "StationInfo.h"
@implementation TrainSession
{
    NSMutableArray *_allStationsArray;
    NSMutableArray *_favStationSArray;
}


+(TrainSession*)sharedSession
{
    static TrainSession *sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSession = [[TrainSession alloc]init];
    });
    return sharedSession;
}

-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

//请求验证码
-(void)refreshVerifyCodeImageType:(NSInteger)type withCompletion:(void (^)(UIImage *, NSError *))completion
{
    /*0 登陆验证码  https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=sjrand
      1 提交订单验证码 https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=randp */
    NSString *url;
    if (type == 0)
    {
        url = @"otsweb/passCodeAction.do?rand=sjrand";
    }else if(type == 1)
    {
        url = @"otsweb/passCodeAction.do?rand=randp";
    }
    
    if (!url) {
        completion(nil,nil);
        return;
    }
    
    AFHTTPRequestOperation *verifyCodeRequst = [[TrainHTTPClient sharedClient] HTTPRequestWithMethod:@"GET" path:url parameters:nil];    
    [verifyCodeRequst setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        UIImage *image = [UIImage imageWithData:responseObject];
        if (image) {
            completion(image,nil);
        }else{
            NSLog(@"image error:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            completion(nil,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"randCode Error:%@",error);
        completion(nil,error);
    }];
    [verifyCodeRequst start];
}

//登录
-(void)loginWithCompletion:(void (^)(NSString *, NSError *))completion
{
    if (!self.userName || self.userName.length ==0) {
        NSError *error = [NSError errorWithDomain:@"用户名不能为空" code:0 userInfo:nil];
        completion(nil,error);
        return;
    }
    if (!self.passWord || self.passWord.length ==0) {
        NSError *error = [NSError errorWithDomain:@"密码不能为空" code:0 userInfo:nil];
        completion(nil,error);
        return;
    }
    if (!self.loginVerifyCode || self.loginVerifyCode.length ==0) {
        NSError *error = [NSError errorWithDomain:@"验证码不能为空" code:0 userInfo:nil];
        completion(nil,error);
        return;
    }
    
    NSString *loginAysnSuggestUrl = @"/otsweb/loginAction.do?method=loginAysnSuggest";
    AFHTTPRequestOperation *loginAysnSuggestRequest = [[TrainHTTPClient sharedClient]HTTPRequestWithMethod:@"POST" path:loginAysnSuggestUrl parameters:nil];

    __weak TrainSession *blockSelf = self;
    [loginAysnSuggestRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *error;
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (![object isKindOfClass:[NSDictionary class]]) {
            NSLog(@"object:%@ is not dictionary",object);
            return;
        }
        NSDictionary *dictionary = (NSDictionary*)object;
        NSString *randErrorValue = [dictionary objectForKey:@"randError"];
        if (randErrorValue && [randErrorValue isEqualToString:@"Y"]) {
            blockSelf.loginRandCode = [dictionary objectForKey:@"loginRand"];
            
               //@"266",@"loginRand", @"N",@"refundLogin",@"Y",@"refundFlag",@"xugx2007@gmail.com",@"loginUser.user_name",@"",@"nameErrorFocus",@"397321642",@"user.password",@"",@"passwordErrorFocus",@"XE8J",@"randCode",@"",@"randErrorFocus",nil];
            NSDictionary *loginParams = @{@"loginRand":blockSelf.loginRandCode,
            @"refundLogin":@"N",
            @"refundFlag":@"Y",
            @"loginUser.user_name":blockSelf.userName,
            @"nameErrorFocus":@"",
            @"user.password":blockSelf.passWord,
            @"passwordErrorFocus":@"",
            @"randCode":blockSelf.loginVerifyCode,
            @"randErrorFocus":@"",};
            
            AFHTTPRequestOperation *loginRequest = [[TrainHTTPClient sharedClient]HTTPRequestWithMethod:@"POST" path:@"otsweb/loginAction.do?method=login" parameters:loginParams];
            [loginRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
                NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([result rangeOfString:@"欢迎您"].length > 0) {
                    completion(@"OK",nil);
                }else{
                    NSLog(@"loginResult:%@",result);
                    completion(nil,nil);
                }
            } failure:^(AFHTTPRequestOperation *operation,NSError *error){
                NSLog(@"randCode Error:%@",error);
                completion(nil,error);
            }];
            [loginRequest start];
            
        }else{
            completion(nil,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"randCode Error:%@",error);
        completion(nil,error);
    }];
    [loginAysnSuggestRequest start];
}

//获取车站数据
-(NSArray*)getAllStationsWithCompletion:(void(^)(NSArray *stationsArray,NSError *error))completion;
{
    if (_allStationsArray && _allStationsArray.count >0)
    {
        return _allStationsArray;
    }
    if (!_allStationsArray) {
        _allStationsArray = [NSMutableArray array];
    }
    AFHTTPRequestOperation *allStationsRequest = [[TrainHTTPClient sharedClient] HTTPRequestWithMethod:@"GET" path:@"tsweb/js/common/station_name.js" parameters:nil];
    [allStationsRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        [_allStationsArray addObjectsFromArray:[self parseStationsData:responseObject]];
        completion(_allStationsArray,nil);

        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        completion(nil,error);
    }];
    return nil;
}

-(NSArray*)getFavStationsWithCompletion:(void(^)(NSArray *stationsArray,NSError *error))completion;
{
    if (_favStationSArray && _favStationSArray.count >0)
    {
        return _favStationSArray;
    }
    if (!_favStationSArray) {
        _favStationSArray = [NSMutableArray array];
    }
    AFHTTPRequestOperation *favStationsRequest = [[TrainHTTPClient sharedClient] HTTPRequestWithMethod:@"GET" path:@"otsweb/js/common/favorite_name.js" parameters:nil];
    [favStationsRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        [_favStationSArray addObjectsFromArray:[self parseStationsData:responseObject]];
        completion(_favStationSArray,nil);
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        completion(nil,error);
    }];
    return nil;
}

-(NSMutableArray*)parseStationsData:(NSData*)data
{
    NSMutableArray *stationsArray = [NSMutableArray array];    
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *stationStringArray = [string componentsSeparatedByString:@"@"];
    for (NSString *oneStationString in stationStringArray) {
        NSArray *oneStationArray = [oneStationString componentsSeparatedByString:@"|"];
        if (oneStationArray.count != 4) {
            continue;
        }
        StationInfo *station = [[StationInfo alloc]init];
        station.stationEnName = [oneStationArray objectAtIndex:0];
        station.stationCnName = [oneStationArray objectAtIndex:1];
        station.stationTelecode = [oneStationArray objectAtIndex:2];
        station.stationIndex = [oneStationArray objectAtIndex:3];
        [stationsArray addObject:station];
    }
    return stationsArray;
}

@end
