//
//  TapDetectingImageView.h
//  NeteaseLottery
//
//  Created by xuguoxing on 12-9-26.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapDetectingImageViewDelegate <NSObject>
@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(CGPoint)touchPoint;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(CGPoint)touchPoint;
@end


@interface TapDetectingImageView : UIImageView
{
    __unsafe_unretained id <TapDetectingImageViewDelegate> tapDelegate;
}
@property (nonatomic, unsafe_unretained) id <TapDetectingImageViewDelegate> tapDelegate;
@end
