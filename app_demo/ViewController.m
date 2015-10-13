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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
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
    [self data];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.tableView.tableHeaderView = self.headerView;
//    self.tableView.tableFooterView = self.footerView;
    
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
    controller.title = [bookView.bookname stringByDeletingPathExtension];
    controller.navigationController.navigationBarHidden = YES;
    
    [self.navigationController pushViewController:controller animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"bookcell"];
    }
    
    cell.detailTextLabel.text = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppContentViewController *controller = [[AppContentViewController alloc] init];
    controller.title = [self.data[indexPath.row] stringByDeletingPathExtension];
    controller.navigationController.navigationBarHidden = YES;
    
    [self.navigationController pushViewController:controller animated:NO];
}

@end
