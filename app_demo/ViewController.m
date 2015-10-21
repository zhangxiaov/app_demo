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

    DemoLabel *label = [[DemoLabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
    label.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:label];
    
    Regx *r = [[Regx alloc] init];
    [r test];
}

@end
