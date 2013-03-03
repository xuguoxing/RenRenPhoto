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
#import "TrainSession.h"
@interface StationSelectController ()

@end

@implementation StationSelectController
@synthesize delegate;

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


-(void)reloadData
{
    if (!getingAllStations && !getingFavStations) {
        [popView destory];
        popView = nil;
    }
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
    StationInfo *station  = [alphaArray objectAtIndex:indexPath.row];
    cell.textLabel.text = station.stationCnName;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *alphaArray = [showStationsArray objectAtIndex:indexPath.section];
    StationInfo *station = [alphaArray objectAtIndex:indexPath.row];
    [self.delegate selectStation:station];
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
    
    
    popView = [[PopUpView alloc] init];
	popView.hintLabel.text = @"正在载入...";
	[popView showInView:self.view];
     getingAllStations = YES;
    [[TrainSession sharedSession] getAllStationsWithCompletion:^(NSArray *stationsArray, NSError *error) {
        self->getingAllStations = NO;
        if (stationsArray) {
            for (int i =0; i<26; i++) {
                [((NSMutableArray*)[alphaStationsArray objectAtIndex:i]) removeAllObjects];
            }
            for (StationInfo *station in stationsArray) {
                NSString *stationEnName = station.stationEnName;
                NSInteger alphaIndex = [stationEnName characterAtIndex:0]-'a';
                if (alphaIndex >=0 && alphaIndex <26) {
                    [[alphaStationsArray objectAtIndex:alphaIndex] addObject:station];
                }
            }
            [self reloadData];
        }else{
            NSLog(@"get AllStations Error");
        }
    }];
    getingFavStations = YES;
    [[TrainSession sharedSession]getFavStationsWithCompletion:^(NSArray *stationsArray, NSError *error) {
        self->getingFavStations = NO;
        if (stationsArray) {
             [favStationsArray removeAllObjects];
            [favStationsArray addObjectsFromArray:stationsArray];
            [self reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
