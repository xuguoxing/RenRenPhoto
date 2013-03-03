//
//  FriendsViewController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-9-16.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "FriendsViewController.h"
#import "UIImageView+WebCache.h"
#import "UserAlbumsController.h"
#import "IconImage.h"
#import "SVProgressHUD.h"
#import "CommonUtils.h"
#import "FriendCell.h"
#import "UIPullToReloadTableView.h"
#import "PhotoBrowserController.h"
@interface FriendsViewController ()
@property (nonatomic) NSMutableArray *friendsArray;
@property (nonatomic) UIPullToReloadTableView *tableView;

@end

@implementation FriendsViewController

-(id)init
{
    if (self = [super init]) {
        self.title = @"我的好友";
        self.friendsArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *indentifier = @"FriendsCell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[FriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        //[cell.actionButton addTarget:self action:@selector(openAlbums:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    UserInfo *userInfo = [self.friendsArray objectAtIndex:row];
    cell.actionButton.tag = row;
    [cell setUserInfo:userInfo];    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row < self.friendsArray.count) {
        UserInfo *userInfo = [self.friendsArray objectAtIndex:row];
        UserAlbumsController *controller = [[UserAlbumsController alloc]init];
        controller.userId = [userInfo.uid stringValue];
        [self.navigationController pushViewController:controller animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)pullDownToReloadAction
{
    [self reloadData];
}

#pragma mark 更新数据
-(void)reloadData
{
    __weak FriendsViewController *blockSelf = self;
    [[Renren sharedRenren] getFriendIdsWithCompletion:^(NSArray *friendsArray) {
        [[Renren sharedRenren] getUserInfos:friendsArray WithCompletion:^(NSArray *userInfos) {
            [[Renren sharedRenren].friendsArray removeAllObjects];
            [[Renren sharedRenren].friendsArray addObjectsFromArray:userInfos];
            [[Renren sharedRenren] saveFriendsToUserDic];
            blockSelf.friendsArray = [Renren sharedRenren].friendsArray;
            [blockSelf.tableView reloadData];
            [blockSelf.tableView pullDownToReloadActionFinished];
        } failed:^(NSError *error) {
            [blockSelf.tableView pullDownToReloadActionFinished];
        }];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    self.friendsArray = [Renren sharedRenren].friendsArray;
    if (self.friendsArray && self.friendsArray.count>0) {
        [self.tableView reloadData];
    }
}

#pragma mark 打开相册
-(void)openAlbums:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSInteger row = button.tag;
    if (row < self.friendsArray.count) {
        UserInfo *userInfo = [self.friendsArray objectAtIndex:row];
        UserAlbumsController *controller = [[UserAlbumsController alloc]init];
        controller.userId = [userInfo.uid stringValue];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = labelForNavTitle(self.title);
    
    _tableView = [[UIPullToReloadTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.friendsArray = [Renren sharedRenren].friendsArray;
    if (self.friendsArray && self.friendsArray.count>0) {
        [self.tableView reloadData];
    }else{
        [_tableView autoPullDownToRefresh];
    }
    
    [self reloadData];
    //[_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{    
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
