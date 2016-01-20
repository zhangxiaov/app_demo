//
//  ZGrowingTextView.h
//  app_demo
//
//  Created by zhangxinwei on 16/1/18.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZGrowingTextView;
@protocol ZGrowingTextViewDelegate <NSObject>

- (void)growingTextViewWillChangeWithKeyboard:(ZGrowingTextView*)growingTextView;

- (void)growingTextView:(ZGrowingTextView*)growingTextView willChangeWithTextView:(float)height;

- (BOOL)growingTextViewShouldReturn:(ZGrowingTextView*)growingTextView;
- (void)growingTextViewDidChange:(ZGrowingTextView*)growingTextView;
- (void)growingTextViewSend:(ZGrowingTextView*)growingTextView;

@end

@interface ZGrowingTextView : UIView
@property (nonatomic) NSObject<ZGrowingTextViewDelegate>* delegate;
@property (nonatomic, copy) NSString* placeholder;
@property (nonatomic, strong) UITextView* innerTextView;
@property (nonatomic, getter=editing) BOOL isEditing;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, copy, getter=text) NSString* text;
@end
