//
//  UITouchScrollView.h
//  app_demo
//
//  Created by 张新伟 on 15/10/4.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITouchScrollView : UIScrollView

@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, assign) NSTimeInterval touchTimer;

@end
