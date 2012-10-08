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
@interface AlbumsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UserInfo *_owner;
    NSArray *_albumsArray;
    
    UILabel *_titleLabel;
    UITableView *_tableView;
}
@property (nonatomic) UserInfo *owner;
@property (nonatomic) NSArray *albumsArray;
@end
