//
//  ImagePreview.m
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-25.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import "ImagePreview.h"
#import "UIImageView+WebCache.h"
#import "IconImage.h"

@implementation ImagePreview
{
    UIImage *_image;
    CGRect _startFrame;
    UIView *_backView;
    MWTapDetectingImageView *_photoView;
}
-(id)initWithImage:(UIImage*)image startFrame:(CGRect)startFrame
{
    if (self = [super init]) {
        _image = image;
        _startFrame = startFrame;
    }
    return self;
}

-(void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _backView = [[UIView alloc]initWithFrame:window.bounds];
    _backView.backgroundColor = [UIColor clearColor];
    
    CGSize imageSize = _image.size;
    if (imageSize.width > imageSize.height) {
        CGFloat f = imageSize.height / _startFrame.size.height;
        CGFloat newWidth = imageSize.width / f;
        _startFrame.origin.x -= (newWidth - _startFrame.size.width)/2.0;
        _startFrame.size.width = newWidth;
    }else{
        CGFloat f = imageSize.width / _startFrame.size.width;
        CGFloat newHeight = imageSize.height / f;
        _startFrame.origin.y -= (newHeight - _startFrame.size.height)/2.0;
        _startFrame.size.height = newHeight;
    }
    
    _photoView = [[MWTapDetectingImageView alloc]initWithFrame:_startFrame];
    _photoView.contentMode = UIViewContentModeScaleAspectFit;
    _photoView.clipsToBounds = YES;
    [_photoView setImage:_image];
    _photoView.tapDelegate = self.delegate;
    [_backView addSubview:_photoView];
    [window addSubview:_backView];

    [UIView animateWithDuration:0.1 animations:^{
        [_photoView setImage:_image];        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            _photoView.frame = _backView.frame;
            _backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
        }];
    }];
}

-(void)hide
{
    [UIView animateWithDuration:0.4 animations:^{
        _photoView.frame = _startFrame;
        _backView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _photoView.image = nil;
            [_backView removeFromSuperview];
        }];
    }];
}


@end
