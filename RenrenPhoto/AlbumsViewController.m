//
//  AlbumsViewController.m
//  RenrenPhoto
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "AlbumsViewController.h"
#import "PhotosViewController.h"
@interface AlbumsViewController ()

@end

@implementation AlbumsViewController
@synthesize owner = _owner;
@synthesize albumsArray = _albumsArray;

-(id)init
{
    if (self = [super init]) {
        
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
    //return 0;
    return [self.albumsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"AlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    AlbumInfo *album = [self.albumsArray objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:album.url]]];
    [cell.imageView setImage:image];
    cell.textLabel.text = album.name;
    cell.detailTextLabel.text = album.description;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    AlbumInfo *album = [self.albumsArray objectAtIndex:row];
    [[Renren sharedRenren] getPhotosUser:[self.owner.uid stringValue] album:[album.aid stringValue] withCompletionBlock:^(NSArray *photosArray){
        PhotosViewController *controller = [[PhotosViewController alloc]init];
        controller.album = [self.albumsArray objectAtIndex:row];
        controller.photosArray =  [NSArray arrayWithArray:photosArray];
        [self.navigationController pushViewController:controller animated:YES];
        
    } failedBlock:^(NSError *error){
        NSLog(@"getPhotos:%@",error);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@的相册",self.owner.name];

    /*_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 310, 45)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = [NSString stringWithFormat:@"%@的相册",self.owner.name];
    [self.view addSubview:_titleLabel];*/
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView reloadData];
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
