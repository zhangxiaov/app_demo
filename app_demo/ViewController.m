//
//  ViewController.m
//  app_demo
//
//  Created by 张新伟 on 15/9/22.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "ViewController.h"
#import "AppBookView.h"
#import "AppConfig.h"
#import "AppContentViewController.h"

@interface ViewController () <AppBookViewDelegate>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation ViewController

- (void)viewDidLoad {
//    UIButton *btn = [[UIButton alloc] init];
//    [btn setTitle:@"点击" forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor grayColor];
//    btn.frame = CGRectMake(20, 100, 100, 30);
//    [btn addTarget:self action:@selector(didTap) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:btn];
    
    [super viewDidLoad];
    
    self.title = @"home";
    
    //#C7C1AA
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
//    self.navigationController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    return _footerView;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        
        int n = [self.data count];
        int row = n/3 + 1;
        if (n % 3 == 0) {
            row = n/3;
        }

        CGFloat STATUS_HEIGHT = [[UIApplication sharedApplication] statusBarFrame].size.height;
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [AppBookView height]*row)];

        NSInteger count = self.data.count;
        
        for (int i = 0; i < count; i++) {
            AppBookView *book = [[AppBookView alloc]init];
            book.delegate = self;
            
            NSLog(@"book name == %@", self.data[i]);
            
            [book setCover:@"" name:self.data[i] author:@"kongzi" bookid:i];
            
            CGFloat left = 0.0;
            CGFloat top = 0.0;
            
            if ((i+1)%3 == 0) {
                top = ((i+1)/3-1)*([AppBookView height] + 10);
                left = 3*NORMAL_PADDING + 2*[AppBookView width];
            }else {
                top = (i+1)/3*([AppBookView height] + 10);
                left = (i+1)%3*NORMAL_PADDING + ((i+1)%3-1)*[AppBookView width];
            }
            
            book.frame = CGRectMake(left, top, [AppBookView width], [AppBookView height]);
            [_headerView addSubview:book];
        }
    }
    
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)data {
    NSString *respath = [[NSBundle mainBundle] resourcePath];
    NSArray *data = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:respath error:nil] pathsMatchingExtensions:@[@"txt"]];
    
    return data;
}

#pragma mark

- (void)bookView:(AppBookView *)bookView didTap:(UIButton *)button {
    
    AppContentViewController *controller = [[AppContentViewController alloc] init];
    controller.title = bookView.bookname;
    controller.navigationController.navigationBarHidden = YES;
    
    [self.navigationController pushViewController:controller animated:NO];
}

@end
