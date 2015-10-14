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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *visableArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;


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
    
//    UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//    searchbar.placeholder = @"搜索";
    

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    UIView *v = _searchController.view;
    
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    [_searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    _searchController.searchBar.backgroundColor = [UIColor redColor];
    
    self.title = @"home";
    
    //#C7C1AA
    [self data];
    
    self.visableArray = self.data;
    
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
    if (!self.visableArray && self.visableArray.count == 0) {
        _visableArray = _data;
    }
    return _visableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"bookcell"];
    }
    
    if (self.visableArray) {
        cell.detailTextLabel.text = self.visableArray[indexPath.row];
    }else {
       cell.detailTextLabel.text = self.data[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppContentViewController *controller = [[AppContentViewController alloc] init];
    controller.title = [self.data[indexPath.row] stringByDeletingPathExtension];
    controller.navigationController.navigationBarHidden = YES;
    
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *filterString = searchController.searchBar.text;
    
    if ([filterString isEqualToString:@""] || !filterString) {
        self.visableArray = self.data;
    }else {
        self.visableArray = [[NSMutableArray alloc] init];
        for (NSString *s in self.data) {
            if ([s containsString:filterString]) {
                [self.visableArray addObject:s];
            }
        }
    }
    
    [self.tableView reloadData];
}

@end
