//
//  UIView+ZFrame.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/18.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZFrame)
@property (assign, nonatomic) CGFloat mis_x;

/**
 *  Y坐标
 */
@property (assign, nonatomic) CGFloat mis_y;

/**
 *  宽度
 */
@property (assign, nonatomic) CGFloat mis_w;

/**
 *  高度
 */
@property (assign, nonatomic) CGFloat mis_h;

/**
 *  大小
 */
@property (assign, nonatomic) CGSize mis_size;

/**
 *  位置
 */
@property (assign, nonatomic) CGPoint mis_origin;

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;

@end
