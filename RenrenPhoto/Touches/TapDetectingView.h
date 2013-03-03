//
//  TapDetectingView.h
//  NeteaseLottery
//
//  Created by xuguoxing on 12-9-26.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapDetectingViewDelegate <NSObject>
@optional
- (void)view:(UIView *)view singleTapDetected:(CGPoint)touchPoint;
- (void)view:(UIView *)view doubleTapDetected:(CGPoint)touchPoint;

@end

@interface TapDetectingView : UIView
{
    __unsafe_unretained id <TapDetectingViewDelegate> tapDelegate;
}
@property (nonatomic, unsafe_unretained) id <TapDetectingViewDelegate> tapDelegate;
@end
