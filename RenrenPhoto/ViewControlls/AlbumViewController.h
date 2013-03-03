//
//  PhotosViewController.h
//  RenrenPhoto
//
//  Created by xuguoxing on 12-9-16.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumInfo.h"
#import "PSCollectionView.h"
@interface AlbumViewController : UIViewController<PSCollectionViewDataSource,PSCollectionViewDelegate>
/*{
    AlbumInfo *_album;
    NSArray *_photosArray;
    NSMutableArray *_photosSizeArray;
    
    UILabel *_titleLabel;
    UITableView *_tableView;
    PSCollectionView *_collectionView;
}*/
@property (nonatomic) AlbumInfo *album;

@end
