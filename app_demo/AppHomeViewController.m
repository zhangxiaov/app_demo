//
//  AppHomeViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/14.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppHomeViewController.h"
//#import "AppContentViewController.h"
#import "AppConfig.h"
#import "UIImage+UIColor.h"
#import "AppTableViewCell.h"
#import "ContentViewController.h"

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
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0x38373C)] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
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
        _searchController.searchBar.keyboardType = UIKeyboardTypeASCIICapable;

        _searchController.searchBar.layer.borderColor = UIColorFromHex(0xff0000).CGColor;
        _searchController.searchBar.layer.borderWidth = 1.0;
        _searchController.searchBar.tintColor = [UIColor redColor];
        _searchController.searchBar.barTintColor = UIColorFromHex(0xEFEFF4);
        
        for (UIView *view in _searchController.searchBar.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *textField= (UITextField *)view;
                textField.layer.borderColor = UIColorFromHex(0xE1E2E5).CGColor;
                textField.layer.borderWidth = 1.0;
                return _searchController;
            }
            
            // for before iOS7.0
            for (UIView * s2 in view.subviews) {
                if ([s2 isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                    s2.layer.cornerRadius = 14;
                    s2.layer.borderWidth = 1.0;
                    s2.layer.borderColor = UIColorFromHex(0xff0000).CGColor;
                    return _searchController;
                }
            }
        }
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
    AppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookcell"];
    if (cell == nil) {
        cell = [[AppTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"bookcell"];
        cell.infoLabel.text = @"fafafafafaafafafafafsfdfkajslfjfl;asfjasflas;fjasffa;fjdsfasjfals;fjdsf;lasfsfj";
        cell.progressLabel.text = @"80%";
    }
    
    if (self.searchData) {
        cell.nameLabel.text = self.searchData[indexPath.row];
    }else {
        cell.nameLabel.text = self.data[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContentViewController *controller = [[ContentViewController alloc]
                                         initWithTitle:[self.data[indexPath.row] stringByDeletingPathExtension]];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"test");
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