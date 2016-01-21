//
//  ZMessageInputBarView.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/18.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZMessageInputView.h"
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
static CGFloat DURATION_FOR_VIEW = 0.25f;

static const CGFloat addPadHeight = 50;



@interface ZMessageInputView () <UITextViewDelegate>
@property (nonatomic) CGFloat keyboardHeight;

@property (nonatomic) UIView* grayView;
@property (nonatomic, strong) UIView* addPadView;

@property (nonatomic) CGFloat duration;
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
        _fontSize = 15;
        self.backgroundColor = UIColorFromHex(0xF8F9FA);
//        self.backgroundColor = [UIColor grayColor];
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
    UIWindow* kw = [UIApplication sharedApplication].keyWindow;

    if (useGrayView) {
        if (self.grayView.superview == kw) {
            return;
        }else {
            [kw addSubview:self.grayView];
        }
    }
    
    if (self.superview == kw) {
        return;
    }else {
        [kw addSubview:self];
    }
    
    if (self.addPadView.superview == kw) {
        return;
    }else {
        [kw addSubview:self.addPadView];
    }
    
    self.mis_y = SCREEN_HEIGHT;
    
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

- (void)changePadView:(BOOL)animation {
    CGRect frame = self.frame;
    switch (_keyboardType) {
        case ZMessageInputViewKeyboradTypeNone:
            ;
            frame.size.height = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
            frame.origin.y = SCREEN_HEIGHT - (MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2);
            break;
        case ZMessageInputViewKeyboradTypeAddPad:
            ;
            frame.size.height = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2 + addPadHeight;
            frame.origin.y = SCREEN_HEIGHT - (MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2 + addPadHeight);
            break;
        case ZMessageInputViewKeyboradTypeKeyPad:
            ;
            frame.size.height = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2 + _keyboardHeight;
            frame.origin.y = SCREEN_HEIGHT - (MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2 + _keyboardHeight);
            break;
        case ZMessageInputViewKeyboradTypeVoicePad:
            ;
            frame.size.height = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
            frame.origin.y = SCREEN_HEIGHT - (MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2);
            break;
        default:
            break;
    }
    if (animation) {
        [UIView animateWithDuration:DURATION_FOR_VIEW animations:^{
            self.frame= frame;
        }];
    }else{
        self.frame= frame;
    }

}

#pragma mark event

- (void)grayViewTaped {
    self.grayView.hidden = YES;
    _keyboardType = ZMessageInputViewKeyboradTypeNone;
    [self SetInputViewFrame:YES];
}

- (void)keyboardChange:(NSNotification*)aNotification {
    if ([aNotification name] == UIKeyboardDidChangeFrameNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    
    if (_duration <= 0.0) {
        if ([aNotification name] == UIKeyboardWillChangeFrameNotification) {
            NSDictionary* dict = [aNotification userInfo];
            _duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            DURATION_FOR_VIEW = _duration;
        }
    }
    
    _keyboardType = ZMessageInputViewKeyboradTypeKeyPad;
    _keyboardHeight = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self SetInputViewFrame:NO];
}

- (void)buttonTaped:(UIButton*)button {
    switch (button.tag) {
        case ZMessageInputViewButtonTypeVoice:
            ;
            _keyboardType = ZMessageInputViewKeyboradTypeVoicePad;
            break;
        case ZMessageInputViewButtonTypeText:
            ;
            _keyboardType = ZMessageInputViewKeyboradTypeKeyPad;
            break;
        case ZMessageInputViewButtonTypeOther:
            ;
            _keyboardType = ZMessageInputViewKeyboradTypeAddPad;
            break;
        default:
            break;
    }
    
    [self SetInputViewFrame:YES];
}

- (void)sendText:(NSString*)text {
    if (text && [text isKindOfClass:[NSString class]]) {
        if (text.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:didTextSendWithText:)]) {
                [self.delegate inputView:self didTextSendWithText:text];
            }
        }
        else {
            
        }
        
        NSLog(@"send text%@", text);
        
        _keyboardType = ZMessageInputViewKeyboradTypeNone;
        self.textView.text = @"";
        [self SetInputViewFrame:YES];
    }
    else {
        NSLog(@"sendText -- 不是文字，不能发送");
    }
    
    
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        [self SetInputViewFrame:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length <= 0 && ![textView.text isEqualToString:@"\n"]) {
        return NO;
    }
    
    [self sendText:textView.text];
    return YES;
}

#pragma mark setter getter

- (CGFloat)keyboardOriginHeight {
    return MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
}

- (CGFloat)inputViewHeight{
    CGFloat h = 0;
    switch (_keyboardType) {
        case ZMessageInputViewKeyboradTypeNone:
            ;
            h = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
            break;
        case ZMessageInputViewKeyboradTypeAddPad:
            ;
            h = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2 + addPadHeight;
            break;
        case ZMessageInputViewKeyboradTypeKeyPad:
            ;
            h = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2 + _keyboardHeight;
            break;
        case ZMessageInputViewKeyboradTypeVoicePad:
            ;
            h = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
            break;
        default:
            break;
    }
    
    return h;
}

- (void)SetInputViewFrame:(BOOL)animation {
    CGRect frame = self.frame;
    switch (_keyboardType) {
        case ZMessageInputViewKeyboradTypeNone:{
            self.grayView.hidden = YES;
            [self.textView resignFirstResponder];
            
            frame.size.height = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
            frame.origin.y = SCREEN_HEIGHT - (MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2);
            
            //隐藏addpad
            CGRect paddFrame = self.addPadView.frame;
            paddFrame.origin.y = SCREEN_HEIGHT;
            
            [UIView animateWithDuration:DURATION_FOR_VIEW animations:^{
                self.addPadView.frame = paddFrame;
            }];
        }
            break;
        case ZMessageInputViewKeyboradTypeAddPad:{
            self.grayView.hidden = NO;
            [self.textView resignFirstResponder];
            
            frame.size.height = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
            //            frame.origin.y = SCREEN_HEIGHT - (MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2 + addPadHeight);
            frame.origin.y = SCREEN_HEIGHT - (frame.size.height + addPadHeight);
            
            //显示addpad
            CGRect paddFrame = self.addPadView.frame;
            paddFrame.origin.y = SCREEN_HEIGHT - addPadHeight;
            
            [UIView animateWithDuration:DURATION_FOR_VIEW animations:^{
                self.addPadView.frame = paddFrame;
            }];

        }
            break;
        case ZMessageInputViewKeyboradTypeKeyPad:
            {
                self.grayView.hidden = NO;
                NSString* str = self.textView.text;
                NSDictionary* dict = @{ NSFontAttributeName : [UIFont systemFontOfSize:_fontSize] };
                CGFloat stringHeight = [str boundingRectWithSize:CGSizeMake(self.textView.frame.size.width, 600)
                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                      attributes:dict context:nil].size.height;
                if (stringHeight < MIN_HEIGHT_FOR_INPUT_VIEW) {
                    stringHeight = MIN_HEIGHT_FOR_INPUT_VIEW;
                }
                CGRect innerFrame = self.textView.frame;
                innerFrame.size.height = stringHeight;
                self.textView.frame = innerFrame;
                
                frame.size.height = stringHeight + PADDING_FOR_VIEW_V*2;
                frame.origin.y = SCREEN_HEIGHT - (frame.size.height + _keyboardHeight);
                
                //隐藏addpad
                CGRect paddFrame = self.addPadView.frame;
                paddFrame.origin.y = SCREEN_HEIGHT;
                
                self.addPadView.frame = paddFrame;
            }
            break;
        case ZMessageInputViewKeyboradTypeVoicePad:{
            self.grayView.hidden = NO;
            [self.textView resignFirstResponder];
            
            frame.size.height = MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2;
            frame.origin.y = SCREEN_HEIGHT - (MIN_HEIGHT_FOR_INPUT_VIEW + PADDING_FOR_VIEW_V*2);
            
            //隐藏addpad
            CGRect paddFrame = self.addPadView.frame;
            paddFrame.origin.y = SCREEN_HEIGHT;
            
            [UIView animateWithDuration:DURATION_FOR_VIEW animations:^{
                self.addPadView.frame = paddFrame;
            }];
        }
            break;
        default:
            break;
    }
    if (animation) {
        [UIView animateWithDuration:DURATION_FOR_VIEW animations:^{
           self.frame= frame;
        }];
    }else{
        self.frame= frame;
        [self.textView needsUpdateConstraints];
    }
}

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

- (ZTextView *)textView {
    if (!_textView) {
        _textView = [[ZTextView alloc] init];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.placeHolder = @"xxxx";
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _textView.layer.borderColor = UIColorFromHex(0xE7E7E7).CGColor;
    }
    
    return _textView;
}

- (UIView *)grayView {
    if (_grayView == nil) {
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _grayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _grayView.hidden = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(grayViewTaped)];
        tap.numberOfTapsRequired = 1;
        [_grayView addGestureRecognizer:tap];
    }
    
    return _grayView;
}

- (UIView *)addPadView {
    if (_addPadView == nil) {
        _addPadView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, addPadHeight)];
        _addPadView.backgroundColor = UIColorFromHex(0xF8F9FA);
    }
    
    return _addPadView;
}

@end
