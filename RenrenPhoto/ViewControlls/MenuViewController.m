//
//  MenuViewController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-18.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuWatermarkFooter.h"
#import "MenuHeaderView.h"
#import "MenuTableViewCell.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "IconImage.h"
#import "UserAlbumsController.h"
#import "FriendsViewController.h"
#import "PhotoFeedController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface MenuViewController ()
{
    //MenuHeaderView* _menuHeader;
    NSMutableArray* _cellContents;
    NSInteger _lastSelectIndex;
}
@property (nonatomic) UITableView *tableView;
@property (nonatomic) MenuHeaderView *menuHeader;
@end

#define kCellText @"CellText"
#define kCellImage @"CellImage"
#define kCellHighlightImage @"CellHighlightImage"

@implementation MenuViewController

-(id)init
{
    if (self = [super init]) {
        _selectIndex  = -1;
        _cellContents = [[NSMutableArray alloc] init];
        [_cellContents addObject:@{kCellImage: [IconImage iconNewsFeedImage], kCellHighlightImage: [IconImage iconNewsFeedImage],kCellText: @"相册动态"}];
        [_cellContents addObject:@{kCellImage: [IconImage leftMenuLocalAlbumIcnImage],kCellHighlightImage: [IconImage leftMenuLocalAlbumIcnHoverImage], kCellText: @"我的相册"}];
        [_cellContents addObject:@{kCellImage: [IconImage iconFriendImage], kCellHighlightImage: [IconImage iconFriendhlImage], kCellText: @"我的好友"}];
        [_cellContents addObject:@{kCellImage: [IconImage SettingIcnImage], kCellHighlightImage: [IconImage SettingIcnHoverImage], kCellText: @"退出"}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _menuHeader = [[MenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, 200, 70)];
    UserInfo *userInfo = [Renren sharedRenren].userInfo;
    if (userInfo) {
        [_menuHeader.imageView setImageWithURL:[NSURL URLWithString:userInfo.headurl] placeholderImage:[IconImage emptyPhotoImage]];
        _menuHeader.textLabel.text = userInfo.name;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[IconImage leftMenuBgImage]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView.tableFooterView = [[MenuWatermarkFooter alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_cellContents count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	cell.textLabel.text = _cellContents[indexPath.row][kCellText];
	cell.imageView.image = _cellContents[indexPath.row][kCellImage];
    cell.image = _cellContents[indexPath.row][kCellImage];
    cell.highlightImage = _cellContents[indexPath.row][kCellHighlightImage];
    
    if (self.selectIndex == indexPath.row) {
        [cell setSelected:YES animated:NO];
    }else{
        [cell setSelected:NO animated:NO];
    }    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return _menuHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectIndex:indexPath.row];
}


-(void)setSelectIndex:(NSInteger)selectIndex
{
    if (_selectIndex != selectIndex) {
        _selectIndex = selectIndex;
                
        DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
        UINavigationController *nav;
        NSString *text = _cellContents[selectIndex][kCellText];
        if ([text isEqualToString:@"相册动态"]) {
            PhotoFeedController *feedController = [[PhotoFeedController alloc]init];
            nav = [[UINavigationController alloc]initWithRootViewController:feedController];
        }else if([text isEqualToString:@"我的相册"]){
            UserAlbumsController *albumsController = [[UserAlbumsController alloc]init];
            albumsController.userId = [Renren sharedRenren].uid;
            nav = [[UINavigationController alloc]initWithRootViewController:albumsController];            
        }else if([text isEqualToString:@"我的好友"]){
            FriendsViewController *friendsController = [[FriendsViewController alloc]init];
            nav = [[UINavigationController alloc]initWithRootViewController:friendsController];
        }else if([text isEqualToString:@"设置"])
        {
        
        }else if([text isEqualToString:@"退出"]){
            [self logout];
            return;
        }
        [menuController setRootController:nav animated:YES];
    }
    
}

-(void)logout
{
    [[Renren sharedRenren] logout];
    
    LoginViewController  *controller = (LoginViewController*)((AppDelegate*)[UIApplication sharedApplication].delegate).loginController;
    [[UIApplication sharedApplication].keyWindow setRootViewController:controller];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
    if ((!selectIndexPath || selectIndexPath.row != self.selectIndex) && self.selectIndex >= 0) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.selectIndex inSection:0];
        [self.tableView selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    UserInfo *userInfo = [Renren sharedRenren].userInfo;
    if (userInfo) {
        [_menuHeader.imageView setImageWithURL:[NSURL URLWithString:userInfo.headurl] placeholderImage:[IconImage emptyPhotoImage]];
        _menuHeader.textLabel.text = userInfo.name;
    }else{
        __weak MenuViewController *blockSelf = self;
        [[Renren sharedRenren] getUserInfo:[Renren sharedRenren].uid withCompletionBlock:^(UserInfo *userInfo) {
            [blockSelf.menuHeader.imageView setImageWithURL:[NSURL URLWithString:userInfo.headurl] placeholderImage:[IconImage emptyPhotoImage]];
            blockSelf.menuHeader.textLabel.text = userInfo.name;
        } failedBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
    
}

@end
