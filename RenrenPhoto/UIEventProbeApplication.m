//
//  UIEventProbeApplication.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-8.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "UIEventProbeApplication.h"

@implementation UIEventProbeApplication

//http://nacho4d-nacho4d.blogspot.com/2012/01/catching-keyboard-events-in-ios.html
//https://github.com/kennytm/iphone-private-frameworks/blob/master/GraphicsServices/GSEvent.h

-(void)sendEvent:(UIEvent *)event
{
    //NSLog(@"Application sendEvent:%@",event);
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
            NSLog(@"Application sendEvent:eventType:%d eventSubType:%d xOffset:%f yOffset:%f",eventType,eventSubType,xOffset,yOffset);
        }
    }

    [super sendEvent:event];
}

@end
