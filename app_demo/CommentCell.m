//
//  CommentCell.m
//  app_demo
//
//  Created by zhangxinwei on 15/11/23.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "CommentCell.h"
#import "AppConfig.h"

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.authorLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.dateLabel];
        
        
    }
    
    return self;
}

+ (NSString *)reuseIdentifier {
    return @"reuseIdentifier";
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width/2 -10, 30)];
        _authorLabel.font = [UIFont systemFontOfSize:14];
        _authorLabel.textColor = UIColorFromHex(0x0065AC);
    }
    
    return _authorLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, [UIScreen mainScreen].bounds.size.width - 20, 0)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _contentLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/2 - 10, 30)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return _dateLabel;
}
@end
