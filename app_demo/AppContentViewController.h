//
//  AppContentViewController.h
//  app_demo
//
//  Created by zhangxinwei on 15/9/24.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppContentViewController : UIViewController {
    bool isTap;
    int textPos;
}
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *color;
@property (retain, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;
@property (nonatomic, strong) NSAttributedString *attStr;

@end
