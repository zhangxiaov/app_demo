//
//  ViewController.m
//  app_demo
//
//  Created by 张新伟 on 15/9/22.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "ViewController.h"
#import "DemoLabel.h"
#import "AppConfig.h"
#import "Regx.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];

    DemoLabel *label = [[DemoLabel alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 50)];
    label.backgroundColor = [UIColor whiteColor];
    label.originString = @"<font color=green >fafa正发发送；法律界阿说仿佛看见阿萨德；福建阿萨德发了；喀什大家发送了；但萨科技发达老师；福建阿萨德了；飞机<img src=MISAskAddFile width=40 height=40 />发似懂非懂fasfafasffafafasdfasfasfsafsafdasfhd电话卡的首发式分手<font color=black fontSize=19 >机登录福建阿萨德发；就撒；弗萨里；浮动解决了疯狂的福建省；<a href=1111 >xxxxxxxxx啊</a>fadfasfsaofpasdjfsapdfsdf";
    
    [self.view addSubview:label];
}

@end
