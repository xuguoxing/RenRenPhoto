//
//  PhotosViewController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-9-16.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoInfo.h"
#import "UIImageView+WebCache.h"
#import "PSPhotoViewCell.h"
@interface PhotosViewController ()

@end

@implementation PhotosViewController
@synthesize album = _album;
@synthesize photosArray = _photosArray;
@synthesize collectionView = _collectionView;
-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)setPhotosArray:(NSArray *)photosArray
{
    _photosArray = photosArray;
    _photosSizeArray = [NSMutableArray arrayWithCapacity:photosArray.count];
    for (int i =0 ; i< photosArray.count; i++) {
        [_photosSizeArray addObject:NSStringFromCGSize(CGSizeZero)];
    }
    //开始请求图片
    int index = 0;
    __weak PhotosViewController *blockSelf = self;
    for (PhotoInfo *photo in photosArray) {
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:photo.mainUrl] delegate:[NSNull null] options:0 success:^(UIImage *image,BOOL cache){
            //NSLog(@"index:%d size:%@",index,NSStringFromCGSize(image.size));
            [_photosSizeArray replaceObjectAtIndex:index withObject:NSStringFromCGSize(image.size)];
            [blockSelf.collectionView reloadData];
        } failure:^(NSError *error){
            NSLog(@"index:%d error:%@",index,error);
        }];
        index ++;
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
    //return 0;
    return [self.photosArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"PhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    PhotoInfo *photo = [self.photosArray objectAtIndex:indexPath.row];
   /* UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.largeUrl]]];*/
    //[cell.imageView setImage:image];
    [cell.imageView setImageWithURL:[NSURL URLWithString:photo.largeUrl]];
    cell.textLabel.text = photo.caption;
    cell.detailTextLabel.text = photo.sourceText;
    
    return cell;
}

#pragma mark -
#pragma mark PSCollectionViewDataSource/Delegate

-(NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView
{
    return [self.photosArray count];
}
-(CGFloat)heightForViewAtIndex:(NSInteger)index
{
    CGSize size = CGSizeFromString([_photosSizeArray objectAtIndex:index]);
    if (size.height == 0.0 ||size.width == 0) {
        return 0.0;
    }
    CGFloat height = floorf(_collectionView.colWidth*size.height/size.width);
    NSLog(@"index:%d colWith:%f imageWidth:%f imageHeight:%f result colHeight:%f",index,_collectionView.colWidth,size.width,size.height,height);
    //return _collectionView.colWidth*size.height/size.width;
    return height;
    
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
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"相册:%@",self.album.name];
   /* _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 310, 45)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = [NSString stringWithFormat:@"%@",self.album.name];
    [self.view addSubview:_titleLabel];*/
    
    /*_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:
                  UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView reloadData];*/
    
    
    _collectionView = [[PSCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _collectionView.collectionViewDataSource = self;
    _collectionView.collectionViewDelegate = self;
    _collectionView.numColsPortrait = 2;
    _collectionView.numColsLandscape = 3;
    [self.view addSubview:_collectionView];
    [_collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
