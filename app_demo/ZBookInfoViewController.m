//
//  ZBookInfoViewController.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZBookInfoViewController.h"
#import "ZDBManager.h"
#import "ZBookInfo.h"
#import "AppUtils.h"

static CGFloat icon_h = 60;
static CGFloat icon_w = 44;

@interface ZBookInfoViewController ()
@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* authorLabel;
@property (nonatomic, strong) UILabel* progressAndPagesLabel;

@property (nonatomic, strong) UILabel* profileLabel;
@end

@implementation ZBookInfoViewController

- (instancetype)initWithBook:(ZBookInfo *)bookInfo
{
    self = [super init];
    if (self) {
        _bookInfo = [[ZDBManager manager] getBookInfo:bookInfo.bookID];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _bookInfo.bookName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareData];
    [self placeViews];
}

#pragma mark


#

- (void)prepareData {
    [self.view addSubview:self.icon];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.authorLabel];
    [self.view addSubview:self.progressAndPagesLabel];
    [self.view addSubview:self.profileLabel];
}

- (void)placeViews {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(icon_h);
        make.width.mas_equalTo(icon_w);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.height.mas_equalTo(33);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.height.mas_equalTo(33);
    }];
    
    [self.progressAndPagesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorLabel.mas_bottom).offset(5);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.height.mas_equalTo(33);
    }];
    
    [self.profileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.width.equalTo(self);
        CGFloat h = [AppUtils heightForText:self.bookInfo.bookProfile];
        make.height.mas_equalTo(h);
    }];
}

#pragma mark setter

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _icon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _nameLabel;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _authorLabel;
}

- (UILabel *)progressAndPagesLabel {
    if (!_progressAndPagesLabel) {
        _progressAndPagesLabel = [[UILabel alloc] init];
        _progressAndPagesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _progressAndPagesLabel;
}

- (UILabel *)profileLabel {
    if (!_profileLabel) {
        _profileLabel = [[UILabel alloc] init];
        _profileLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _profileLabel.numberOfLines = 0;
    }
    
    return _profileLabel;
}

@end
