//
//  ZAlertView.m
//  app_demo
//
//  Created by zhangxinwei on 15/12/15.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "ZAlertView.h"
#import "AppConfig.h"

typedef void (^AlerViewtBlock)(NSInteger);

@interface ZAlertView ()
@property (nonatomic, copy) AlerViewtBlock alertViewBlock;
@property (nonatomic, strong) UIView* grayView;
@property (nonatomic, strong) UIView* innerView;
@property (nonatomic) NSInteger buttonIndex;
@end

@implementation ZAlertView

- (instancetype)initWithTitle:(NSString *)title bodyMsg:(NSString *)bodyMsg bottomMsg:(NSString *)bottomMsg
{
    self = [super init];
    if (self) {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat iw = 280;
        CGFloat ih = 100;
        
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _grayView.backgroundColor = [UIColor blackColor];
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
            
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
            gesture.numberOfTapsRequired = 1;
            [label addGestureRecognizer:gesture];
            
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

        if (bottomMsg) {
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(0, innerHeight, iw, 1);
            layer.backgroundColor = UIColorFromHex(0xD3D3D3).CGColor;
            [_innerView.layer addSublayer:layer];
            
            UIButton* left = [[UIButton alloc] initWithFrame:CGRectMake(0, innerHeight, iw, 30)];
            [left setTitle:bottomMsg forState:UIControlStateNormal];
            [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [left addTarget:self action:@selector(doClose) forControlEvents:UIControlEventTouchUpInside];
            
            
            NSLog(@"xx %d", left.userInteractionEnabled);
            left.backgroundColor = [UIColor orangeColor];
            [_innerView addSubview:left];
//            left.backgroundColor = [UIColor orangeColor];
//            [self addSubview:left];
            
            innerHeight += 30;
        }
        
        ih = innerHeight;
        _innerView.frame = CGRectMake(w/2-iw/2, h/2-ih/2, iw, innerHeight);
        
        [self addSubview:_grayView];
        [self addSubview:_innerView];
    }
    return self;
}

- (void)test {
    NSLog(@"xxx");
}

- (instancetype)initWithTitle:(NSString *)title bodyMsg:(NSString *)bodyMsg bottomMsg:(NSString *)bottomMsg bottomMsg2:(NSString *)bottomMsg2
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)doClose {
    
    NSLog(@"xxxx");
    
    if (_alertViewBlock) {
        _alertViewBlock(0);
    }
    
    [self removeFromSuperview];
}

- (void)hide {
    
}

- (void)showWithBlock:(void (^)(NSInteger))block {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    NSLog(@"%d k", window.userInteractionEnabled);
    
    [window addSubview:self];
    _alertViewBlock = block;
}

- (void)showThenHideUntill:(int)interval {
    
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    for (UIView* v in [window subviews]) {
        if ([v isKindOfClass:[ZAlertView class]]) {
            NSLog(@"1");
        }
        
        NSLog(@"0");
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.innerView.alpha = 0.5;
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.innerView.alpha = 1.0;
    [UIView commitAnimations];
    
//    [NSTimer scheduledTimerWithTimeInterval:interval
//                                     target:self
//                                   selector:@selector(timerFireMethod:)
//                                   userInfo:self
//                                    repeats:YES];
    
//    [self performSelector:@selector(timerFireMethod:) withObject:self afterDelay:interval];
}

//- (void)timerFireMethod:(NSTimer*)theTimer {
- (void)timerFireMethod:(ZAlertView*)promptAlert {
//    ZAlertView *promptAlert = (ZAlertView*)[theTimer userInfo];
    
    [promptAlert removeFromSuperview];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    for (UIView* v in [window subviews]) {
        if ([v isKindOfClass:[ZAlertView class]]) {
            NSLog(@"2 1");
        }
        
        NSLog(@"2 0");
    }
    
    promptAlert = NULL;
}

@end
