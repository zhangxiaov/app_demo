//
//  ZAlertView.h
//  app_demo
//
//  Created by zhangxinwei on 15/12/15.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title bodyMsg:(NSString *)bodyMsg button0:(NSString *)buttonTitle0 button1:(NSString *)buttonTitle1;

- (void)showWithBlock:(void (^)(NSInteger i))block;

- (void)showUntill:(int)interval withBlock:(void (^)(NSInteger i))block;
@end
