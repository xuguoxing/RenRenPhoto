//
//  ZoomingScrollView.m
//  NeteaseLottery
//
//  Created by xuguoxing on 12-9-26.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import "ZoomingScrollView.h"

@implementation ZoomingScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tapView = [[TapDetectingView alloc]initWithFrame:self.bounds];
        _tapView.tapDelegate = self;
        _tapView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _tapView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tapView];
        
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		_spinner.hidesWhenStopped = YES;
		_spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		[self addSubview:_spinner];

        
        _imageView = [[TapDetectingImageView alloc]initWithFrame:CGRectZero];
        _imageView.tapDelegate = self;
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_imageView];
        
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return self;
}
-(void)setImage:(UIImage*)image{
    _imageView.image = image;
    _imageView.hidden = NO;
    
    CGRect imageViewFrame;
    imageViewFrame.origin = CGPointZero;
    imageViewFrame.size = image.size;
    _imageView.frame = imageViewFrame;
    self.contentSize = imageViewFrame.size;
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setNeedsDisplay];
}

#pragma mark - Setup

- (void)setMaxMinZoomScalesForCurrentBounds {
	
	// Reset
	self.maximumZoomScale = 1;
	self.minimumZoomScale = 1;
	self.zoomScale = 1;
	
	// Bail
	if (_imageView.image == nil) return;
	
	// Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _imageView.frame.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
	
	// If image is smaller than the screen then ensure we show it at
	// min scale of 1
	if (xScale > 1 && yScale > 1) {
		minScale = 1.0;
	}
    
	// Calculate Max
	CGFloat maxScale = 2.0; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
	/*if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}*/
	
	// Set
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
	
	// Reset position
	_imageView.frame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);    
}

#pragma mark - Layout

- (void)layoutSubviews {
	
	// Update tap view frame
	_tapView.frame = self.bounds;
	
	// Spinner
	if (!_spinner.hidden) _spinner.center = CGPointMake(floorf(self.bounds.size.width/2.0),
                                                        floorf(self.bounds.size.height/2.0));
	// Super
	[super layoutSubviews];
	
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
	} else {
        frameToCenter.origin.x = 0;
	}
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
	} else {
        frameToCenter.origin.y = 0;
	}
    
	// Center
	if (!CGRectEqualToRect(_imageView.frame, frameToCenter))
		_imageView.frame = frameToCenter;	
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}

#pragma mark - Tap Detection

- (void)handleSingleTap:(CGPoint)touchPoint {
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self removeFromSuperview];
    } completion:^(BOOL finished){}];
}

- (void)handleDoubleTap:(CGPoint)touchPoint {
	
	// Zoom
	if (self.zoomScale == self.maximumZoomScale) {
		
		// Zoom out
		[self setZoomScale:self.minimumZoomScale animated:YES];
		
	} else {
		
		// Zoom in
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
		
	}	
}

// Image View
-(void)imageView:(UIImageView *)imageView singleTapDetected:(CGPoint)touchPoint
{
    [self handleSingleTap:touchPoint];
}

-(void)imageView:(UIImageView *)imageView doubleTapDetected:(CGPoint)touchPoint
{
    [self handleDoubleTap:touchPoint];
}

// Background View
- (void)view:(UIView *)view singleTapDetected:(CGPoint)touchPoint {
    [self handleSingleTap:touchPoint];
}
- (void)view:(UIView *)view doubleTapDetected:(CGPoint)touchPoint {
    [self handleDoubleTap:touchPoint];
}

@end
