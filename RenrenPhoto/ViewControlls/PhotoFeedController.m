//
//  PhotoFeedController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-19.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "PhotoFeedController.h"
#import "Renren.h"
#import "SVProgressHUD.h"
#import "UserAlbumsController.h"
#import "CommonUtils.h"
#import "UIPullToReloadTableView.h"
#import "UIImageView+WebCache.h"
#import "IconImage.h"
#import "ImagePreview.h"

@interface PhotoFeedController ()
@property (nonatomic) UIPullToReloadTableView *tableView;
@property (nonatomic) NSMutableArray *feedsArray;

@property (nonatomic) ImagePreview *imagePreview;
@end

@implementation PhotoFeedController

-(id)init
{
    if (self = [super init]) {
        self.title = @"相册动态";
        self.feedsArray = [NSMutableArray array];
    }
    return self;
}


#pragma mark UITableViewDelegate/DataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feedsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 44.0;
    PhotoFeed *feed = [self.feedsArray objectAtIndex:indexPath.row];
    return [PhotoFeedCell heightForPhotoFeed:feed];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"FeedCell";
    PhotoFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[PhotoFeedCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
    PhotoFeed *feed = [self.feedsArray objectAtIndex:indexPath.row];
    [cell setPhotoFeed:feed];
    cell.tag = indexPath.row;
    return cell;
}

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoFeed *feed = [self.feedsArray objectAtIndex:indexPath.row];
    UserAlbumsController *controller = [[UserAlbumsController alloc]init];
    controller.userId = [feed.uId stringValue];
    [self.navigationController pushViewController:controller animated:YES];
}*/

-(void)headerTouched:(PhotoFeedCell *)cell
{
    NSInteger index = cell.tag;
    if (index < self.feedsArray.count) {
        PhotoFeed *feed = [self.feedsArray objectAtIndex:index];
        UserAlbumsController *controller = [[UserAlbumsController alloc]init];
        controller.userId = [feed.uId stringValue];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)photoTouched:(PhotoFeedCell *)cell
{
    NSInteger index = cell.tag;
    if (index < self.feedsArray.count) {
        NSLog(@"photoTouched");
        UIImageView *imageView = cell.photoImageView;
        CGRect imageFrame = [imageView convertRect:imageView.bounds toView:nil];
        UIImage *image = imageView.image;
        self.imagePreview = [[ImagePreview alloc]initWithImage:image startFrame:imageFrame];
        self.imagePreview.delegate = self;
        [self.imagePreview show];
    }
}

-(void)pullDownToReloadAction
{
    [self reloadData];
}

-(void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch
{
    [self.imagePreview hide];
    self.imagePreview = nil;

}

#pragma mark 加载数据
-(void)reloadData
{
    __weak PhotoFeedController *blockSelf = self;
    [[Renren sharedRenren] getPhotoFeedsWithPage:1 completion:^(NSArray *feedsArray) {
        [blockSelf.feedsArray removeAllObjects];
        [blockSelf.feedsArray addObjectsFromArray:feedsArray];
        [blockSelf.tableView reloadData];
        [blockSelf.tableView pullDownToReloadActionFinished];
    } failed:^(NSError *error) {
        [blockSelf.tableView pullDownToReloadActionFinished];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = labelForNavTitle(self.title);
    
    UIPullToReloadTableView *tableView = [[UIPullToReloadTableView alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-10) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self reloadData];
    
	// Do any additional setup after loading the view.
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
