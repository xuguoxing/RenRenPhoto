//
//  ConfirmOrderController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-30.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "ConfirmOrderController.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "AFURLConnectionOperation+HTTPS.h"
#import "Passenger.h"
#import "PassengerListController.h"
#import "TrainSession.h"
@interface ConfirmOrderController ()

@end

//    商务座,特等座,一等座，二等座，高级软卧,软卧,硬卧,软座，硬座，无座,其他
//       9    P     M    O       6      4   3    2    1   1(3000+座位)


@implementation ConfirmOrderController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _seatTypeNameDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"商务座",@"9",
                                @"特等座",@"P",
                                @"一等座",@"M",
                                @"二等座",@"O",
                                @"高级软卧",@"6",
                                @"软卧",@"4",
                                @"硬卧",@"3",
                                @"软座",@"2",
                                @"硬座",@"1",nil];
        _seatTypeNumArray = [NSMutableArray array];
        //_passengersArray = [NSMutableArray array];
    }
    return self;
}

-(void)setLeftTicket:(NSString *)leftTicket
{
    _leftTicket = leftTicket;
    NSRange range = NSMakeRange(0, 10);
    [self.seatTypeNumArray removeAllObjects];
    while (range.location + range.length <= leftTicket.length) {
        NSString *subString = [leftTicket substringWithRange:range];
        NSString *seatType = [subString substringToIndex:1];
        NSString *seatTypeName = [self.seatTypeNameDic objectForKey:seatType];
        NSString *reseverFiled = [subString substringWithRange:NSMakeRange(1, 5)];
        NSString *seatNumStr = [subString substringWithRange:NSMakeRange(6, 4)];
        NSInteger seatNum = [seatNumStr integerValue];
        if (seatNum >= 3000) {
            seatNum -= 3000;
            seatNumStr = [NSString stringWithFormat:@"%4d",seatNum];
        }
        
        NSDictionary *seatTypeNumDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        subString,@"origString",
                                        seatType,@"seatType",
                                        seatTypeName,@"seatTypeName",
                                        reseverFiled,@"reserverFiled",
                                        seatNumStr,@"seatNum",
                                        nil];
        [self.seatTypeNumArray addObject:seatTypeNumDic];
        range.location += 10;
    }
    
}
-(void)parseLeftTicket:(NSString*)leftTicket
{
    NSRange range = NSMakeRange(0, 10);
    //NSMutableArray *ticketArray = [NSMutableArray alloc];
    [self.seatTypeNumArray removeAllObjects];
    while (range.location + range.length <= leftTicket.length) {
        NSString *subString = [leftTicket substringWithRange:range];
        NSString *seatType = [subString substringToIndex:1];
        NSString *seatTypeName = [self.seatTypeNameDic objectForKey:seatType];
        NSString *reseverFiled = [subString substringWithRange:NSMakeRange(1, 5)];
        NSString *seatNum = [subString substringWithRange:NSMakeRange(6, 4)];
        NSDictionary *seatTypeNumDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        subString,@"origString",
                                        seatType,@"seatType",
                                        seatTypeName,@"seatTypeName",
                                        reseverFiled,@"reserverFiled",
                                        seatNum,@"seatNum",
                                        nil];
        [self.seatTypeNumArray addObject:seatTypeNumDic];
    }
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else if(section == 1){
        return self.seatTypeNumArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConfirmOrderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    TrainTicketInfo *ticketInfo = [TrainSession sharedSession].selectTrainTicketInfo;
    if (section == 0) {
        switch (row) {
            case 0:
                cell.textLabel.text = @"车次";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@-%@",ticketInfo.trainCode,ticketInfo.fromStationName,ticketInfo.toStationName];
                break;
            case 1:
                cell.textLabel.text = @"日期";
                cell.detailTextLabel.text = [TrainSession sharedSession].startDate; //kTrainDateField
                break;
            case 2:
                cell.textLabel.text = @"时间";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@(历时:%@)",ticketInfo.startTime,ticketInfo.arriveTime,ticketInfo.lishi];
                break;
            case 3:
                cell.textLabel.text = @"席别";
                cell.detailTextLabel.text = @"硬座";
                break;
            case 4:
                cell.textLabel.text = @"票种";
                cell.detailTextLabel.text = @"成人票";
                break;
            case 5:
                cell.textLabel.text = @"乘车人";
                cell.detailTextLabel.text = @"点击选择乘车人";
                break;
            case 6:
                cell.textLabel.text = self.leftTicket;
                break;
            default:
                break;
        }        
    }else if(section == 1){
        NSDictionary *seatNumDic = [self.seatTypeNumArray objectAtIndex:row];
        cell.textLabel.text = [seatNumDic objectForKey:@"origString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[seatNumDic objectForKey:@"seatTypeName"],[seatNumDic objectForKey:@"seatNum"]];
    }
        
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 5) {
        [[TrainSession sharedSession]getUsualPassengersWithCompletion:^(NSMutableArray *usualPassengers, NSError *error) {
            PassengerListController *controller = [[PassengerListController alloc]initWithStyle:UITableViewStylePlain];
            controller.passengersArray = usualPassengers;
            [self.navigationController pushViewController:controller animated:YES];
        }];
        //pageIndex=0&pageSize=7&passenger_name=%E8%AF%B7%E8%BE%93%E5%85%A5%E6%B1%89%E5%AD%97%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D
        
        /*NSString *string = @"%E8%AF%B7%E8%BE%93%E5%85%A5%E6%B1%89%E5%AD%97%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D";
        NSString *passenger = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"passenger:%@",passenger);
        return;*/
        
        /*NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"0",@"pageIndex",
                                @"7",@"pageSize",
                                @"请输入汉字或拼音首字母",@"passenger_name",nil];*/
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
        
    }
}

-(void)confirmSingleForQueueOrder:(id)sender
{
    
    /*leftTicketStr=O055500265M0935000809175000000&
    textfield=%E4%B8%AD%E6%96%87%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D&*/
    NSDictionary *commonDic = @{@"leftTicketStr":self.leftTicket,
    @"textfield":@"中文或拼音首字母"};

    
    /*orderRequest.train_date=2012-11-05&
    orderRequest.train_no=240000G10102&
    orderRequest.station_train_code=G101&
    orderRequest.from_station_telecode=VNP&
    orderRequest.to_station_telecode=AOH&
    orderRequest.seat_type_code=&
    orderRequest.seat_detail_type_code=&
    orderRequest.ticket_type_order_num=&
    orderRequest.bed_level_order_num=000000000000000000000000000000&
    orderRequest.start_time=07%3A00&
    orderRequest.end_time=12%3A23&
    orderRequest.from_station_name=%E5%8C%97%E4%BA%AC%E5%8D%97&
    orderRequest.to_station_name=%E4%B8%8A%E6%B5%B7%E8%99%B9%E6%A1%A5&
    orderRequest.cancel_flag=1&
    orderRequest.id_mode=Y&*/
    
    TrainTicketInfo *ticketInfo = [TrainSession sharedSession].selectTrainTicketInfo;
    
    NSDictionary *orderRequestDic = @{@"orderRequest.train_date":[TrainSession sharedSession].startDate,
                                      @"orderRequest.station_train_code":ticketInfo.trainCode,
    @"orderRequest.from_station_telecode":ticketInfo.fromStationTelecode,
    @"orderRequest.to_station_telecode":ticketInfo.toStationTelecode,
    @"orderRequest.seat_type_code":@"",
    @"orderRequest.seat_detail_type_code":@"",
    @"orderRequest.ticket_type_order_num":@"",
    @"orderRequest.bed_level_order_num":@"000000000000000000000000000000",
    @"orderRequest.start_time":ticketInfo.startTime,
    @"orderRequest.end_time":ticketInfo.arriveTime,
    @"orderRequest.from_station_name":ticketInfo.fromStationName,
    @"orderRequest.to_station_name":ticketInfo.toStationName,
    @"orderRequest.cancel_flag":@"1",
    @"orderRequest.id_mode":@"Y"
    };
    
    /*passengerTickets=M%2C0%2C1%2C%E7%A7%A6%E8%89%B3%E7%90%B4%2C1%2C450323198907060927%2C15602793018%2CY&
    oldPassengers=%E7%A7%A6%E8%89%B3%E7%90%B4%2C1%2C450323198907060927&
    passenger_1_seat=M&
    passenger_1_seat_detail=0&
    passenger_1_ticket=1&
    passenger_1_name=%E7%A7%A6%E8%89%B3%E7%90%B4&
    passenger_1_cardtype=1&
    passenger_1_cardno=450323198907060927&
    passenger_1_mobileno=15602793018&
    checkbox9=Y&*/
    
    NSDictionary *passenger1Dic = @{@"passengerTickets":@""};

    

}

@end
