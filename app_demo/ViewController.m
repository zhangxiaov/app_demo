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
#import "Pagination.h"
#import "CheckboxWithTitle.h"
#import "Animationdemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
//        TextBuff *b = [[TextBuff alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    DemoLabel *label = [[DemoLabel alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 50)];
//    label.backgroundColor = [UIColor whiteColor];
//    label.originString = @"<font color=green >fafa正发发送；法律界阿说仿佛看见阿萨德；福建阿萨德发了；喀什大家发送了；但萨科技发达老师；福建阿萨德了；飞机<img src=MISAskAddFile width=40 height=40 />发似懂非懂fasfafasffafafasdfasfasfsafsafdasfhd电话卡的首发式分手<font color=black fontSize=19 >机登录福建阿萨德发；就撒；弗萨里；浮动解决了疯狂的福建省；<a href=1111 >xxxxxxxxx啊</a>fadfasfsaofpasdjfsapdfsdf";
//    
//    [self.view addSubview:label];
    
    
    //===
//    CheckboxWithTitle *checkbox = [[CheckboxWithTitle alloc] initWithFrame:CGRectMake(50, 50, 100, 30)];
//    checkbox.title.text = @"fafafa";
//    checkbox.block = ^(CheckboxWithTitle *checkbox) {
//        if (checkbox.checked) {
//            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"faaf" message:@"fafaaf" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
//            [view show];
//        }
//    };
//    self.view.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:checkbox];
    
    Animationdemo *a = [[Animationdemo alloc] initWithFrame:CGRectMake(0, 350, 100, 30)];
    [self.view addSubview:a];
}

@end
