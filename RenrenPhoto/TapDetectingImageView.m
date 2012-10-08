//
//  TapDetectingImageView.m
//  NeteaseLottery
//
//  Created by xuguoxing on 12-9-26.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import "TapDetectingImageView.h"

@implementation TapDetectingImageView
@synthesize tapDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.numberOfTouchesRequired  = 1;
        [self addGestureRecognizer:singleTapGesture];
        
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTapGesture];
        
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }
    return self;
}

-(id)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.numberOfTouchesRequired  = 1;
        [self addGestureRecognizer:singleTapGesture];
        
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTapGesture];
        
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }
    return self;
}

-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    if ([tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)]) {
        [tapDelegate imageView:self singleTapDetected:[sender locationInView:self]];
    }
}
-(void)handleDoubleTap:(UIGestureRecognizer *)sender{
    if ([tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)]) {
        [tapDelegate imageView:self doubleTapDetected:[sender locationInView:self]];
    }
}

@end
