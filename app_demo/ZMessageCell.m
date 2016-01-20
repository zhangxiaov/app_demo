//
//  ZMessageCell.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/20.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "ZMessageCell.h"
#import <Masonry/Masonry.h>
#import "ZMessageModel.h"

@interface ZMessageCell ()
@property (nonatomic, strong) UILabel* label;

@end

@implementation ZMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@10);
            make.height.mas_equalTo(@30);
        }];
    }
    return self;
}

- (void)updateWithMessage:(ZMessageModel *)message {
    self.label.text = message.text;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.numberOfLines = 0;
    }
    
    return _label;
}

+ (NSString *)reuseIdentifier {
    return @"ZMessageCell";
}

@end
