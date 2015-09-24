//
//  AppContentViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/9/24.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppContentViewController.h"

@interface AppContentViewController ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation AppContentViewController

- (void)viewDidLoad {
//    self = [super viewDidLoad];
//    self.title = @"";
    isTap = YES;
    [self.navigationController setNavigationBarHidden:isTap animated:YES];
    
    NSData *data = self.data;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isTap = !isTap;
    [self.navigationController setNavigationBarHidden:isTap animated:YES];
}

- (NSArray *)data {
    
    NSString *str = self.title;
    NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"] stringByAppendingString:str];
    return [NSData dataWithContentsOfFile:path];
}

@end
