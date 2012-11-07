//
//  StationSelectController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-21.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "StationSelectController.h"
#import "AFNetworking.h"
#import "AFURLConnectionOperation+HTTPS.h"
@interface StationSelectController ()

@end

@implementation StationSelectController
@synthesize delegate;

#define STATION_EN_NAME_KEY @"stationEnName"
#define STATION_CN_NAME_KEY @"stationCnName"
#define STATION_TELECODE_KEY @"stationTelecode"
#define STATION_INDEX_KEY   @"stationIndex"

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        alphaStationsArray = [NSMutableArray arrayWithCapacity:26];
        favStationsArray = [NSMutableArray array];
        showStationsArray = [NSMutableArray array];
        indexTitlesArray = [NSMutableArray array];
        for (int i=0; i<26 ;i++) {
            [alphaStationsArray addObject:[NSMutableArray array]];
        }
    }
    return self;
}


#pragma mark -
#pragma mark 解析站点数据

-(void)parseStationsData:(NSData*)data
{
    for (int i =0; i<26; i++) {
        [((NSMutableArray*)[alphaStationsArray objectAtIndex:i]) removeAllObjects];
    }
    
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *stationStringArray = [string componentsSeparatedByString:@"@"];
    for (NSString *oneStation in stationStringArray) {
        NSArray *stationArray = [oneStation componentsSeparatedByString:@"|"];
        if (stationArray.count != 4) {
            continue;
        }
        NSString *stationEnName = [stationArray objectAtIndex:0];
        NSString *stationCnName = [stationArray objectAtIndex:1];
        NSString *stationTelecode = [stationArray objectAtIndex:2];
        NSString *stationIndex = [stationArray objectAtIndex:3];
        NSDictionary *stationDic = [NSDictionary dictionaryWithObjectsAndKeys:stationEnName,STATION_EN_NAME_KEY,stationCnName,STATION_CN_NAME_KEY,stationTelecode,STATION_TELECODE_KEY,stationIndex,STATION_INDEX_KEY, nil];
        NSInteger alphaIndex = [stationEnName characterAtIndex:0]-'a';
        if (alphaIndex >=0 && alphaIndex <26) {
            [[alphaStationsArray objectAtIndex:alphaIndex] addObject:stationDic];
        }
    }
    [self reloadData];
}

-(void)parseFavStationsData:(NSData*)data
{
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *stationStringArray = [string componentsSeparatedByString:@"@"];
    [favStationsArray removeAllObjects];
    for (NSString *oneStation in stationStringArray) {
        NSArray *stationArray = [oneStation componentsSeparatedByString:@"|"];
        if (stationArray.count != 4) {
            continue;
        }
        NSString *stationEnName = [stationArray objectAtIndex:0];
        NSString *stationCnName = [stationArray objectAtIndex:1];
        NSString *stationTelecode = [stationArray objectAtIndex:2];
        NSString *stationIndex = [stationArray objectAtIndex:3];
        NSDictionary *stationDic = [NSDictionary dictionaryWithObjectsAndKeys:stationEnName,STATION_EN_NAME_KEY,stationCnName,STATION_CN_NAME_KEY,stationTelecode,STATION_TELECODE_KEY,stationIndex,STATION_INDEX_KEY, nil];
        [favStationsArray addObject:stationDic];
    }
    [self reloadData];
}

-(void)reloadData
{
    [showStationsArray removeAllObjects];
    [indexTitlesArray removeAllObjects];
    [indexTitlesArray addObject:UITableViewIndexSearch];
    if (favStationsArray.count > 0) {
        [showStationsArray addObject:favStationsArray];
        [indexTitlesArray addObject:@"&"];
    }
    for (int i=0; i<26; i++) {
        NSArray *alphaArray = [alphaStationsArray objectAtIndex:i];
        if (alphaArray.count >0 ) {
            [showStationsArray addObject:alphaArray];
            [indexTitlesArray addObject:[NSString stringWithFormat:@"%c",'A'+i]];
        }
    }
    [_tableView reloadData];
    
}

#pragma mark -
#pragma mark - UITableViewDataSouce/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return [showStationsArray count];   
    }else{
        return 1;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        NSArray *alphaArray = [showStationsArray objectAtIndex:section];
        return alphaArray.count;
    }else{
        return 0;
    }

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {        
        NSString *indexTitle = [indexTitlesArray objectAtIndex:section+1];
        if ([indexTitle isEqualToString:@"&"]) {
            return @"热门";
        }else{
            return indexTitle;
        }
    }else{
        return nil;
    }
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return indexTitlesArray;
    }else{
        return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch) {
        [_tableView scrollRectToVisible:_searchBar.frame animated:NO];
        return -1;
    }else{
        return index -1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetifier = @"stationIndetifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    }
    NSArray *alphaArray = [showStationsArray objectAtIndex:indexPath.section];
    NSDictionary *stationDic = [alphaArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [stationDic objectForKey:STATION_CN_NAME_KEY];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *alphaArray = [showStationsArray objectAtIndex:indexPath.section];
    NSDictionary *stationDic = [alphaArray objectAtIndex:indexPath.row];
    NSString *stationCnName = [stationDic objectForKey:STATION_CN_NAME_KEY];
    NSString *stationTelecode = [stationDic objectForKey:STATION_TELECODE_KEY];
    [self.delegate selectStation:stationCnName teleCode:stationTelecode];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 视图生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0)];
    _searchBar.keyboardType = UIKeyboardTypeAlphabet;
    
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _searchBar;
    [self.view addSubview:_tableView];
    
    _searchDC = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDC.searchResultsDataSource = self;
    _searchDC.searchResultsDelegate = self;
    
    NSURLRequest *stationNameRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/js/common/station_name.js"]];
    AFHTTPRequestOperation *stationNameOperation = [[AFHTTPRequestOperation alloc]initWithRequest:stationNameRequest];
    [stationNameOperation setHttpsAuth];
    [stationNameOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        [self parseStationsData:responseObject];
        [popView destory];
        popView = nil;
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"get stations Error:%@",error);
        [popView destory];
        popView = nil;
    }];
    
    NSURLRequest *favStationNameRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/js/common/favorite_name.js"]];
    AFHTTPRequestOperation *favStationNameOperation = [[AFHTTPRequestOperation alloc]initWithRequest:favStationNameRequest];
    [favStationNameOperation setAuthenticationAgainstProtectionSpaceBlock:^ BOOL (NSURLConnection *connection,NSURLProtectionSpace *protectionSpace){
        return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    } ];
    [favStationNameOperation setAuthenticationChallengeBlock:^(NSURLConnection *connection,NSURLAuthenticationChallenge *challenge){
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }];
    [favStationNameOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseObject){
        [self parseFavStationsData:responseObject];
        [popView destory];
        popView = nil;
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"get stations Error:%@",error);
        [popView destory];
        popView = nil;
    }];
    
    
    popView = [[PopUpView alloc] init];
	popView.hintLabel.text = @"正在载入...";
	[popView showInView:self.view];
    [stationNameOperation start];
    [favStationNameOperation start];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
