//
//  FriendsViewController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-9-16.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "FriendsViewController.h"
#import "UIImageView+WebCache.h"
#import "AlbumsViewController.h"
@interface FriendsViewController ()

@end

@implementation FriendsViewController
@synthesize friendsArray = _friendsArray;
@synthesize friendsAlbumArray = _friendAlbumArray;
-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

#pragma  mark -
#pragma mark 好友相册数组
-(void)setFriendsArray:(NSArray *)friendsArray
{
    _friendsArray = friendsArray;
    _friendAlbumArray = [NSMutableArray arrayWithCapacity:friendsArray.count];
    for (int i=0; i<friendsArray.count; i++) {
        [_friendAlbumArray addObject:[NSNull null]];
    }
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
    return 40.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *indentifier = @"FriendsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    FriendInfo *friend = [self.friendsArray objectAtIndex:row];

    [cell.imageView setImageWithURL:[NSURL URLWithString:friend.headurl]];
    cell.textLabel.text = friend.name;
    
    NSString *friendId = [friend.id stringValue];
    __weak FriendsViewController *blockSelf = self;
    __weak UITableViewCell *blockCell = cell;
    
    if ([_friendAlbumArray objectAtIndex:row] == [NSNull null]) {
        [[Renren sharedRenren] getUserAlbums:friendId withCompletionBlock:^(NSArray* albumsArray){
            [blockSelf.friendsAlbumArray replaceObjectAtIndex:row withObject:[NSArray arrayWithArray:albumsArray]];
            blockCell.detailTextLabel.text = [NSString stringWithFormat:@"%d 个相册",albumsArray.count];
        
        } failedBlock:^(NSError *error){
            NSLog(@"getAlbums id:%@ Error:%@",friendId,error);
        }];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSArray *albumArray = [self.friendsAlbumArray objectAtIndex:row];
    if ([albumArray isKindOfClass:[NSNull class] ]) {
        return;
    }
    AlbumsViewController *controller = [[AlbumsViewController alloc]init];
    FriendInfo *friend = [self.friendsArray objectAtIndex:row];
    controller.owner = [[UserInfo alloc]initWithFriendInfo:friend];
    controller.albumsArray = albumArray;
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"好友";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
