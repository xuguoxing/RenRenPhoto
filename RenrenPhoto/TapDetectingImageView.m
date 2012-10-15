//
//  TapDetectingImageView.m
//  NeteaseLottery
//
//  Created by xuguoxing on 12-9-26.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import "TapDetectingImageView.h"
#import "UIApplication+LogStackTrace.h"
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
        singleTapGesture.delaysTouchesEnded = NO;
        [self addGestureRecognizer:singleTapGesture];
        
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTapGesture];
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }
    return self;
}

/*-(id)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.numberOfTouchesRequired  = 1;
        NSLog(@"single: delaysTouchesEnded:%d",singleTapGesture.delaysTouchesEnded);
        //singleTapGesture.delaysTouchesEnded = NO;
        [self addGestureRecognizer:singleTapGesture];
        
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.numberOfTouchesRequired = 1;
        NSLog(@"double: delaysTouchesEnded:%d",doubleTapGesture.delaysTouchesEnded);
        //doubleTapGesture.delaysTouchesEnded = NO;
        [self addGestureRecognizer:doubleTapGesture];
        
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }
    return self;
}*/

-(void)setImage:(UIImage *)image
{
    [super setImage:image];
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

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"touchBegan touches:%p tapCount:%d times:%f event:%p",[touches anyObject],touch.tapCount,((UITouch*)[touches anyObject]).timestamp,event);
    NSLog(@"%@",[NSThread callStackSymbols]);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"touchMove touches:%p tapCount:%d times:%f event:%p",[touches anyObject],touch.tapCount,((UITouch*)[touches anyObject]).timestamp,event);
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"touchCancelled touches:%p tapCount:%d times:%f event:%p",[touches anyObject],touch.tapCount,((UITouch*)[touches anyObject]).timestamp,event);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"touchEnded touches:%p tapCount:%d times:%f event:%p",[touches anyObject],touch.tapCount,((UITouch*)[touches anyObject]).timestamp,event);

}*/

@end
