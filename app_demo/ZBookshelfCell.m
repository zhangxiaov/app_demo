//
//  ZBookshelfCell.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/26.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZBookshelfCell.h"
#import "ZBookInfo.h"

@implementation ZBookshelfCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bookIconView];
        [self addSubview:self.bookNameLabel];
        
        [self.bookIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.height.mas_equalTo(frame.size.height - 40);
            make.width.mas_equalTo(frame.size.width);
        }];
        
        [self.bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bookIconView.mas_bottom).offset(5);
            make.height.equalTo(@40);
            make.width.mas_equalTo(frame.size.width);
        }];
    }
    return self;
}


- (UIImageView *)bookIconView {
    if (!_bookIconView) {
        _bookIconView = [[UIImageView alloc] init];
        _bookIconView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _bookIconView;
}

- (UILabel *)bookNameLabel {
    if (!_bookNameLabel) {
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _bookNameLabel.numberOfLines = 0;
        _bookNameLabel.textAlignment = NSTextAlignmentLeft;
        _bookNameLabel.font = [UIFont systemFontOfSize:14];
        [_bookNameLabel setTextColor:[UIColor blackColor]];
    }
    
    return _bookNameLabel;
}

- (void)fillData:(id)obj {
    ZBookInfo* bookInfo = obj;
    self.bookIconView.image = [UIImage imageNamed:bookInfo.bookIcon];
    self.bookNameLabel.text = bookInfo.bookName;
}

+ (NSString *)reuseIdentifier {
    return @"ZBookshelfCell";
}

@end
