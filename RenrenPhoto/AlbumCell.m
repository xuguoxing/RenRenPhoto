//
//  AlbumCell.m
//  RenrenPhoto
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13.0, 13.0, 60.0, 60.0)];
        [self.contentView addSubview:coverImageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
