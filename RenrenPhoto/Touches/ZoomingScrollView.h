//
//  ZoomingScrollView.h
//  NeteaseLottery
//
//  Created by xuguoxing on 12-9-26.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDetectingImageView.h"
#import "TapDetectingView.h"
@interface ZoomingScrollView : UIScrollView<UIScrollViewDelegate,TapDetectingImageViewDelegate,TapDetectingViewDelegate>
{
    TapDetectingView *_tapView;
    TapDetectingImageView *_imageView;
    UIActivityIndicatorView *_spinner;
}

-(void)setImage:(UIImage*)image;

@end
