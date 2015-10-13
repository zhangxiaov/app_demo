//
//  AppContentViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/9/24.
//  Copyright (c) 2015年 张新伟. All rights reserved.
//

#import "AppContentViewController.h"
#import "AppConfig.h"
#import "AppLabel.h"
#import <CoreText/CoreText.h>
#import "UITouchScrollView.h"
#import "SqlOP.h"
#import "ReadDataByBlock.h"

@interface AppContentViewController () <UIScrollViewDelegate>{
    int totalPages;
    int startPageOffsetx;
    int pageDragging;
    long len;
    BOOL dragging;
}
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *footerView;
@property (nonatomic, strong) UITouchScrollView *scrollView;
@property (nonatomic, strong) ReadDataByBlock *readData;
@end

@implementation AppContentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _readData = [[ReadDataByBlock alloc] initWithTitle:self.title];
    
    totalPages = _readData.possibleTotalPages;
    pageDragging = 0;
    
    isTap = YES;
    
    startPageOffsetx = 0;
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.footerView];
    [self.navigationController setNavigationBarHidden:isTap animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
  
    if (totalPages == 1) {
        [self labels:1];
        ((AppLabel *)self.labels[0]).label.text = [_readData strForPage:0 isReverse:NO];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CONTENT_HEIGHT);
    }else {
        [self labels:totalPages];
        ((AppLabel *)self.labels[0]).label.text = [_readData strForPage:0 isReverse:NO];
        ((AppLabel *)self.labels[1]).label.text = [_readData strForPage:1 isReverse:NO];

        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * totalPages, CONTENT_HEIGHT);
    }

    _footerView.text = [NSString stringWithFormat:@"%d/%d",  0, totalPages - 1];

    
}

- (void)moveLabel {
    int theLabel = 0;
    int thePage = 0;
    BOOL isReverse = NO;
    
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    if (direction > 0) {
        thePage = pageDragging + 2;
        theLabel = (thePage) % 3;
    }else if (direction < 0) {
        thePage = pageDragging - 2;
        if (thePage < 0) {
            return;
        }
        
        theLabel = (thePage) % 3;
        isReverse = YES;
    }
    
    NSString * s = [_readData strForPage:thePage isReverse:isReverse];
//    NSLog(@"page = %d, s = %@", thePage, s);
    
    if (s == nil) {
        return;
    }
    
    ((AppLabel *)self.labels[theLabel]).label.text = s;
    CGRect rect = CGRectMake((thePage)*SCREEN_WIDTH, 0, SCREEN_WIDTH, CONTENT_HEIGHT);
    ((AppLabel *)self.labels[theLabel]).frame = rect;
}

- (void)updateFooter {
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    
    if (direction > 0) {
        _footerView.text = [NSString stringWithFormat:@"%d/%d",  ++ pageDragging, totalPages - 1];
    }else if (direction < 0) {
        _footerView.text = [NSString stringWithFormat:@"%d/%d",  -- pageDragging, totalPages - 1];
    }
}

- (void)reloadData {
    if (_readData.dataPosition < _readData.dataLen) {
        int a = (int)(_readData.dataLen - _readData.dataPosition) / _readData.oneLabelBytes + 1;
        totalPages += a;
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * totalPages, CONTENT_HEIGHT);
    }
}

#pragma property

- (NSArray *)labels:(NSInteger)n {
    if (_labels == nil) {
        NSMutableArray *a = [[NSMutableArray alloc] init];
        
        if (n > 2) {
            n = 3;
        }
        
        for (int i = 0; i < n; i++) {
            AppLabel *label = [[AppLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, CONTENT_HEIGHT)];
            [a addObject:label];
            
//            if (i == 0) {
//                label.backgroundColor = [UIColor redColor];
//            }else if (i == 1) {
//                label.backgroundColor = [UIColor greenColor];
//            }else {
//                label.backgroundColor = [UIColor blueColor];
//            }
            
            [self.scrollView addSubview:label];
        }
    
        _readData.curPage = 1;
        _labels = a;
    }
    
    return _labels;
    
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        _headerView.backgroundColor = [UIColor grayColor];
    }
    
    return _headerView;
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20, SCREEN_WIDTH, 20)];
        _footerView.backgroundColor = [UIColor grayColor];
        _footerView.text = [NSString stringWithFormat:@"%d/%d",  pageDragging, totalPages];
        _footerView.textColor = [UIColor whiteColor];
        
    }
    
    return _footerView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, CONTENT_HEIGHT)];
        _scrollView.backgroundColor = [UIColor grayColor];
//        _scrollView.touchesdelegate = self;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.decelerationRate = 0.0;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
    }
    
    return _scrollView;
}

#pragma mark

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    startPageOffsetx = scrollView.contentOffset.x;
    
//    NSLog(@"start : %d", startPageOffsetx);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    pageDragging = floor(startPageOffsetx / SCREEN_WIDTH); // from 0
    
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    if (direction > 0 && pageDragging < totalPages - 1) {
        
        if (pageDragging == totalPages - 1 - 1){
            [self reloadData];
        }
        
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(pageDragging + 1), 0) animated:NO];
        [self moveLabel];
    }else if (direction < 0 && pageDragging > 0){
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(pageDragging - 1), 0) animated:NO];
        [self moveLabel];
    }
    
    [self updateFooter];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    dragging = NO;
}

@end
