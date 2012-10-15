//
//  UIEventProbeWindow.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-9.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "UIEventProbeWindow.h"
#import "UIApplication+LogStackTrace.h"
@implementation UIEventProbeWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)sendEvent:(UIEvent *)event
{
    //NSLog(@"Window sendEvent:%@",event);
    if ([event respondsToSelector:@selector(_gsEvent)]) {
        
        // Key events come in form of UIInternalEvents.
        // They contain a GSEvent object which contains
        // a GSEventRecord among other things
#define GSEVENT_TYPE 2
#define GSEVENT_SUBTYPE 3
#define GSEVENT_X_OFFSET 6
#define GSEVENT_Y_OFFSET 7
#define GSEVENT_FLAGS 12
#define GSEVENTKEY_KEYCODE 15
#define GSEVENT_TYPE_KEYUP 11
        int *eventMem;
        eventMem = (int *)objc_unretainedPointer([event performSelector:@selector(_gsEvent)]);
        if (eventMem) {
            
            // So far we got a GSEvent :)
            int eventType = eventMem[GSEVENT_TYPE];
            int eventSubType = eventMem[GSEVENT_SUBTYPE];
            float xOffset =  *((float*)(eventMem + GSEVENT_X_OFFSET));
            float yOffset =  *((float*)(eventMem + GSEVENT_Y_OFFSET));
            NSLog(@"Window sendEvent:eventType:%d eventSubType:%d xOffset:%f yOffset:%f",eventType,eventSubType,xOffset,yOffset);
        }
    }
    
    [super sendEvent:event];
}

/*-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"Window Hitest:point:%@ event:%@",NSStringFromCGPoint(point),event);
    if ([event respondsToSelector:@selector(_gsEvent)]) {
        
        // Key events come in form of UIInternalEvents.
        // They contain a GSEvent object which contains
        // a GSEventRecord among other things
#define GSEVENT_TYPE 2
#define GSEVENT_SUBTYPE 3
#define GSEVENT_X_OFFSET 6
#define GSEVENT_Y_OFFSET 7
#define GSEVENT_FLAGS 12
#define GSEVENTKEY_KEYCODE 15
#define GSEVENT_TYPE_KEYUP 11
        int *eventMem;
        eventMem = (int *)objc_unretainedPointer([event performSelector:@selector(_gsEvent)]);
        if (eventMem) {
            
            // So far we got a GSEvent :)
            int eventType = eventMem[GSEVENT_TYPE];
            int eventSubType = eventMem[GSEVENT_SUBTYPE];
            float xOffset =  *((float*)(eventMem + GSEVENT_X_OFFSET));
            float yOffset =  *((float*)(eventMem + GSEVENT_Y_OFFSET));
            NSLog(@"Window Hitest:eventType:%d eventSubType:%d xOffset:%f yOffset:%f",eventType,eventSubType,xOffset,yOffset);
        }
    }
    //[UIApplication logStackTrace];
    return [super hitTest:point withEvent:event];
}*/

@end
