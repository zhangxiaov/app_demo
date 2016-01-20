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
        
    }
    return self;
}

- (void)show {
//    ZAlertView* alertView = [[ZAlertView alloc] initWithTitle:@"提示" bodyMsg:@"tetete" button0:@"升级" button1:@"取消"];
//    [alertView showWithBlock:^(NSInteger i) {
//        if (i == 0) {
//            NSLog(@"xxx0000");
//        }else if (i == 1) {
//            NSLog(@"xxx1111");
//        }
//    }];
    
    
    ZAlertView* alertView = [[ZAlertView alloc] initWithTitle:nil bodyMsg:@"tetetefafafasfadsf站 Gaga 所带来的感觉啊的；个" button0:nil button1:nil];
    [alertView showUntill:3 withBlock:^(NSInteger i) {
        
    }];

}
@end
