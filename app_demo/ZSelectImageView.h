//
//  ZSelectImageView.h
//  app_demo
//
//  Created by zhangxinwei on 15/12/28.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSelectImageView : UIView
@property (nonatomic, strong) UIImageView *imgview;
@property (nonatomic, strong) UILabel *booknamelabel;
@property (nonatomic, strong) UILabel *publishlabel;
@property (nonatomic ,assign) int64_t bookid;
@property (nonatomic, assign) BOOL checked;

+ (CGFloat) kMISSelectBookViewWidth;

+ (CGFloat) kMISSelectBookViewLeft;

+ (CGFloat) kMISSelectBookViewHeight;
@end
