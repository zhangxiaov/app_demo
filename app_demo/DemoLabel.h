//
//  DemoLabel.h
//  app_demo
//
//  Created by zhangxinwei on 15/10/15.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface DemoLabel : UIView <NSCoding>
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *as; // loc,loc,loc
@property (nonatomic, strong) NSMutableArray *ends;
@end
