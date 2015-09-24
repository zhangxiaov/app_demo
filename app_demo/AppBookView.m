//
//  AppBookView.m
//  app_demo
//
//  Created by zhangxinwei on 15/9/24.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppBookView.h"
#import "UIImage+UIColor.h"
#import "AppConfig.h"

@interface AppBookView ()
@property (nonatomic, strong) UILabel *booknamelabel;
@property (nonatomic, strong) UILabel *authorlabel;
@property (nonatomic, strong) UIButton  *button;
@end

@implementation AppBookView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.booknamelabel];
        [self addSubview:self.authorlabel];
        [self addSubview:self.button];
    }
    
    return self;
}

- (void)setCover:(NSString *)imgstr name:(NSString *)bookname author:(NSString *)author bookid:(int64_t)bookid{

    self.booknamelabel.text = bookname;
    self.authorlabel.text = author;
    self.bookid = bookid;
    _bookname = bookname;
}

- (UILabel *)booknamelabel {
    if (_booknamelabel == nil) {
        _booknamelabel = [[UILabel alloc] init];
        _booknamelabel.frame = CGRectMake(0, 105, (SCREEN_WIDTH - NORMAL_PADDING*4)/3, 20);
    }
    
    return _booknamelabel;
}

- (UILabel *)authorlabel {
    if (_authorlabel == nil) {
        _authorlabel = [[UILabel alloc] init];
        _authorlabel.frame = CGRectMake(0, 130, (SCREEN_WIDTH - NORMAL_PADDING*4)/3, 20);
    }
    
    return _authorlabel;
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [[UIButton alloc] init];
        _button.frame = CGRectMake(0, 0, (SCREEN_WIDTH - NORMAL_PADDING*4)/3, 100);
//        [_button setImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
//        _button.backgroundColor = [UIColor redColor];
        [_button addTarget:self action:@selector(didTap) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _button;
}

- (void)didTap {
    NSLog(@"%d", self.bookid);
    [_delegate bookView:self didTap:nil];
}

+ (CGFloat)height {
    return 150;
}

+ (CGFloat)width {
    return (SCREEN_WIDTH - NORMAL_PADDING*4)/3;
}

@end
