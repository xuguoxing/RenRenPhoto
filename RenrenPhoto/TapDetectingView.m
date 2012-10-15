//
//  TapDetectingView.m
//  NeteaseLottery
//
//  Created by xuguoxing on 12-9-26.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import "TapDetectingView.h"

@implementation TapDetectingView
@synthesize tapDelegate;
- (id)init {
	if ((self = [super init])) {
		self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
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

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
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
    if ([tapDelegate respondsToSelector:@selector(view:singleTapDetected:)]) {
        [tapDelegate view:self singleTapDetected:[sender locationInView:self]];
    }
}
-(void)handleDoubleTap:(UIGestureRecognizer *)sender{
    if ([tapDelegate respondsToSelector:@selector(view:doubleTapDetected:)]) {
        [tapDelegate view:self doubleTapDetected:[sender locationInView:self]];
    }
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[super touchesBegan:touches withEvent:event];
    NSLog(@"TapView touchBegan touches:%@ times:%f event:%@",[touches anyObject],((UITouch*)[touches anyObject]).timestamp,event);
    //[self.nextResponder touchesBegan:touches withEvent:event];
    //NSLog(@"%@",[NSThread callStackSymbols]);
    //[UIApplication logStackTrace];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[super touchesMoved:touches withEvent:event];
    NSLog(@"TapView touchMove touches:%@ times:%f event:%@",[touches anyObject],((UITouch*)[touches anyObject]).timestamp,event);
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[super touchesCancelled:touches withEvent:event];
    NSLog(@"TapView touchCancel touches:%@ times:%f event:%@",[touches anyObject],((UITouch*)[touches anyObject]).timestamp,event);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[super touchesEnded:touches withEvent:event];
    NSLog(@"TapView touchEnded touches:%@ times:%f event:%@",[touches anyObject],((UITouch*)[touches anyObject]).timestamp,event);
}
*/


/*-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touch.tapCount == 1) {
        [self performSelector:@selector(handleSingleTap:) withObject:[NSValue valueWithCGPoint:touchPoint] afterDelay:0.3];
    }else if(touch.tapCount == 2)
    {
        [self handleDoubleTap:[NSValue valueWithCGPoint:touchPoint]];
    }
}

-(void)handleSingleTap:(NSValue*)pointValue
{
    CGPoint touchPoint = [pointValue CGPointValue];
    //...
}

-(void)handleDoubleTap:(NSValue*)pointValue
{
    CGPoint touchPoint = [pointValue CGPointValue];
    //...
}*/



@end
