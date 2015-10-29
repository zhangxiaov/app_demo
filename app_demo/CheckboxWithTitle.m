//
//  CheckboxWithTitle.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/29.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "CheckboxWithTitle.h"
#import "UIImage+UIColor.h"

@interface CheckboxWithTitle ()
@property (nonatomic, strong) UIImageView *v1;
@property (nonatomic, strong) UIImageView *v2;
@end

@implementation CheckboxWithTitle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [self initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _v1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _v1.image = [UIImage imageWithColor:[UIColor whiteColor]];
        _v2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        _v2.image = [UIImage imageWithColor:[UIColor whiteColor]];
        _title = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, frame.size.width - 40, frame.size.height)];

        [self addSubview:_v1];
        [self addSubview:_v2];
        [self addSubview:_title];
        
        _block = ^(CheckboxWithTitle *checkbox) {
            NSLog(@"fafa");
        };
        
        [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)touchAction:(id)sender {
    NSLog(@"%d", _checked);
    self.checked = !_checked;
    _block(self);
}

- (void)setChecked:(BOOL)checked {
    if (_checked) {
        _v2.image = [UIImage imageWithColor:[UIColor whiteColor]];
    }else {
        _v2.image = [UIImage imageWithColor:[UIColor blueColor]];
    }
    
    _checked = checked;
}

@end
