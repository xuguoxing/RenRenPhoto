//
//  QueryViewController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-21.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "QueryViewController.h"
#import "DateUtils.h"
#import "AFNetworking.h"
#import "AFURLConnectionOperation+HTTPS.h"
#import "Constants.h"
#import "TFHpple.h"
#import "NSString+HTML.h"
#import "RegexKitLite.h"
#import "TrainInfo.h"
#import "QueryResultController.h"
@interface QueryViewController ()

@end

@implementation QueryViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        //minDate = [NSDate date];
        //maxDate = [NSDate dateWithTimeIntervalSinceNow:11*24*3600];
        fromStationTelecode = @"";
        toStationTelecode = @"";
        startDate = getDateString([NSDate date]);
        startDateWeek = getWeekString([NSDate date]);
        startTime = @"00:00--24:00";
        trainNo = @"";
        trainNoDesc = @"";
        trainClass = @"QB#D#Z#T#K#QT#";
        trainPassType = @"QB";
        seatTypeNum = @"";
        includeStudent = @"00";
        
        self.queryTrainsArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark StationSelectDelegate
-(void)selectStation:(NSString *)stationCnName teleCode:(NSString *)stationTeleCode
{
    NSLog(@"select :%@ -%@",stationCnName,stationTeleCode);
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            fromStationTelecode = stationTeleCode;
            fromStationTelecodeName = stationCnName;
        }else if(indexPath.row == 1){
            toStationTelecode = stationTeleCode;
            toStationTelecodeName = stationCnName;
        }
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = stationCnName;
    }
}

#pragma mark -
#pragma mark DateSelectDelegate
-(void)selectDate:(NSString *)dateString weekDay:(NSString *)weekString
{
    NSLog(@"select date:%@ week:%@",dateString,weekString);
     NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    if (indexPath.section == 1 && indexPath.row == 0) {
        startDate = dateString;
        startDateWeek = weekString;
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",dateString,weekString];
    }
}

#pragma mark -
#pragma mark 选择车次
-(void)selectTrainNo
{
    if (fromStationTelecode.length == 0 || toStationTelecode.length == 0 || startDate.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"hello" message:@"请填写完整出发地、目的地以及出发日期再进行车次选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    //date=2012-10-22&fromstation=BJP&tostation=SHH&starttime=00%3A00--24%3A00
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:startDate,@"date",fromStationTelecode,@"fromstation",toStationTelecode,@"tostation",startTime,@"starttime", nil];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=queryststrainall" parameters:params];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation  setHttpsAuth];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        if (responseObject ==  nil) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"hello" message:@"无车次信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        //G101（北京南07:00→上海虹桥12:23）
        TrainNoSelectController *controller = [[TrainNoSelectController alloc]init];
        controller.delegate = self;
        controller.trainNoArray = jsonObject;
        [self.navigationController pushViewController:controller animated:YES];        
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"get trainNo Error:%@",error);
    }];
    [operation start];
    

}

-(void)selectTrainNo:(NSString *)trainNoString desc:(NSString *)descString
{
    NSLog(@"select trainNo:%@ Desc:%@",trainNo,descString);
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    if (indexPath.section == 2 && indexPath.row == 0) {
        trainNo = trainNoString;
        trainNoDesc = descString;
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = trainNoDesc;
    }
}

#pragma mark -
#pragma mark 查询

-(void)startQuery:(id)sender
{
    // NSString *fileName = [NSString stringWithFormat:@"%@/trainInfo.txt",NSHomeDirectory()];
    //NSError *error;
    //NSString *responce = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:&error];
    
    //NSString *responce = @"<input type=\"hidden\" name=\"leftTicketStr\" id=\"left_ticket\" value=\"1025703055407200000010257000003045200000\" />";
    //NSString *leftTicket = [responce stringByMatching:@"\"left_ticket\"(\\s*)value=\"(.*)\"" capture:2];
   // NSLog(@"leftTicket:%@",leftTicket);
    //return;
    /*NSString *submitReqeust = @"station_train_code=T107&train_date=2012-10-21&seattype_num=&from_station_telecode=BXP&to_station_telecode=SZQ&include_student=00&from_station_telecode_name=%E5%8C%97%E4%BA%AC&to_station_telecode_name=%E6%B7%B1%E5%9C%B3&round_train_date=2012-10-21&round_start_time_str=00%3A00--24%3A00&single_round_type=1&train_pass_type=QB&train_class_arr=QB%23D%23Z%23T%23K%23QT%23&start_time_str=00%3A00--24%3A00&lishi=23%3A38&train_start_time=20%3A12&trainno4=240000T1070D&arrive_time=19%3A50&from_station_name=%E5%8C%97%E4%BA%AC%E8%A5%BF&to_station_name=%E6%B7%B1%E5%9C%B3&ypInfoDetail=1*****30554*****00001*****00003*****0000&mmStr=AEF4F177FF266D42BF3A68450306BD2E681FF511721E8E5CC11D9CC7";
    NSString *decocdeString = [submitReqeust stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"decodeString:%@",decocdeString);*/
    
    /*NSString *textField = @"%E4%B8%AD%E6%96%87%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D";
    NSLog(@"textField:%@",[textField stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
   
    NSString *passengerTickets = @"1%2C0%2C1%2C%E5%BE%90%E5%9B%BD%E5%85%B4%2C1%2C371525198504033718%2C18666211427%2CY";
    NSLog(@"passengerTickets:%@",[passengerTickets stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    NSString *oldPassengers = @"%E5%BE%90%E5%9B%BD%E5%85%B4%2C1%2C371525198504033718";
    NSLog(@"oldPassengers:%@",[oldPassengers stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    return;*/
    
    /*GET https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=2012-10-23&orderRequest.from_station_telecode=BJP&orderRequest.to_station_telecode=SHH&orderRequest.train_no=&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00 HTTP/1.1*/
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
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
    [self.queryParams setObject:fromStationTelecodeName forKey:@"from_station_telecode_name"];
    [self.queryParams setObject:toStationTelecodeName forKey:@"to_station_telecode_name"];
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

}

#pragma mark -
#pragma mark  UITableViewDataSource/Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"queryContentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"出发地";
            cell.detailTextLabel.text = fromStationTelecodeName;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"目的地";
            cell.detailTextLabel.text = toStationTelecodeName;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"出发日期";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",startDate,startDateWeek];
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"出发车次";
            cell.detailTextLabel.text = trainNoDesc;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        StationSelectController *controller = [[StationSelectController alloc]init];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(indexPath.section == 1){
        DateSelectController *controller = [[DateSelectController alloc]init];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(indexPath.section == 2){
        [self selectTrainNo];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGRect frame = self.view.bounds;
    frame.size.height -= 50;
    _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIButton *queryLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [queryLeftButton setTitle:@"查询余票" forState:UIControlStateNormal];
    queryLeftButton.frame = CGRectMake(100, 350, 60, 40);
    [queryLeftButton addTarget:self action:@selector(startQuery:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryLeftButton];
    
    /*UILabel *trainNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 200, 60, 20)];
    trainNoLabel.text = @"出发车次";
    [self.view addSubview:trainNoLabel];
    trainNoField = [[UITextField alloc]initWithFrame:CGRectMake(60, 200, 80, 20)];
    trainNoField.placeholder = @"出发车次";
    [self.view addSubview:trainNoField];*/
    
    
    /*UILabel *trainClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 260, 60, 20)];
    trainClassLabel.text = @"车次类型";
    [self.view addSubview:trainClassLabel];
    trainClassField = [[UITextField alloc]initWithFrame:CGRectMake(220, 260, 80, 20)];
    trainClassField.placeholder = @"车次类型";
    [self.view addSubview:trainClassField];
    
    
    UILabel *trainPassTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 290, 60, 20)];
    trainPassTypeLabel.text = @"过路类型";
    [self.view addSubview:trainPassTypeLabel];
    trainPassTypeField = [[UITextField alloc]initWithFrame:CGRectMake(60, 290, 80, 20)];
    trainPassTypeField.placeholder = @"过路类型";
    [self.view addSubview:trainPassTypeField];
    
    
    UILabel *seatTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 320, 60, 20)];
    seatTypeLabel.text = @"席别";
    [self.view addSubview:seatTypeLabel];
    seatTypeField = [[UITextField alloc]initWithFrame:CGRectMake(60, 320, 80, 20)];
    seatTypeField.placeholder = @"席别";
    [self.view addSubview:seatTypeField];
    
    UILabel *seatNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 320, 60, 20)];
    seatNumLabel.text = @"购票张数";
    [self.view addSubview:seatNumLabel];
    seatNumField = [[UITextField alloc]initWithFrame:CGRectMake(220, 320, 80, 20)];
    seatNumField.placeholder = @"购票张数";
    [self.view addSubview:seatNumField];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
