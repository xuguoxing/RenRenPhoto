//
//  AlbumCell.h
//  RenrenPhoto
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionViewCell.h"
@interface PSAlbumCell : PSCollectionViewCell

-(void)setAlbumName:(NSString*)name photoCount:(NSInteger)count coverUrl:(NSString*)url;

@end
