//
//  UITouchScrollView.m
//  app_demo
//
//  Created by 张新伟 on 15/10/4.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "UITouchScrollView.h"
#import "ContentViewController.h"

@interface UITouchScrollView ()
@property (nonatomic, strong) UIViewController *vc;
@end

@implementation UITouchScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.touchTimer = [touch timestamp];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:1296035591];
    NSLog(@"1296035591  = %@",confromTimesp);
    
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值

}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    
    UITouch *touch = [touches anyObject];
    self.touchTimer = [touch timestamp] - self.touchTimer;
    
    NSUInteger tapCount = [touch tapCount];
//    CGPoint touchPoint = [touch locationInView:self];
    
//    //判断单击事件，touch时间和touch的区域
//    if (tapCount == 1 && self.touchTimer <= 3 && CGRectContainsPoint(self.imageView.frame, touchPoint)) {
//        //进行单击的跳转等事件
////        [UINavigationController setNavigationBarHidden:isTap animated:YES];
//        [UIApplication sharedApplication].statusBarHidden = [UIApplication sharedApplication].statusBarHidden;;
//    }
    
    if (tapCount == 1 && self.touchTimer <= 3) {
        BOOL ishidden = [self viewController].navigationController.navigationBarHidden;
        [[self viewController].navigationController setNavigationBarHidden:!ishidden animated:YES];
        
        [UIView beginAnimations:@"flipping view" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:((ContentViewController *)[self viewController]).toolView cache:YES];
        //你的动作，比如删除某个东西
        ((ContentViewController *)[self viewController]).toolView.hidden = !ishidden;
        [UIView commitAnimations];
        
        //                ((ContentViewController *)[self viewController]).toolView.hidden = !ishidden;
//        [UIView animateWithDuration:0.5 animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>
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
