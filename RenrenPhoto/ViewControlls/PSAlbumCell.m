//
//  AlbumCell.m
//  RenrenPhoto
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "PSAlbumCell.h"
#import "IconImage.h"
#import "CommonColor.h"
#import "UIImageView+WebCache.h"

@implementation PSAlbumCell
{
    UIImageView *coverImageView;
    UILabel *titleLabel;    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        imageView.image = [IconImage albumBgImage];
        [self addSubview:imageView];
        
        coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-125)/2, (CGRectGetWidth(self.frame)-125)/2, 125, 125)];
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        coverImageView.clipsToBounds = YES;
        coverImageView.image = [IconImage emptyPhotoImage];
        [self addSubview:coverImageView];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(coverImageView.frame), CGRectGetMaxY(coverImageView.frame), CGRectGetWidth(coverImageView.frame), 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [CommonColor blackTextColor];
        [self addSubview:titleLabel];
    }
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    coverImageView.image = nil;
    titleLabel.text = nil;
}


-(void)setAlbumName:(NSString*)name photoCount:(NSInteger)count coverUrl:(NSString*)url
{
    titleLabel.text = [NSString stringWithFormat:@"%@(%d)",name,count];
    [coverImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[IconImage emptyPhotoImage]];
    
}

/*-(void)fillViewWithObject:(id)object
{
    [super fillViewWithObject:object];
    if ([object isKindOfClass:[NSString class]]) {
        __weak NSString *urlString = (NSString*)object;
        // [_imageView setImageWithURL:[NSURL URLWithString:urlString]];
        [_imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageProgressiveDownload];
    }
}*/


@end
