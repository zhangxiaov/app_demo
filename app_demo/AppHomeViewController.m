//
//  AppHomeViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/14.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppHomeViewController.h"
#import "AppContentViewController.h"

@interface AppHomeViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *visableArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation AppHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Home";
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
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

#pragma mark UITableViewDelegate

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