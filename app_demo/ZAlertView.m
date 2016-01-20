//
//  ZAlertView.m
//  app_demo
//
//  Created by zhangxinwei on 15/12/15.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "ZAlertView.h"
#define UIColorFromHex(hexvalue) [UIColor colorWithRed:((float)((hexvalue & 0xFF0000) >> 16))/255.0 green:((float)((hexvalue & 0xFF00) >> 8))/255.0 blue:((float)(hexvalue & 0xFF))/255.0 alpha:1.0]


typedef void (^AlerViewtBlock)(NSInteger);

@interface ZAlertView ()
@property (nonatomic, copy) AlerViewtBlock alertViewBlock;
@property (nonatomic, strong) UIView* grayView;
@property (nonatomic, strong) UIView* innerView;
@property (nonatomic) NSInteger buttonIndex;
@end

@implementation ZAlertView

- (instancetype)initWithTitle:(NSString *)title bodyMsg:(NSString *)bodyMsg button0:(NSString *)buttonTitle0 button1:(NSString *)buttonTitle1
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    self = [super initWithFrame:CGRectMake(0, 0, w, h)];
    if (self) {
        
        
        CGFloat iw = 280;
        CGFloat ih = 100;
        
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _grayView.backgroundColor = [UIColor grayColor];
        _grayView.alpha = 0.3;
        
        _innerView = [[UIView alloc] initWithFrame:CGRectMake(w/2-iw/2, h/2-ih/2, iw, ih)];
        _innerView.layer.cornerRadius = 5.0;
        _innerView.layer.masksToBounds = YES;
        _innerView.backgroundColor = [UIColor whiteColor];
        
        CGFloat innerHeight = 0;
        if (title) {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, iw, 30)];
            label.text = title;
            label.textAlignment = NSTextAlignmentCenter;
            label.userInteractionEnabled = YES;
            
            [_innerView addSubview:label];
            
            innerHeight += 30;
        }
        
        if (bodyMsg) {
            NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName:[UIColor blackColor],
                                   NSStrokeWidthAttributeName:[NSNumber numberWithFloat:0.0f]};
            
            CGRect s = [bodyMsg boundingRectWithSize:CGSizeMake(iw - 20, 0)
                                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:dict context:nil];
            CGFloat msgH = s.size.height;
            
            if (msgH > 40) {
                ih = msgH;
            }
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, innerHeight + 5, iw - 20, msgH)];
            label.text = bodyMsg;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.font = [UIFont systemFontOfSize:14];
            label.userInteractionEnabled = YES;
            
            [_innerView addSubview:label];
            
            innerHeight += msgH;
            innerHeight += 10;
        }
        
        if (buttonTitle0 && buttonTitle1) {
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(0, innerHeight, iw, 1);
            layer.backgroundColor = UIColorFromHex(0xD3D3D3).CGColor;
            [_innerView.layer addSublayer:layer];
            
            UIButton* left = [[UIButton alloc] initWithFrame:CGRectMake(0, innerHeight, iw/2, 30)];
            [left setTitle:buttonTitle0 forState:UIControlStateNormal];
            [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [left addTarget:self action:@selector(do0) forControlEvents:UIControlEventTouchUpInside];
            [_innerView addSubview:left];
            
            CALayer *layer2 = [CALayer layer];
            layer2.frame = CGRectMake(iw/2, innerHeight, 1, 30);
            layer2.backgroundColor = UIColorFromHex(0xD3D3D3).CGColor;
            [_innerView.layer addSublayer:layer2];
            
            UIButton* right = [[UIButton alloc] initWithFrame:CGRectMake(iw/2, innerHeight, iw/2, 30)];
            [right setTitle:buttonTitle1 forState:UIControlStateNormal];
            [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [right addTarget:self action:@selector(do1) forControlEvents:UIControlEventTouchUpInside];
            [_innerView addSubview:right];
            
            innerHeight += 30;
        }else if (buttonTitle0 || buttonTitle1){
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(0, innerHeight, iw, 1);
            layer.backgroundColor = UIColorFromHex(0xD3D3D3).CGColor;
            [_innerView.layer addSublayer:layer];
            
            UIButton* left = [[UIButton alloc] initWithFrame:CGRectMake(0, innerHeight, iw, 30)];
            if (buttonTitle0) {
                [left setTitle:buttonTitle0 forState:UIControlStateNormal];
            }else {
                [left setTitle:buttonTitle1 forState:UIControlStateNormal];
            }
            [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [left addTarget:self action:@selector(do0) forControlEvents:UIControlEventTouchUpInside];
            [_innerView addSubview:left];
            
            innerHeight += 30;
        }
        
        ih = innerHeight;
        _innerView.frame = CGRectMake(w/2-iw/2, h/2-ih/2, iw, innerHeight);
        
        [self addSubview:_grayView];
        [self addSubview:_innerView];
    }
    return self;
}

- (void)do0 {
    if (_alertViewBlock) {
        _alertViewBlock(0);
    }
    
    [self removeFromSuperview];
}

- (void)do1 {
    if (_alertViewBlock) {
        _alertViewBlock(1);
    }
    [self removeFromSuperview];
}

- (void)showWithBlock:(void (^)(NSInteger))block {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    _alertViewBlock = block;
}

- (void)showUntill:(int)interval withBlock:(void (^)(NSInteger))block {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    _alertViewBlock = block;
    
    [self performSelector:@selector(timerFireMethod:) withObject:self afterDelay:interval];
}

- (void)timerFireMethod:(ZAlertView*)promptAlert {
    if (_alertViewBlock) {
        _alertViewBlock(0);
    }
    
    [promptAlert removeFromSuperview];
    promptAlert = NULL;
}

@end
