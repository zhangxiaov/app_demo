//
//  UITouchScrollView.m
//  app_demo
//
//  Created by 张新伟 on 15/10/4.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "UITouchScrollView.h"

@implementation UITouchScrollView

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    
    if (!self.dragging) {
        //run at ios5 ,no effect;
        [self.nextResponder touchesEnded: touches withEvent:event];
        if (_touchesdelegate!=nil) {
            
            [_touchesdelegate scrollViewTouchesEnded:touches withEvent:event whichView:self];
        }
        NSLog(@"UITouchScrollView nextResponder touchesEnded");
    }
    [super touchesEnded: touches withEvent: event];
    
}
@end
