//
//  testvc.m
//  app_demo
//
//  Created by zhangxinwei on 16/1/18.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "testvc.h"
#import "ZMessageViewController.h"
#import "ZBookInfo.h"

@interface testvc ()
@property (nonatomic, strong) UIButton* button;
@end

@implementation testvc


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary* dict = @{@"bookID":@"1111",@"bookName":@"english"};
    ZBookInfo* b = [[ZBookInfo alloc] initWithDict:dict];
    
    NSLog(@"%@", b.description);
    
    [self.view addSubview:self.button];
}

- (void)tap {
    ZMessageViewController* controller = [[ZMessageViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(10, 70, 100, 40)];
        _button.backgroundColor = [UIColor redColor];
        [_button setTitle:@"xxx" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _button;
}

@end
