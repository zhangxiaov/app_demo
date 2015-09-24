//
//  AppBookView.h
//  app_demo
//
//  Created by zhangxinwei on 15/9/24.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppBookView;

@protocol AppBookViewDelegate <NSObject>
- (void)bookView:(AppBookView *)bookView didTap:(UIButton *)button;
@end

@interface AppBookView : UIView
@property (nonatomic, assign) id <AppBookViewDelegate> delegate;
@property (nonatomic, assign) int64_t bookid;
@property (nonatomic, strong) NSString *bookname;
- (void)setCover:(NSString *)imgstr name:(NSString *)bookname author:(NSString *)author bookid:(int64_t)bookid;
+ (CGFloat)height;
+ (CGFloat)width;

@end

