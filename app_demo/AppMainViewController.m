//
//  AppMainViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/14.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppMainViewController.h"
#import "AppHomeViewController.h"
#import "AppFindBookViewController.h"

@implementation AppMainViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
        AppHomeViewController *homevc = [[AppHomeViewController alloc] init];
        UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:homevc];
        AppFindBookViewController *find = [[AppFindBookViewController alloc] init];
        UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:find];
        
        self.viewControllers = @[nc1, nc2];
    }
    
    return self;
}

@end
