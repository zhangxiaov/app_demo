//
//  AppLabel.m
//  app_demo
//
//  Created by 张新伟 on 15/9/27.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppLabel.h"
#import "AppConfig.h"

@implementation AppLabel
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CONTENT_WIDTH, CONTENT_HEIGHT)];
        _label.backgroundColor = [UIColor whiteColor];
        _label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:FONT_SIZE_MAX];
        _label.numberOfLines = 0;
//        _label.lineBreakMode = NSLineBreakByWordWrapping;
//        _label.textAlignment = NSTextAlignmentLeft;
//        _label setver
        [self addSubview:_label];
    }
    
    return self;
}
@end
