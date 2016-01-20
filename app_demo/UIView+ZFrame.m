//
//  UIView+ZFrame.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/18.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "UIView+ZFrame.h"

@implementation UIView (ZFrame)
- (void)setMis_x:(CGFloat)mis_x
{
    CGRect frame = self.frame;
    frame.origin.x = mis_x;
    self.frame = frame;
}

- (CGFloat)mis_x
{
    return self.frame.origin.x;
}

- (void)setMis_y:(CGFloat)mis_y
{
    CGRect frame = self.frame;
    frame.origin.y = mis_y;
    self.frame = frame;
}

- (CGFloat)mis_y
{
    return self.frame.origin.y;
}

- (void)setMis_w:(CGFloat)mis_w
{
    CGRect frame = self.frame;
    frame.size.width = mis_w;
    self.frame = frame;
}

- (CGFloat)mis_w
{
    return self.frame.size.width;
}

- (void)setMis_h:(CGFloat)mis_h
{
    CGRect frame = self.frame;
    frame.size.height = mis_h;
    self.frame = frame;
}

- (CGFloat)mis_h
{
    return self.frame.size.height;
}

- (void)setMis_size:(CGSize)mis_size
{
    CGRect frame = self.frame;
    frame.size = mis_size;
    self.frame = frame;
}

- (CGSize)mis_size
{
    return self.frame.size;
}

- (void)setMis_origin:(CGPoint)mis_origin
{
    CGRect frame = self.frame;
    frame.origin = mis_origin;
    self.frame = frame;
}

- (CGPoint)mis_origin
{
    return self.frame.origin;
}

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    return kNilOptions;
}
@end
