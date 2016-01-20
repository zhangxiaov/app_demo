//
//  CommentTextView.h
//  app_demo
//
//  Created by zhangxinwei on 15/11/30.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTextView : UIView
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIViewController *fromViewController;

+ (CommentTextView *)share;
@property (nonatomic, copy) void (^bridgeBlock)(void);
@end
