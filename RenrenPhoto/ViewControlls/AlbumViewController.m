//
//  PhotosViewController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-9-16.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "AlbumViewController.h"
#import "PhotoInfo.h"
#import "UIImageView+WebCache.h"
#import "PSPhotoViewCell.h"
#import "PhotoBrowserController.h"
#import "Renren.h"
#import "SVProgressHUD.h"
#import "UIBarButtonItem+Custom.h"
#import "CommonUtils.h"

@interface AlbumViewController ()

@property (nonatomic) NSMutableArray *photosArray;
@property (nonatomic) PSCollectionView *collectionView;

@end

@implementation AlbumViewController

-(id)init
{
    if (self = [super init]) {
        self.photosArray = [NSMutableArray array];
    }
    return self;
}


#pragma mark -
#pragma mark PSCollectionViewDataSource/Delegate

-(NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView
{
    return [self.photosArray count];
}
-(CGFloat)heightForViewAtIndex:(NSInteger)index
{
    return 100.0f;
    
}
-(PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index
{
    PSPhotoViewCell *cell = (PSPhotoViewCell*)[collectionView dequeueReusableView];
    if (cell == nil) {
        cell = [[PSPhotoViewCell alloc]init];
    }
    PhotoInfo *photo = [self.photosArray objectAtIndex:index];
    [cell fillViewWithObject:photo.mainUrl];
    return cell;
}

-(void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index
{
    NSLog(@"click index:%d",index);
    PhotoBrowserController *pbController = [[PhotoBrowserController alloc]initWithPhotos:self.photosArray];
    pbController.displayActionButton = YES;
    [pbController setInitialPageIndex:index];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pbController];
    [self presentModalViewController:nav animated:YES];
}


#pragma mark 加载数据
-(void)reloadData
{
    if (!self.album) {
        return;
    }
    __weak AlbumViewController *blockSelf = self;
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeGradient];
    [[Renren sharedRenren] getPhotosUser:[self.album.uid stringValue] album:[self.album.aid stringValue] withCompletionBlock:^(NSArray *photosArray){
        [SVProgressHUD dismiss];
        [blockSelf.photosArray removeAllObjects];
        [blockSelf.photosArray addObjectsFromArray:photosArray];
        [blockSelf.collectionView reloadData];
    } failedBlock:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"getPhotos:%@",error);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithViewController:self];
    self.navigationItem.titleView = labelForNavTitle(self.album.name);

    _collectionView = [[PSCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _collectionView.collectionViewDataSource = self;
    _collectionView.collectionViewDelegate = self;
    _collectionView.numColsPortrait = 3;
    _collectionView.numColsLandscape = 4;
    _collectionView.topMargin = 5.0;
    _collectionView.bottomMargin = 5.0;
    _collectionView.leftMargin = 5.0;
    _collectionView.rightMargin = 5.0;
    _collectionView.xMargin = 5.0;
    _collectionView.yMargin = 5.0;
    
    [self.view addSubview:_collectionView];
    
    [self reloadData];
    //[_collectionView reloadData];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    //present/dismiss viewcontroller in order to activate rotating.
    UIViewController *mVC = [[UIViewController alloc] init];
    [self presentModalViewController:mVC animated:NO];
    [self dismissModalViewControllerAnimated:NO];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (self.presentedViewController) {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }else{
        return toInterfaceOrientation == UIInterfaceOrientationPortrait;
    }
        
    //return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    //return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
