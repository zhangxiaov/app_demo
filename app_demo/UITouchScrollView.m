//
//  UITouchScrollView.m
//  app_demo
//
//  Created by 张新伟 on 15/10/4.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "UITouchScrollView.h"
#import "ContentViewController.h"
#import "AppConfig.h"

@interface UITouchScrollView ()
@property (nonatomic, strong) UIViewController *vc;
@end

@implementation UITouchScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.touchTimer = [touch timestamp];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    
    UITouch *touch = [touches anyObject];
    self.touchTimer = [touch timestamp] - self.touchTimer;
    
    NSUInteger tapCount = [touch tapCount];
    
    NSInteger n = [self viewController].navigationController.viewControllers.count;
    NSLog(@"%p, %p", [self viewController], [self viewController].navigationController.viewControllers[n-1]);
    
    if (tapCount == 1 && self.touchTimer <= 3) {
        
        BOOL ishidden = [self viewController].navigationController.navigationBarHidden;
        [[self viewController].navigationController setNavigationBarHidden:!ishidden animated:YES];
        
        [UIView beginAnimations:@"flipping view" context:nil];
        [UIView setAnimationDuration:0.3];

        if (ishidden) {
            
            CGRect rect = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
            ((ContentViewController *)[self viewController]).toolView.frame = rect;
        }else {
            CGRect rect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
            ((ContentViewController *)[self viewController]).toolView.frame = rect;
        }
        
        [UIView commitAnimations];

    }
    
}

- (UIViewController*)viewController {
    
    if (_vc == nil) {
        for (UIView* next = [self superview]; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                _vc = (UIViewController*)nextResponder;
                return _vc;
            }
        }
    }
    
    return _vc;
}
@end
