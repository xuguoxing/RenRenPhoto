//
//  ImagePreview.h
//  RenrenPhoto
//
//  Created by xuguoxing on 13-2-25.
//  Copyright (c) 2013年 winddisk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWTapDetectingImageView.h"
@interface ImagePreview : NSObject

@property (nonatomic,assign) id<MWTapDetectingImageViewDelegate> delegate;

-(id)initWithImage:(UIImage*)image startFrame:(CGRect)startFrame;
-(void)show;
-(void)hide;

@end
