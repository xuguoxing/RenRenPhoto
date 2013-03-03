//
//  PhotoInfo.m
//  RenrenPhoto
//
//  Created by  on 12-9-11.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "PhotoInfo.h"
#import "SDWebImageManager.h"

@implementation PhotoInfo

-(id)initWithDictionary:(NSDictionary*)photoInfo
{
    if (self = [super init]) {
        _pid = [photoInfo objectForKey:@"pid"];
        _aid = [photoInfo objectForKey:@"aid"];
        _uid = [photoInfo objectForKey:@"uid"];
        _tinyUrl = [photoInfo objectForKey:@"url_tiny"];
        _headUrl = [photoInfo objectForKey:@"url_head"];
        _mainUrl = [photoInfo objectForKey:@"url_main"];
        _largeUrl = [photoInfo objectForKey:@"url_large"];
        _caption = [photoInfo objectForKey:@"caption"];
        _time = [photoInfo objectForKey:@"time"];
        _viewCount = [photoInfo objectForKey:@"view_count"];
        _commentCount = [photoInfo objectForKey:@"comment_count"];
        NSDictionary *souce = [photoInfo objectForKey:@"source"];
        if (souce) {
            _sourceText = [souce objectForKey:@"text"];
            _sourceUrl = [souce objectForKey:@"href"];
        }
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@-%@-%@-%@",_uid,_aid,_pid,_largeUrl];
}

#pragma mark MWPhoto Protocol Methods

- (UIImage *)underlyingImage {
    return _largeImage;
}

- (void)loadUnderlyingImageAndNotify {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    //_loadingInProgress = YES;
    if (self.underlyingImage) {
        [self imageLoadingComplete];
    } else {
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.largeUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (image) {
                _largeImage = image;
                [self imageLoadingComplete];
            }else{
                [self imageLoadingComplete];
            }
        }];
        
    }
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
    _largeImage = nil;
}

- (void)imageLoadingComplete {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Complete so notify
    //_loadingInProgress = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

@end
