//
//  AdViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/12/1.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "AdViewController.h"


@interface AdViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) BOOL isDragging;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation AdViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self.view addSubview:self.scrollView];
        [self.view addSubview:self.pageControl];
        
        self.view.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)viewDidLoad {
    int count = (int)self.dataArray.count;

    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*(count+2), 300);
    [self.scrollView scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 300) animated:NO];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    label.backgroundColor = ((UILabel *)self.dataArray[count -1]).backgroundColor;
    
    [self.scrollView addSubview:label];
    
    for (int i = 0; i < count; i++) {
        
        UILabel *label = self.dataArray[i];
        [self.scrollView addSubview:label];
    }
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*(count+1), 0, [UIScreen mainScreen].bounds.size.width, 300)];
    label2.backgroundColor = ((UILabel *)self.dataArray[0]).backgroundColor;
    [self.scrollView addSubview:label2];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(update) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark event

- (void)update {
    if (_isDragging) {
        return;
    }
    
    CGFloat offset = self.scrollView.contentOffset.x;
    [self.scrollView scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width + offset, 0, [UIScreen mainScreen].bounds.size.width, 300) animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isDragging = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = self.scrollView.contentOffset.x;
    if (offset == [UIScreen mainScreen].bounds.size.width*4) {
        [self.scrollView scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 300) animated:NO];
    }
    
    CGFloat s = 0.0;
    if (offset == s) {
        [self.scrollView scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width*3, 0, [UIScreen mainScreen].bounds.size.width, 300) animated:NO];
    }
    
    offset = self.scrollView.contentOffset.x;
    int n = (int)floor(offset / [UIScreen mainScreen].bounds.size.width);
    self.pageControl.currentPage = n - 1;

}

#pragma mark property

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400)];
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*5, 300);
        _scrollView.delegate = self;
        _scrollView.decelerationRate = 0.5;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        
//        UILabel *labelstart = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
//        labelstart.backgroundColor = [UIColor blueColor];
//        
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 300)];
//        label1.backgroundColor = [UIColor grayColor];
//        
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*2, 0, [UIScreen mainScreen].bounds.size.width, 300)];
//        label2.backgroundColor = [UIColor redColor];
//        
//        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*3, 0, [UIScreen mainScreen].bounds.size.width, 300)];
//        label3.backgroundColor = [UIColor blueColor];
//        
//        UILabel *labelend = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*4, 0, [UIScreen mainScreen].bounds.size.width, 300)];
//        labelend.backgroundColor = [UIColor grayColor];
//    
//        [_scrollView addSubview:labelstart];
//        [_scrollView addSubview:label1];
//        [_scrollView addSubview:label2];
//        [_scrollView addSubview:label3];
//        [_scrollView addSubview:labelend];
        
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 30, [UIScreen mainScreen].bounds.size.width, 30)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 3;
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];

    }
    
    return _pageControl;
}

- (NSMutableArray *)dataArray {
    _dataArray = [@[] mutableCopy];
    

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    label1.backgroundColor = [UIColor grayColor];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*2, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    label2.backgroundColor = [UIColor redColor];

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*3, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    label3.backgroundColor = [UIColor blueColor];
    
    [_dataArray addObject:label1];
    [_dataArray addObject:label2];
    [_dataArray addObject:label3];
    
    return _dataArray;
}

@end
