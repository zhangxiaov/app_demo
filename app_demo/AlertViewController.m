//
//  AlertViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/12/15.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "AlertViewController.h"
#import "ZAlertView.h"

@implementation AlertViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 60, 30)];
        button.backgroundColor = [UIColor grayColor];
        [button setTitle:@"show" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* button2 = [[UIButton alloc] initWithFrame:CGRectMake(90, 80, 80, 30)];
        button2.backgroundColor = [UIColor grayColor];

        [button2 setTitle:@"hide" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* autoButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 80, 80, 30)];
        autoButton.backgroundColor = [UIColor grayColor];

        [autoButton setTitle:@"hide" forState:UIControlStateNormal];
        [autoButton addTarget:self action:@selector(auto) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        [self.view addSubview:button2];
        [self.view addSubview:autoButton];
        
//        self.navigationController
    }
    return self;
}

- (void)show {
    ZAlertView* alertView = [[ZAlertView alloc] initWithTitle:@"text" bodyMsg:nil bottomMsg:@"关闭"];
//    [alertView showThenHideUntill:5];
    [alertView showWithBlock:^(NSInteger i) {
        NSLog(@"xxxxxxx");
    }];
    
    UIButton *tmpBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 10)];
    tmpBtn.backgroundColor = [UIColor purpleColor];
    [tmpBtn addTarget:self action:@selector(ttt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tmpBtn];
}

- (void)ttt
{
    NSLog(@"&&&&&");
}

- (void)hide {
    NSLog(@"tetete");
}

- (void)auto {
    
}

@end
