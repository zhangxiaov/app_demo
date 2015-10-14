//
//  AppHomeViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/14.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppHomeViewController.h"
#import "AppContentViewController.h"
#import "AppConfig.h"

@interface AppHomeViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchData;
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
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self data];
    
    self.searchData = self.data;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UISearchController *)searchController {
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] init];
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        [_searchController setHidesNavigationBarDuringPresentation:NO];
        [_searchController setDimsBackgroundDuringPresentation:NO];
        [_searchController.searchBar sizeToFit];
        _searchController.searchBar.keyboardType = UIKeyboardTypeNamePhonePad;

        _searchController.searchBar.tintColor = [UIColor redColor];
        _searchController.searchBar.barTintColor = UIColorFromHex(0xeeeeee);
    }
    
    return _searchController;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
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
    if (!self.searchData && self.searchData.count == 0) {
        _searchData = _data;
    }
    return _searchData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"bookcell"];
    }
    
    if (self.searchData) {
        cell.detailTextLabel.text = self.searchData[indexPath.row];
    }else {
        cell.detailTextLabel.text = self.data[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppContentViewController *controller = [[AppContentViewController alloc] init];
    controller.title = [self.data[indexPath.row] stringByDeletingPathExtension];
    controller.navigationController.navigationBarHidden = YES;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *filterString = searchController.searchBar.text;
    
    if ([filterString isEqualToString:@""] || !filterString) {
        self.searchData = self.data;
    }else {
        self.searchData = [[NSMutableArray alloc] init];
        for (NSString *s in self.data) {
            if ([s containsString:filterString]) {
                [self.searchData addObject:s];
            }
        }
    }
    
    [self.tableView reloadData];
}

@end