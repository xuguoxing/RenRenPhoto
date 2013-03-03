//
//  TrainSession.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-4.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "TrainSession.h"
#import "StationInfo.h"
#import "DateUtils.h"
#import "RegexKitLite.h"
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
        _usualPassengersArray = [NSMutableArray array];
        _startDate = getDateString([NSDate date]);
        _startDateWeek = getWeekString([NSDate date]);
        
        _startTime = @"00:00--24:00";
        _trainClass = @"QB#D#Z#T#K#QT#"; //全部 D字头(动车) Z字头 T字头 K字头 其他
        _trainPassType = @"QB";          //全部 始发  过路
        _seatTypeNum = @"";
        _includeStudent = @"00";
        
        //    商务座,特等座,一等座，二等座，高级软卧,软卧,硬卧,软座，硬座，无座,其他
        
        //表示：  9    P     M    O       6      4   3    2    1   1(3000+座位)

        _seatTypeArray = [NSMutableArray array];        
        [_seatTypeArray addObject:[[SeatType alloc]initWithCode:@"9" name:@"商务座"]];
        [_seatTypeArray addObject:[[SeatType alloc]initWithCode:@"P" name:@"特等座"]];
        [_seatTypeArray addObject:[[SeatType alloc]initWithCode:@"M" name:@"一等座"]];
        [_seatTypeArray addObject:[[SeatType alloc]initWithCode:@"O" name:@"二等座"]];
        [_seatTypeArray addObject:[[SeatType alloc]initWithCode:@"6" name:@"高级软卧"]];
        [_seatTypeArray addObject:[[SeatType alloc]initWithCode:@"4" name:@"软卧"]];
        [_seatTypeArray addObject:[[SeatType alloc]initWithCode:@"3" name:@"硬卧"]];
        [_seatTypeArray addObject:[[SeatType alloc]initWithCode:@"2" name:@"软座"]];
        [_seatTypeArray addObject:[[SeatType alloc]initWithCode:@"1" name:@"硬座"]];
        [_seatTypeArray addObject:[[SeatType alloc]initWithCode:@"1" name:@"无座"]];
        
        //0 随机, 3 上铺, 2 中铺 , 1 下铺
        _seatDetailTypeArray = [NSMutableArray array];
        [_seatDetailTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"0" value:@"随机"]];
        [_seatDetailTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"3" value:@"上铺"]];
        [_seatDetailTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"2" value:@"中铺"]];        
        [_seatDetailTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"1" value:@"下铺"]];
                
        // 1 成人票， 2 儿童票, 3 学生票, 4 残军票
        _ticketTypeArray = [NSMutableArray array];
        [_ticketTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"1" value:@"成人票"]];
        [_ticketTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"2" value:@"儿童票"]];
        [_ticketTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"3" value:@"学生票"]];
        [_ticketTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"4" value:@"残军票"]];
        

        // 1 二代身份证, 2 一代身份证, C 港澳通行证, G 台湾通行证, B 护照
        _cardTypeArray = [NSMutableArray array];
        [_cardTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"1" value:@"二代身份证"]];
        [_cardTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"2" value:@"一代身份证"]];
        [_cardTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"C" value:@"港澳通行证"]];
        [_cardTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"G" value:@"台湾通行证"]];
        [_cardTypeArray addObject:[[CodeValuePair alloc]initWithCode:@"B" value:@"护照"]];
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
-(void)loginWithCompletion:(void (^)(BOOL success, NSError *))completion
{
    if (!self.userName || self.userName.length ==0) {
        NSError *error = [NSError errorWithDomain:@"用户名不能为空" code:0 userInfo:nil];
        completion(NO,error);
        return;
    }
    if (!self.passWord || self.passWord.length ==0) {
        NSError *error = [NSError errorWithDomain:@"密码不能为空" code:0 userInfo:nil];
        completion(NO,error);
        return;
    }
    if (!self.loginVerifyCode || self.loginVerifyCode.length ==0) {
        NSError *error = [NSError errorWithDomain:@"验证码不能为空" code:0 userInfo:nil];
        completion(NO,error);
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
                    [self getUsualPassengersWithCompletion:^(NSMutableArray *usualPassengers, NSError *error) {
                        //completion(@"OK",nil);
                        completion(YES,nil);
                    }];
                    //completion(@"OK",nil);
                }else{
                    NSLog(@"loginResult:%@",result);
                    completion(NO,nil);
                }
            } failure:^(AFHTTPRequestOperation *operation,NSError *error){
                NSLog(@"randCode Error:%@",error);
                completion(NO,error);
            }];
            [loginRequest start];
            
        }else{
            completion(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"randCode Error:%@",error);
        completion(NO,error);
    }];
    [loginAysnSuggestRequest start];
}

//获取车站数据
-(void)getAllStationsWithCompletion:(void(^)(NSArray *stationsArray,NSError *error))completion;
{
    if (_allStationsArray && _allStationsArray.count >0)
    {
        //return _allStationsArray;
        completion(_allStationsArray,nil);
        return;
    }
    if (!_allStationsArray) {
        _allStationsArray = [NSMutableArray array];
    }
    AFHTTPRequestOperation *allStationsRequest = [[TrainHTTPClient sharedClient] HTTPRequestWithMethod:@"GET" path:@"otsweb/js/common/station_name.js" parameters:nil];
    [allStationsRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        [_allStationsArray addObjectsFromArray:[self parseStationsData:responseObject]];
        completion(_allStationsArray,nil);

        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        completion(nil,error);
    }];
    [allStationsRequest start];
    return;
}

-(void)getFavStationsWithCompletion:(void(^)(NSArray *stationsArray,NSError *error))completion;
{
    if (_favStationSArray && _favStationSArray.count >0)
    {
        completion(_favStationSArray,nil);
        return;
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
    [favStationsRequest start];
    return;
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

//获得联系人信息
-(void)getUsualPassengersWithCompletion:(void(^)(NSMutableArray *usualPassengers,NSError *error))completion
{
    if (self.usualPassengersArray && self.usualPassengersArray.count > 0) {
        completion(self.usualPassengersArray,nil);
        return;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"0",@"pageIndex",
                            @"100",@"pageSize",
                            @"",@"passenger_name",nil];
    AFHTTPRequestOperation *passengersRequest = [[TrainHTTPClient sharedClient]HTTPRequestWithMethod:@"POST" path:@"otsweb/passengerAction.do?method=queryPagePassenger" parameters:params];
    [passengersRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        NSError *error;
        NSDictionary *passengersDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSArray *passengerDicArray = [passengersDic objectForKey:@"rows"];
        [self.usualPassengersArray removeAllObjects];
        for (NSDictionary *passengerDic in passengerDicArray) {
            Passenger *passenger = [[Passenger alloc]initWithDictionary:passengerDic];
            [self.usualPassengersArray addObject:passenger];
            if ([passenger.isUserSelf isEqualToString:@"Y"]) {
                self.userInfo = passenger;
            }
        }
        completion(self.usualPassengersArray,nil);
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        completion(nil,error);
    }];
    [passengersRequest start];
}
/*NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"0",@"pageIndex",
                        @"7",@"pageSize",
                        @"",@"passenger_name",nil];
AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order"]];
NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"https://dynamic.12306.cn/otsweb/passengerAction.do?method=queryPagePassenger" parameters:params];
AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
[operation  setHttpsAuth];
[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
    if (responseObject ==  nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"hello" message:@"无乘车人信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSString *responce = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"responce:%@",responce);
    NSError *error;
    NSDictionary *passengersDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
    NSArray *passengerDicArray = [passengersDic objectForKey:@"rows"];
    for (NSDictionary *passengerDic in passengerDicArray) {
        Passenger *passenger = [[Passenger alloc]initWithDictionary:passengerDic];
        [self.passengersArray addObject:passenger];
    }
    PassengerListController *controller = [[PassengerListController alloc]initWithStyle:UITableViewStylePlain];
    controller.passengersArray = self.passengersArray;
    [self.navigationController pushViewController:controller animated:YES];
    
} failure:^(AFHTTPRequestOperation *operation,NSError *error){
    NSLog(@"get trainNo Error:%@",error);
}];
[operation start];*/

-(void)queryAllTrainNoWithCompletion:(void(^)(NSMutableArray* trainNoInfoArray,NSError *error))completion
{
    if (self.startDate == nil) {
        completion(nil,nil);
        return;
    }
    if (self.fromStation == nil) {
        completion(nil,nil);
        return;
    }
    if (self.toStation == nil) {
        completion(nil,nil);
        return;
    }
    if (self.startTime == nil) {
        self.startTime = @"00:00--24:00";
    }
    //date=2012-10-22&fromstation=BJP&tostation=SHH&starttime=00%3A00--24%3A00
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.startDate,@"date",self.fromStation.stationTelecode,@"fromstation",self.toStation.stationTelecode,@"tostation",self.startTime,@"starttime", nil];
    AFHTTPRequestOperation *allTrainNoRequest = [[TrainHTTPClient sharedClient] HTTPRequestWithMethod:@"POST" path:@"otsweb/order/querySingleAction.do?method=queryststrainall" parameters:params];
    [allTrainNoRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        if (responseObject ==  nil) {
            completion(nil,nil);
            return;
        }
        if (self.trainNoInfoArray) {
            [self.trainNoInfoArray removeAllObjects];
        }else{
            self.trainNoInfoArray = [NSMutableArray array];
        }
        NSError *error;
        //[{"end_station_name":"上海虹桥","end_time":"12:23","id":"240000G10102","start_station_name":"北京南","start_time":"07:00","value":"G101"},
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        for (NSDictionary *dic in jsonObject) {
            TrainNoInfo *trainNo = [[TrainNoInfo alloc]initWithDictionary:dic];
            [self.trainNoInfoArray addObject:trainNo];
        }
        completion(self.trainNoInfoArray,nil);
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        completion(nil,error);
    }];
    [allTrainNoRequest start];    
}

//查询剩余票数
-(void)queryLeftTicketWithCompletion:(void (^)(NSMutableArray *, NSError *))completion
{
    NSString *selectTrainNo = @"";
    if ([TrainSession sharedSession].selectTrainNoInfo) {
        selectTrainNo = [TrainSession sharedSession].selectTrainNoInfo.trainNoId;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.startDate,@"orderRequest.train_date",
                            self.startTime,@"orderRequest.start_time_str",
                            self.fromStation.stationTelecode,@"orderRequest.from_station_telecode",
                            self.toStation.stationTelecode,@"orderRequest.to_station_telecode",
                            selectTrainNo,@"orderRequest.train_no",
                            self.trainPassType,@"trainPassType",
                            self.trainClass,@"trainClass",
                            self.includeStudent,@"includeStudent",
                            self.seatTypeNum,@"seatTypeAndNum",nil];
    AFHTTPRequestOperation *leftTicketRequest = [[TrainHTTPClient sharedClient]HTTPRequestWithMethod:@"GET" path:@"otsweb/order/querySingleAction.do?method=queryLeftTicket" parameters:params];
    [leftTicketRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        if (responseObject ==  nil) {
            completion(nil,nil);
            return;
        }
        if (self.trainTicketInfoArray) {
            [self.trainTicketInfoArray removeAllObjects];
        }else{
            self.trainTicketInfoArray = [NSMutableArray array];
        }
        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *trainsArray = [string componentsSeparatedByString:@"\\n"];
        for (NSString *trainString in trainsArray) {
            TrainTicketInfo *trainTicketInfo = [[TrainTicketInfo alloc]initWithQueryString:trainString];
            [self.trainTicketInfoArray addObject:trainTicketInfo];
        }
        completion(self.trainTicketInfoArray,nil);
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        completion(nil,error);
    }];
    [leftTicketRequest start];
    
}
    /*GET https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=2012-10-23&orderRequest.from_station_telecode=BJP&orderRequest.to_station_telecode=SHH&orderRequest.train_no=&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00 HTTP/1.1*/
/*NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                        startDate,kTrainDateField,
                        fromStationTelecode,kFromStationField,
                        toStationTelecode,kToStationField,
                        trainNo,kTrainNoField,
                        trainPassType,kTrainPassTypeField,
                        trainClass,kTrainClassField,
                        includeStudent,kStudentField,
                        seatTypeNum,kSeatTypeNumField,
                        startTime,kStartTimeField, nil];
self.queryParams = [NSMutableDictionary dictionaryWithDictionary:params];
// [self.queryParams setObject:fromStationTelecodeName forKey:@"from_station_telecode_name"];
// [self.queryParams setObject:toStationTelecodeName forKey:@"to_station_telecode_name"];
//[self.queryParams setObject:fromStationTelecodeName forKey:@"from_station_telecode_name"];
//[self.queryParams setObject:toStationTelecodeName forKey:@"to_station_telecode_name"];
//NSLog(@"params:%@",params);

AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order"]];
NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=queryLeftTicket" parameters:params];
AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
[operation  setHttpsAuth];
[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
    NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSArray *trainsArray = [string componentsSeparatedByString:@"\\n"];
    [self.queryTrainsArray removeAllObjects];
    for (NSString *trainString in trainsArray) {
        TrainInfo *trainInfo = [[TrainInfo alloc]initWithQueryString:trainString];
        [self.queryTrainsArray addObject:trainInfo];
    }
    if (self.queryTrainsArray.count >0) {
        QueryResultController *controller = [[QueryResultController alloc]init];
        controller.queryParams = self.queryParams;
        controller.queryResultArray = self.queryTrainsArray;
        [self.navigationController pushViewController:controller animated:YES];
    }
} failure:^(AFHTTPRequestOperation *operation,NSError *error){
    NSLog(@"get leftTicket Error:%@",error);
}];
[operation start];
*/


//POST https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=submutOrderRequest HTTP/1.1
//station_train_code=T107&train_date=2012-10-21&seattype_num=&from_station_telecode=BXP&to_station_telecode=SZQ&include_student=00&from_station_telecode_name=%E5%8C%97%E4%BA%AC&to_station_telecode_name=%E6%B7%B1%E5%9C%B3&round_train_date=2012-10-21&round_start_time_str=00%3A00--24%3A00&single_round_type=1&train_pass_type=QB&train_class_arr=QB%23D%23Z%23T%23K%23QT%23&start_time_str=00%3A00--24%3A00&lishi=23%3A38&train_start_time=20%3A12&trainno4=240000T1070D&arrive_time=19%3A50&from_station_name=%E5%8C%97%E4%BA%AC%E8%A5%BF&to_station_name=%E6%B7%B1%E5%9C%B3&ypInfoDetail=1*****30554*****00001*****00003*****0000&mmStr=AEF4F177FF266D42BF3A68450306BD2E681FF511721E8E5CC11D9CC7
-(void)submitOrderRequestWithCompletion:(void (^)(NSString *, NSError *))completion
{
    if (self.selectTrainTicketInfo == nil) {
        completion(nil,nil);
        return;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.selectTrainTicketInfo.trainCode,@"station_train_code",
                            //self.fromStation.stationTelecode,@"from_station_telecode",
                            //self.toStation.stationTelecode,@"to_station_telecode",
                            self.selectTrainTicketInfo.fromStationTelecode,@"from_station_telecode",
                            self.selectTrainTicketInfo.fromStationName,@"from_station_name", //与之上的区别？？
                            self.fromStation.stationCnName,@"from_station_telecode_name",
                            self.selectTrainTicketInfo.toStationTelecode,@"to_station_telecode",                            
                            self.selectTrainTicketInfo.toStationName,@"to_station_name",
                            self.toStation.stationCnName,@"to_station_telecode_name",
                            self.includeStudent,@"include_student",
                            self.startDate,@"train_date",
                            self.startTime,@"start_time_str",
                            self.startDate,@"round_train_date",
                            self.startTime,@"round_start_time_str",
                            @"1",@"single_round_type",
                            self.seatTypeNum,@"seattype_num",
                            self.trainPassType,@"train_pass_type",
                            self.trainClass,@"train_class_arr",
                            self.selectTrainTicketInfo.lishi,@"lishi",
                            self.selectTrainTicketInfo.startTime,@"train_start_time",
                            self.selectTrainTicketInfo.trainNo,@"trainno4",
                            self.selectTrainTicketInfo.arriveTime,@"arrive_time",
                            self.selectTrainTicketInfo.ypInfoDetail,@"ypInfoDetail",
                            self.selectTrainTicketInfo.mmStr,@"mmStr",
                            nil];
    
    AFHTTPRequestOperation *submitRequest = [[TrainHTTPClient sharedClient]HTTPRequestWithMethod:@"POST" path:@"otsweb/order/querySingleAction.do?method=submutOrderRequest" parameters:params];
    [submitRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject ==  nil) {
            completion(nil,nil);
            return;
        }
        NSString *responce = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        /*{
            NSString *fileName = [NSString stringWithFormat:@"%@/trainInfo.txt",NSHomeDirectory()];
            NSError *error;
            [responce writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
        }*/
        //解析票价
        for (SeatType *seat in self.seatTypeArray) {
            seat.seatPrice = nil;
        }
        NSString *regexString = @"\\<td\\>(.*?)\\(.*?\\)(.*?)\\<\\/td\\>";
        [responce enumerateStringsMatchedByRegex:regexString usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
            NSString *catptureString = capturedStrings[0];
            NSString *seatTypeName = [catptureString stringByMatching:@"\\<td\\>(.*?)\\((.*?)\\)" capture:1];
            NSString *price = [catptureString stringByMatching:@"\\<td\\>(.*?)\\((.*?)元\\)" capture:2];
            for (SeatType *seat in self.seatTypeArray) {
                if([seat.seatTypeName isEqualToString:seatTypeName])
                {
                    seat.seatPrice = price;
                    break;
                }
            }
        }];

        
        //NSString *responce = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:&error];
        self.submitOrderResponce = responce;
        
        /*  <input type="hidden" name="leftTicketStr" id="left_ticket"
         value="1025703055407200000010257000003045200000" /> */
        NSString *leftTicket = [responce stringByMatching:@"\"left_ticket\"(\\s*)value=\"(.*)\"" capture:2];
        NSLog(@"leftTicket:%@",leftTicket);
        completion(self.submitOrderResponce,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
    [submitRequest start];
    
}

/*TrainInfo *trainInfo = [self.queryResultArray objectAtIndex:indexPath.row];
NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                        trainInfo.trainCode,@"station_train_code",
                        [self.queryParams objectForKey:kTrainDateField],@"train_date",
                        [self.queryParams objectForKey:kSeatTypeNumField],@"seattype_num",
                        trainInfo.fromStationTelecode,@"from_station_telecode",
                        trainInfo.toStationTelecode,@"to_station_telecode",
                        [self.queryParams objectForKey:kStudentField],@"include_student",
                        [self.queryParams objectForKey:@"from_station_telecode_name"],@"from_station_telecode_name",
                        [self.queryParams objectForKey:@"to_station_telecode_name"],@"to_station_telecode_name",
                        [self.queryParams objectForKey:kTrainDateField],@"round_train_date",
                        [self.queryParams objectForKey:kStartTimeField],@"round_start_time_str",
                        @"1",@"single_round_type",
                        [self.queryParams objectForKey:kTrainPassTypeField],@"train_pass_type",
                        [self.queryParams objectForKey:kTrainClassField],@"train_class_arr",
                        [self.queryParams objectForKey:kStartTimeField],@"start_time_str",
                        trainInfo.lishi,@"lishi",
                        trainInfo.startTime,@"train_start_time",
                        trainInfo.trainNo,@"trainno4",
                        trainInfo.arriveTime,@"arrive_time",
                        trainInfo.fromStationName,@"from_station_name",
                        trainInfo.toStationName,@"to_station_name",
                        trainInfo.ypInfoDetail,@"ypInfoDetail",
                        trainInfo.mmStr,@"mmStr",
                        nil];


AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order"]];
NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=submutOrderRequest" parameters:params];
AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
[operation  setHttpsAuth];
[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
    if (responseObject ==  nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"hello" message:@"无车次信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSString *responce = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    //  <input type="hidden" name="leftTicketStr" id="left_ticket"
    // value="1025703055407200000010257000003045200000" /> 
    NSString *leftTicket = [responce stringByMatching:@"\"left_ticket\"(\\s*)value=\"(.*)\"" capture:2];
    NSLog(@"leftTicket:%@",leftTicket);
    ConfirmOrderController *controller = [[ConfirmOrderController alloc]initWithStyle:UITableViewStyleGrouped];
    controller.queryParams = self.queryParams;
    controller.trainInfo = trainInfo;
    controller.leftTicket = leftTicket;
    [self.navigationController pushViewController:controller animated:YES];
    
} failure:^(AFHTTPRequestOperation *operation,NSError *error){
    NSLog(@"get trainNo Error:%@",error);
}];
[operation start];

}*/


@end

@implementation CodeValuePair
-(id)initWithCode:(NSString *)code value:(NSString *)value
{
    if (self = [super init]) {
        _code = code;
        _value = value;
    }
    return self;
}
@end
