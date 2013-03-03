//
//  AlbumsViewController.m
//  RenrenPhoto
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "UserAlbumsController.h"
#import "AlbumViewController.h"
#import "PSAlbumCell.h"
#import "AlbumViewController.h"
#import "SVProgressHUD.h"
#import "CommonUtils.h"
#import "UIBarButtonItem+Custom.h"
#import "UIPullToReloadCollectionView.h"
@interface UserAlbumsController ()
@property (nonatomic) UIPullToReloadCollectionView *collectionView;
@property (nonatomic) NSMutableArray *albumsArray;
@end

@implementation UserAlbumsController


-(id)init
{
    if (self = [super init]) {
        self.albumsArray = [NSMutableArray array];
    }
    return self;
}


#pragma mark -
#pragma mark PSCollectionViewDataSource/Delegate

-(NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView
{
    return [self.albumsArray count];
}
-(CGFloat)heightForViewAtIndex:(NSInteger)index
{
    return 162.0;
}
-(PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index
{
    PSAlbumCell *cell = (PSAlbumCell*)[collectionView dequeueReusableView];
    if (cell == nil) {
        cell = [[PSAlbumCell alloc]initWithFrame:CGRectMake(0, 0, 140, 162)];
    }
    AlbumInfo *album = [self.albumsArray objectAtIndex:index];
    [cell setAlbumName:album.name photoCount:[album.size integerValue] coverUrl:album.url];
    return cell;
}

-(void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index
{
    AlbumViewController *albumController = [[AlbumViewController alloc]init];
    albumController.album = [self.albumsArray objectAtIndex:index];
    [self.navigationController pushViewController:albumController animated:YES];
}

-(void)pullDownToReloadAction
{
    [self reloadData];
}

#pragma mark 加载数据
-(void)reloadData
{
    if (!self.userId) {
        return;
    }
    __weak UserAlbumsController *blockSelf = self;
    [[Renren sharedRenren] getUserAlbums:self.userId withCompletionBlock:^(NSArray *albumsArray) {
        [blockSelf.collectionView pullDownToReloadActionFinished];
        [blockSelf.albumsArray removeAllObjects];
        [blockSelf.albumsArray addObjectsFromArray:albumsArray];
        [[Renren sharedRenren] saveUserAlbums:blockSelf.albumsArray forId:blockSelf.userId];
        [blockSelf.collectionView reloadData];
    } failedBlock:^(NSError *error) {
        [blockSelf.collectionView pullDownToReloadActionFinished];
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.userId isEqualToString:[Renren sharedRenren].uid]) {
        self.navigationItem.titleView = labelForNavTitle(@"我的相册");
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithViewController:self];
        UserInfo *userInfo = [[Renren sharedRenren] getUserInfoById:self.userId];
        if (userInfo) {
            self.navigationItem.titleView = labelForNavTitle([NSString stringWithFormat:@"%@的相册",userInfo.name]);
        }else{
            self.navigationItem.titleView = labelForNavTitle(@"相册");
            __weak UserAlbumsController *blockSelf = self;
            [[Renren sharedRenren] getUserInfos:@[self.userId] WithCompletion:^(NSArray *userInfos) {
                if (userInfos.count>0) {
                    UserInfo *userInfo = [userInfos objectAtIndex:0];
                    if (blockSelf) {
                        blockSelf.navigationItem.titleView = labelForNavTitle([NSString stringWithFormat:@"%@的相册",userInfo.name]);
                        [[Renren sharedRenren] saveUserInfo:userInfo];
                    }
                }
            } failed:^(NSError *error) {
                
            }];
        }
    }
    
    self.title = [NSString stringWithFormat:@"%@的相册",self.userId];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _collectionView = [[UIPullToReloadCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _collectionView.collectionViewDataSource = self;
    _collectionView.collectionViewDelegate = self;
    _collectionView.numColsPortrait = 2;
    _collectionView.numColsLandscape = 3;
    
    _collectionView.leftMargin = 10.0f;
    _collectionView.rightMargin = 10.0f;
    _collectionView.xMargin = 20.0f;
    _collectionView.yMargin = 12.0f;
    _collectionView.topMargin = 10.0f;
    _collectionView.bottomMargin = 10.0f;
    [self.view addSubview:_collectionView];
    
    [self.albumsArray removeAllObjects];
    [self.albumsArray addObjectsFromArray:[[Renren sharedRenren] getUserAlbumsById:self.userId]];
    if (self.albumsArray.count > 0) {
        [_collectionView reloadData];
    }else{
        [_collectionView autoPullDownToRefresh];        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    //present/dismiss viewcontroller in order to activate rotating.
    UIViewController *mVC = [[UIViewController alloc] init];
    [self presentModalViewController:mVC animated:NO];
    [self dismissModalViewControllerAnimated:NO];*/
    //[UIViewController attemptRotationToDeviceOrientation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
