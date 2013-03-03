//
//  AlbumsViewController.h
//  RenrenPhoto
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "Renren.h"
#import "PSCollectionView.h"
@interface UserAlbumsController : UIViewController<PSCollectionViewDataSource,PSCollectionViewDelegate>

@property (nonatomic) NSString *userId;
//140*162

//  7
// 6   6


@end
