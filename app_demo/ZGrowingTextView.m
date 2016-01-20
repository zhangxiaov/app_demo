//
//  ZGrowingTextView.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/18.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZGrowingTextView.h"
#import "UIView+ZFrame.h"
#import <Masonry/Masonry.h>

@interface ZGrowingTextView () <UITextViewDelegate>

@end

@implementation ZGrowingTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.innerTextView];
        [self placeSubViews];
    }
    return self;
}

- (void)placeSubViews {
    [self.innerTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.mas_height);
        make.top.mas_equalTo(self.mas_top);
    }];
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView.text isEqualToString:@"\n"]) {
        return NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(growingTextViewSend:)]) {
        [self.delegate growingTextViewSend:self];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(growingTextViewWillChangeWithKeyboard:)]) {
        [self.delegate growingTextViewWillChangeWithKeyboard:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(grow:)]) {
        [self.delegate growingTextViewWillChangeWithKeyboard:self];
    }
    
    NSString* str = textView.text;
    NSDictionary* dict = @{ NSFontAttributeName : [UIFont systemFontOfSize:13.0] };
    CGFloat stringHeight = [str boundingRectWithSize:CGSizeMake(self.innerTextView.frame.size.width, 600)
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:dict context:nil].size.height;
    
    if (stringHeight <= 36) {
        stringHeight = 36;
    }else {
        CGRect innerFrame = self.innerTextView.frame;
        innerFrame.size.height = stringHeight;
        self.innerTextView.frame = innerFrame;
        [self.innerTextView needsUpdateConstraints];
        
        CGRect outterFrame = self.frame;
        outterFrame.size.height = stringHeight;
        self.frame = outterFrame;
        [self needsUpdateConstraints];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(growingTextView:willChangeWithTextView:)]) {
            [self.delegate growingTextView:self willChangeWithTextView:stringHeight];
        }
    }
}

#pragma mark 

- (NSString *)text {
    return self.innerTextView.text;
}

- (void)setIsEditing:(BOOL)isEditing {
    if (isEditing) {
        [_innerTextView becomeFirstResponder];
    }else {
        [_innerTextView resignFirstResponder];
    }
}

- (BOOL)editing {
    return _innerTextView.isFirstResponder;
}

- (UITextView *)innerTextView {
    if (_innerTextView == nil) {
        _innerTextView = [[UITextView alloc] init];
        _innerTextView.translatesAutoresizingMaskIntoConstraints = NO;
        _innerTextView.delegate = self;
        _innerTextView.returnKeyType = UIReturnKeySend;
        
        if (_font) {
            _innerTextView.font = _font;
        }else {
            _innerTextView.font = [UIFont systemFontOfSize:15];
        }
    }
    
    return _innerTextView;
}

@end
