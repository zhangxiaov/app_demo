////
////  ZSelectImageView.m
////  app_demo
////
////  Created by zhangxinwei on 15/12/28.
////  Copyright © 2015年 张新伟. All rights reserved.
////
//
//#import "ZSelectImageView.h"
//
//@interface ZSelectImageView ()
//@property (nonatomic, strong) UIButton *btn;
//
//@end
//
//@implementation ZSelectImageView
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        
//        [self addSubview:self.imgview];
//        [self addSubview:self.btn];
//        [self addSubview:self.booknamelabel];
//        [self addSubview:self.publishlabel];
//        
////        [self.imgview mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.width.mas_equalTo([MISSelectBookView kMISSelectBookViewWidth]);
////            make.height.mas_equalTo(@100);
////            make.left.equalTo(self);
////            make.top.equalTo(self);
////        }];
////        
////        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.right.mas_equalTo(self.imgview.mas_right).offset(5);
////            make.bottom.mas_equalTo(self.imgview.mas_bottom).offset(5);
////        }];
////        
////        [self.booknamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.mas_equalTo(self.imgview.mas_bottom).offset(5);
////            make.width.equalTo(self.imgview);
////            make.left.equalTo(self);
////            make.height.equalTo(@20);
////        }];
////        
////        [self.publishlabel mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.mas_equalTo(self.booknamelabel.mas_bottom).offset(5);
////            make.width.equalTo(self.imgview);
////            make.left.equalTo(self);
////            make.height.equalTo(@20);
////        }];
//    }
//    
//    return self;
//}
//
//- (void)choose {
//    _btn.selected = !_btn.selected;
//    NSLog(@"bookid = %lld", _bookid);
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self choose];
//}
//
//- (UIButton *)btn {
//    if (_btn == nil) {
//        _btn = [UIButton autoLayoutButton];
//        [_btn setImage:IMAGE_WITH_NAME(@"MISCheckOff") forState:UIControlStateNormal];
//        [_btn setImage:IMAGE_WITH_NAME(@"MISCheckIn") forState:UIControlStateSelected];
//        [_btn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    return _btn;
//}
//
//- (UIImageView *)imgview {
//    if (_imgview == nil) {
//        _imgview = [UIImageView autoLayoutImageView];
//        _imgview.contentMode = UIViewContentModeScaleAspectFill;
//        _imgview.clipsToBounds = YES;
//    }
//    
//    return _imgview;
//}
//
//- (UILabel *)booknamelabel {
//    if (_booknamelabel == nil) {
//        _booknamelabel = [UILabel autoLayoutLabel];
//        _booknamelabel.textAlignment = NSTextAlignmentCenter;
//        _booknamelabel.font = NFont(14);
//        _booknamelabel.textColor = [UIColor grayColor];
//    }
//    
//    return _booknamelabel;
//}
//
//- (UILabel *)publishlabel {
//    if (_publishlabel == nil) {
//        _publishlabel = [UILabel autoLayoutLabel];
//        _publishlabel.textAlignment = NSTextAlignmentCenter;
//        _publishlabel.font = NFont(14);
//        _publishlabel.textColor = [UIColor grayColor];
//        _publishlabel.numberOfLines = 0;
//    }
//    
//    return _publishlabel;
//}
//
//- (void)setChecked:(BOOL)checked {
//    _btn.selected = checked;
//}
//
//- (BOOL)checked {
//    return _btn.selected;
//}
//
//+ (CGFloat) kMISSelectBookViewWidth {
//    return (SCREEN_WIDTH - SCREEN_WIDTH*0.045*4)/3;
//}
//
//+ (CGFloat) kMISSelectBookViewLeft {
//    return SCREEN_WIDTH*0.045;
//}
//
//+ (CGFloat) kMISSelectBookViewHeight {
//    return 140 + 20 + 20;
//}
//
//@end
