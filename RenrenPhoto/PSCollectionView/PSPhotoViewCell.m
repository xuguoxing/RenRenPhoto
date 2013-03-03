//
//  PSPhotoViewCell.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-9-17.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "PSPhotoViewCell.h"
#import "UIImageView+WebCache.h"
#import "IconImage.h"
@implementation PSPhotoViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageView];
    }
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    _imageView.image = nil;
}

-(void)fillViewWithObject:(id)object
{
    [super fillViewWithObject:object];
    if ([object isKindOfClass:[NSString class]]) {
        __weak NSString *urlString = (NSString*)object;
        [_imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[IconImage emptyPhotoImage]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
