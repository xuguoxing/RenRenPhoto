//
//  QueryResultController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-28.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "QueryResultController.h"
#import "TrainInfo.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "AFURLConnectionOperation+HTTPS.h"
#import "RegexKitLite.h"
#import "ConfirmOrderController.h"
@interface QueryResultController ()

@end

@implementation QueryResultController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.queryResultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    TrainInfo *info = [self.queryResultArray objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@ %@(%@)-%@(%@)",info.trainCode,info.fromStationName,info.startTime,info.toStationName,info.arriveTime];
    NSString *ticket = [info ticketInfo];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = ticket;
    return cell;
}


#pragma mark - Table view delegate

//POST https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=submutOrderRequest HTTP/1.1
//station_train_code=T107&train_date=2012-10-21&seattype_num=&from_station_telecode=BXP&to_station_telecode=SZQ&include_student=00&from_station_telecode_name=%E5%8C%97%E4%BA%AC&to_station_telecode_name=%E6%B7%B1%E5%9C%B3&round_train_date=2012-10-21&round_start_time_str=00%3A00--24%3A00&single_round_type=1&train_pass_type=QB&train_class_arr=QB%23D%23Z%23T%23K%23QT%23&start_time_str=00%3A00--24%3A00&lishi=23%3A38&train_start_time=20%3A12&trainno4=240000T1070D&arrive_time=19%3A50&from_station_name=%E5%8C%97%E4%BA%AC%E8%A5%BF&to_station_name=%E6%B7%B1%E5%9C%B3&ypInfoDetail=1*****30554*****00001*****00003*****0000&mmStr=AEF4F177FF266D42BF3A68450306BD2E681FF511721E8E5CC11D9CC7

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainInfo *trainInfo = [self.queryResultArray objectAtIndex:indexPath.row];
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
      /*  <input type="hidden" name="leftTicketStr" id="left_ticket"
        value="1025703055407200000010257000003045200000" /> */
        NSString *leftTicket = [responce stringByMatching:@"\"left_ticket\"(\\s*)value=\"(.*)\"" capture:2];
        NSLog(@"leftTicket:%@",leftTicket);
        ConfirmOrderController *controller = [[ConfirmOrderController alloc]initWithStyle:UITableViewStyleGrouped];
        controller.queryParams = self.queryParams;
        controller.trainInfo = trainInfo;
        controller.leftTicket = leftTicket;
        [self.navigationController pushViewController:controller animated:YES];
        //UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 50, 320, 400)];
        //[webView loadHTMLString:responce baseURL:nil];
        //[self.view addSubview:webView];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"get trainNo Error:%@",error);
    }];
    [operation start];

}

@end
