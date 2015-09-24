//
//  ViewController.m
//  app_demo
//
//  Created by 张新伟 on 15/9/22.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "ViewController.h"
#import "AppConfig.h"

@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSString *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollview];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = paths[0];
    
    NSArray *a2 = [fm subpathsOfDirectoryAtPath:[path stringByAppendingString:@"/books"] error:nil];
    
    for (NSString *p in a2) {
        NSString *fullpath = [[path stringByAppendingString:@"/books/"] stringByAppendingString:p];
        BOOL isDir;
        if ([fm fileExistsAtPath:fullpath isDirectory:&isDir] && isDir) {
            NSLog(@"p == %@, %d", p, isDir);
        }
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)scrollview {
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH*3, SCREEN_HEIGHT);
    }
    
    return _scrollview;
}

- (NSString *)data {
    if (_data == nil) {
        _data = @"";
    }
    
    return _data;
}

#pragma  mark delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
