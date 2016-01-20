//
//  ZMessageInputBarView.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/18.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZMessageInputView.h"
#import "ZGrowingTextView.h"
#import "AppConfig.h"
#import <Masonry/Masonry.h>
#import "UIView+ZFrame.h"
#import "ZTextView.h"

/**
 *  水平方向的PADDING
 */
static const CGFloat PADDING_FOR_VIEW_H = 10;

/**
 *  垂直方向的PADDING
 */
static const CGFloat PADDING_FOR_VIEW_V = 5;

static const CGFloat GAP_BTWN_BTNS = 5;

/**
 *  录音按钮的字体的大小
 */
static const CGFloat FONT_SIZE_FOR_VOICEINPUT = 18;

/**
 *  最小的，也是原始的输入框的高度
 */
static const CGFloat MIN_HEIGHT_FOR_INPUT_VIEW = 36;
static const CGFloat SIZE_FOR_BTN = 36;
static const CGFloat DURATION_FOR_VIEW = 0.25f;



@interface ZMessageInputView () <ZGrowingTextViewDelegate, UITextViewDelegate>
@property (nonatomic) CGFloat keyboardHeight;
@property (nonatomic) UIView* grayView;
@end

@implementation ZMessageInputView

- (instancetype)initWithType:(ZMessageInputViewType)type andWithPlaceHolder:(NSString *)placeHolder
{
     CGRect f = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V * 2);
    self = [super initWithFrame:f];
    if (self) {
        [self loadViewWithViewType:type];
        if (placeHolder != nil) {
            self.textView.placeHolder = placeHolder;
        }
        self.backgroundColor = UIColorFromHex(0xF8F9FA);
    }
    return self;
}

- (void)placeViewsForChat {
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self).offset(PADDING_FOR_VIEW_V);
        make.width.equalTo(@(SIZE_FOR_BTN));
        make.height.equalTo(@(SIZE_FOR_BTN));
        make.left.equalTo(self).offset(PADDING_FOR_VIEW_H);
        make.right.equalTo(self.otherButton.mas_left).offset(-GAP_BTWN_BTNS);
    }];
    
    [self.otherButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self).offset(PADDING_FOR_VIEW_V);
        make.width.equalTo(@(SIZE_FOR_BTN));
        make.height.equalTo(@(SIZE_FOR_BTN));
        make.left.equalTo(self).offset(GAP_BTWN_BTNS + PADDING_FOR_VIEW_H + SIZE_FOR_BTN);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.otherButton.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self).offset(PADDING_FOR_VIEW_V);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
}

- (void)prepareViewsForChat {
    [self addSubview:self.voiceButton];
    [self addSubview:self.otherButton];
    [self addSubview:self.textView];
    
    [self placeViewsForChat];
}

- (void)prepareToShow:(BOOL)useGrayView {
    
    if (useGrayView) {
        UIWindow* kw = [UIApplication sharedApplication].keyWindow;
        if (self.grayView.superview == kw) {
            return;
        }
        self.grayView.hidden = YES;
        [kw addSubview:self.grayView];
        
        _useGrayView = useGrayView;
    }
    
    UIWindow* kw = [UIApplication sharedApplication].keyWindow;
    if (self.superview == kw) {
        return;
    }
    
    self.mis_y = SCREEN_HEIGHT;
    [kw addSubview:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.mis_y = SCREEN_HEIGHT - self.mis_h;
                     }];

}

- (void)disappear {
    if (!self.superview) {
        return;
    }
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    
    __weak ZMessageInputView* weakSelf = self;
    [UIView animateWithDuration:DURATION_FOR_VIEW
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         self.mis_y = SCREEN_HEIGHT;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                     }];
    
}

- (void)dealloc {
    NSLog(@"xx");
}

- (void)loadViewWithViewType:(ZMessageInputViewType)type {
    switch (type) {
        case ZMessageInputViewTypeChat:
            //聊天输入框
            ;
            [self prepareViewsForChat];
            break;
        case ZMessageInputViewTypeComment: {
            //评论输入框
            break;
        }
        case ZMessageInputViewTypeNotice: {
            //通知的输入框
            break;
        }
        case ZMessageInputViewTypeQuestion: {
            break;
        }
        default:
            break;
    }

}

- (void)changeGrayViewFrame {
    if (_useGrayView) {
        self.grayView.hidden = NO;
        CGRect grayViewFrame = self.grayView.frame;
        grayViewFrame.size.height = SCREEN_HEIGHT - (MIN_HEIGHT_FOR_INPUT_VIEW + _keyboardHeight + PADDING_FOR_VIEW_V*2);
        self.grayView.frame = grayViewFrame;
    }
}

- (void)chageInputViewFrame {
    CGRect frame = self.frame;

    switch (_keyboardType) {
        case ZMessageInputViewKeyboradTypeNone:
            frame.origin.y = SCREEN_HEIGHT - frame.size.height;
            
            break;
        case ZMessageInputViewKeyboradTypeAddPad:
            ;
            break;
        case ZMessageInputViewKeyboradTypeVoicePad:
            
            break;
        case ZMessageInputViewKeyboradTypeKeyPad:
            
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:DURATION_FOR_VIEW animations:^{
        self.frame = frame;
    } completion:nil];

}

#pragma mark event

- (void)hideKeyBorardPad {
//    self.inputTextView.isEditing = NO;
    _keyboardHeight = 0;
    _keyboardType = ZMessageInputViewKeyboradTypeNone;
    [self chageInputViewFrame];
}

- (void)keyboardChange:(NSNotification*)aNotification {
    if ([aNotification name] == UIKeyboardDidChangeFrameNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    
    _keyboardHeight = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    __weak typeof(self) weakSelf = self;
    void (^endFrameBlock)() = ^() {
        weakSelf.mis_y = SCREEN_HEIGHT - weakSelf.frame.size.height - _keyboardHeight;
    };
    if ([aNotification name] == UIKeyboardWillChangeFrameNotification) {
        
        NSDictionary* userInfo = [aNotification userInfo];
        NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
                            options:[UIView animationOptionsForCurve:animationCurve]
                         animations:^{
                             endFrameBlock();
                         }
                         completion:nil];
    }
    else {
        endFrameBlock();
    }

}

- (void)buttonTaped:(UIButton*)button {
    switch (button.tag) {
        case ZMessageInputViewButtonTypeVoice:
            //
            break;
        case ZMessageInputViewButtonTypeText:
            //
        case ZMessageInputViewButtonTypeOther:
            
            break;
        default:
            break;
    }
}

- (void)resetInputView {
    
    [self.textView resignFirstResponder];
    self.textView.text = @"";
    self.grayView.hidden = YES;
    _keyboardHeight = 0;
    
    CGRect frame = self.frame;
    frame.origin.y = SCREEN_HEIGHT - self.frame.size.height - _keyboardHeight;
    
    [UIView animateWithDuration:DURATION_FOR_VIEW animations:^{
        self.frame = frame;
    } completion:nil];
}

- (void)sendText:(NSString*)text
{
    if (text && [text isKindOfClass:[NSString class]]) {
        if (text.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:didTextSendWithText:)]) {
                [self.delegate inputView:self didTextSendWithText:text];
            }
        }
        else {
//            [self showErrorMessage:@"不能发送空白信息"];
        }
        
        NSLog(@"send text%@", text);
        
        [self resetInputView];
    }
    else {
        NSLog(@"sendText -- 不是文字，不能发送");
    }
    
    
}

#pragma mark ZGrowingTextViewDelegate

//- (void)growingTextViewWillChangeWithKeyboard:(ZGrowingTextView *)growingTextView {
//    [self changeGrayViewFrame];
//
//    CGRect frame = self.frame;
////    frame.size.height = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
////    frame.origin.y = SCREEN_HEIGHT - (MIN_HEIGHT_FOR_INPUT_VIEW + _keyboardHeight + PADDING_FOR_VIEW_V*2);
//    frame.origin.y = SCREEN_HEIGHT - frame.size.height - _keyboardHeight;
//    
//    [UIView animateWithDuration:DURATION_FOR_VIEW animations:^{
//        self.frame = frame;
//    } completion:nil];
//
//}
//
//- (void)growingTextView:(ZGrowingTextView *)growingTextView willChangeWithTextView:(float)height {
//    [self changeGrayViewFrame];
//    
//    CGRect frame = self.frame;
//    frame.size.height = height + PADDING_FOR_VIEW_V*2;
////    frame.origin.y = SCREEN_HEIGHT - (height + _keyboardHeight + PADDING_FOR_VIEW_V*2);
//    frame.origin.y = SCREEN_HEIGHT - frame.size.height - _keyboardHeight;
//    
//    self.frame = frame;
//    [self needsUpdateConstraints];
//}
//
//- (void)growingTextViewSend:(ZMessageInputView *)growingTextView {
//    [self sendText:self.inputTextView.text];
//}

#pragma mark setter getter

- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [[UIButton alloc] init];
        _voiceButton.tag = ZMessageInputViewButtonTypeVoice;
        _voiceButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"MISToolbarVoice"] forState:UIControlStateNormal];
        [_voiceButton addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _voiceButton;
}

- (UIButton *)otherButton {
    if (!_otherButton) {
        _otherButton = [[UIButton alloc] init];
        _otherButton.tag = ZMessageInputViewButtonTypeOther;
        _otherButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_otherButton setBackgroundImage:[UIImage imageNamed:@"MISToolbarAdd"] forState:UIControlStateNormal];
        [_otherButton addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _otherButton;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[ZTextView alloc] init];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.placeHolder = @"xxxx";
    }
    
    return _textView;
}

- (UIView *)grayView {
    if (_grayView == nil) {
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.frame.size.height)];
        _grayView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBorardPad)];
        [_grayView addGestureRecognizer:tap];
    }
    
    return _grayView;
}

@end
