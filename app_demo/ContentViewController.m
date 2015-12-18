//
//  ContentViewController.m
//  app_demo
//
//  Created by zhangxinwei on 15/10/30.
//  Copyright © 2015年 张新伟. All rights reserved.
//

#import "ContentViewController.h"
#import "UITouchScrollView.h"
#import "Pagination.h"
#import "AppLabel.h"
#import "AppConfig.h"
#import "DemoLabel.h"
#import "CommentViewController.h"

@interface ContentViewController () <UIScrollViewDelegate> {
    NSInteger totalPages;
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
@property (nonatomic, strong) Pagination *pagevc;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *clearView;

@end

@implementation ContentViewController

- (instancetype)initWithTitle:(NSString *)bookTitle
{
    self = [super init];
    if (self) {
        self.bookTitle = bookTitle;
        self.title = bookTitle;
        
        [self.view addSubview:self.headerView];
        [self.view addSubview:self.scrollView];
        [self.view addSubview:self.footerView];
        [self.view addSubview:self.toolView];
        
        _pagevc = [[Pagination alloc] initWithTitle:self.bookTitle];
        totalPages = _pagevc.array.count;
        
        pageDragging = 0;
        
        isTap = YES;
        
        startPageOffsetx = 0;
        
        if (totalPages == 1) {
            [self labels:1];
            DemoLabel *label = ((AppLabel *)self.labels[0]).label;
            label.originString = [_pagevc strAtPos:1-1];
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CONTENT_HEIGHT);
        }else {
            [self labels:totalPages];
            
            NSString *s = [_pagevc strAtPos:0];
            ((AppLabel *)self.labels[0]).label.originString = s;
            NSString *s2 = [_pagevc strAtPos:1];
            ((AppLabel *)self.labels[1]).label.originString = s2;
            
            
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * totalPages, CONTENT_HEIGHT);
        }
        
        _footerView.text = [NSString stringWithFormat:@"%d/%ld",  0, totalPages - 1];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
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
    
    if (thePage >= totalPages) {
        return;
    }
    
    NSString * s = [_pagevc strAtPos:thePage];
    
    if (s == nil) {
        return;
    }
    
    ((AppLabel *)self.labels[theLabel]).label.originString = s;
    CGRect rect = CGRectMake((thePage)*SCREEN_WIDTH, 0, SCREEN_WIDTH, CONTENT_HEIGHT);
    ((AppLabel *)self.labels[theLabel]).frame = rect;
}

- (void)updateFooter {
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    
    if (direction > 0) {
        _footerView.text = [NSString stringWithFormat:@"%d/%ld",  ++ pageDragging, totalPages - 1];
    }else if (direction < 0) {
        _footerView.text = [NSString stringWithFormat:@"%d/%ld",  -- pageDragging, totalPages - 1];
    }
}

#pragma mark action

//- (void)hidetoolview {
////    self.toolView.hidden = YES;
////    self.leftView.hidden = YES;
////    self.clearView.hidden = YES;
//    
//    [self.toolView.window resignKeyWindow];
//}
//
- (void)look1 {
//    self.toolView.hidden = YES;
    self.leftView.hidden = NO;
    self.clearView.hidden = NO;
}

- (void)look2 {

}

- (void)look3 {

}

- (void)look4 {

//    [UIView beginAnimations:@"flipping view" context:nil];
//    [UIView setAnimationDuration:0.3];
    CGRect rect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
    self.toolView.frame = rect;
//    [UIView commitAnimations];
    
   
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.7f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
////    transition.type = @"cube";
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    transition.delegate = self;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
     CommentViewController *controller = [[CommentViewController alloc] initWithBook:0];
    [self.navigationController pushViewController:controller animated:YES];
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
            label.label.originString= [NSString stringWithFormat:@"t%d", i];
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
        
//        _readData.curPage = 1;
        _labels = a;
    }
    
    return _labels;
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    startPageOffsetx = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    pageDragging = floor(startPageOffsetx / SCREEN_WIDTH); // from 0
    
    int direction = self.scrollView.contentOffset.x - startPageOffsetx;
    if (direction > 0 && pageDragging < totalPages - 1) {
        
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(pageDragging + 1), 0) animated:YES];
        [self moveLabel];
    }else if (direction < 0 && pageDragging > 0){
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(pageDragging - 1), 0) animated:YES];
        [self moveLabel];
    }
    
    [self updateFooter];
}

#pragma mark setter getter


- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _headerView;
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20, SCREEN_WIDTH, 20)];
        _footerView.backgroundColor = [UIColor whiteColor];
        _footerView.text = [NSString stringWithFormat:@"%d/%ld",  pageDragging, totalPages];
        _footerView.textColor = [UIColor grayColor];
        
    }
    
    return _footerView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, CONTENT_HEIGHT)];
        _scrollView.backgroundColor = [UIColor grayColor];
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.decelerationRate = 1.0;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
    }
    
    return _scrollView;
}

- (UIView *)clearView {
    if (_clearView == nil) {
        _clearView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, SCREEN_HEIGHT)];
        _clearView.hidden = YES;
        _clearView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidetoolview)];
        [_clearView addGestureRecognizer:g];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_clearView];
    }
    
    return _clearView;
}

- (UIView *)leftView {
    if (_leftView == nil) {
        _leftView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, SCREEN_HEIGHT)];
        _leftView.hidden = YES;
        _leftView.backgroundColor = [UIColor grayColor];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_leftView];
    }
    
    return _leftView;
}

- (UIView *)toolView {
    if (_toolView == nil) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
        _toolView.backgroundColor = UIColorFromHex(0xF3F3F3);
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
        layer.backgroundColor = UIColorFromHex(0xD3D3D3).CGColor;
        
        [_toolView.layer addSublayer:layer];
        
        CGFloat w = 60;
        CGFloat h = 30;
        CGFloat left = (SCREEN_WIDTH - w*4)/5;
        
        UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(left, 10, w, h)];
        [b1 setTitle:@"书目" forState:UIControlStateNormal];
        b1.titleLabel.font = [UIFont systemFontOfSize:14];
        [b1 setTitleColor:UIColorFromHex(0x333) forState:UIControlStateNormal];
        [b1 addTarget:self action:@selector(look1) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(left*2+w, 10, w, h)];
        [b2 setTitle:@"字长" forState:UIControlStateNormal];
        b2.titleLabel.font = [UIFont systemFontOfSize:14];
        [b2 setTitleColor:UIColorFromHex(0x333) forState:UIControlStateNormal];
        [b2 addTarget:self action:@selector(look2) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(left*3+2*w, 10, w, h)];
        [b3 setTitle:@"换颜" forState:UIControlStateNormal];
        b3.titleLabel.font = [UIFont systemFontOfSize:14];
        [b3 setTitleColor:UIColorFromHex(0x333) forState:UIControlStateNormal];
        [b3 addTarget:self action:@selector(look3) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *b4 = [[UIButton alloc] initWithFrame:CGRectMake(left*4+3*w, 10, w, h)];
        [b4 setTitle:@"评书" forState:UIControlStateNormal];
        b4.titleLabel.font = [UIFont systemFontOfSize:14];
        [b4 setTitleColor:UIColorFromHex(0x333) forState:UIControlStateNormal];
        [b4 addTarget:self action:@selector(look4) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_toolView addSubview:b1];
        [_toolView addSubview:b2];
        [_toolView addSubview:b3];
        [_toolView addSubview:b4];
        
    }
    
    return _toolView;
}

@end
