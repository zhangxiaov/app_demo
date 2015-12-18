//
//  ZAlertView.h
//  app_demo
//
//  Created by zhangxinwei on 15/12/15.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZAlertView : UIView

@property (nonatomic, strong) UIView* bodyView;

- (instancetype)initWithTitle:(NSString*)title bodyMsg:(NSString*)bodyMsg bottomMsg:(NSString*)bottomMsg;

- (instancetype)initWithTitle:(NSString*)title bodyMsg:(NSString*)bodyMsg bottomMsg:(NSString*)bottomMsg bottomMsg2:(NSString*)bottomMsg2;

- (void)showThenHideUntill:(int)interval;

- (void)showWithBlock:(void (^)(NSInteger))block;
@end
